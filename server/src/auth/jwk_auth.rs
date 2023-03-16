use std::{sync::Arc, time::Duration};

use anyhow::Context;
use jsonwebtoken::TokenData;
use log::info;
use tokio::{
    runtime::Handle,
    sync::{
        watch::{self, Receiver, Sender},
        RwLock,
    },
    time,
};

use super::{
    fetch_keys::fetch_keys,
    verifier::{Claims, JwkVerifier},
};

pub struct Cleanup {
    sender: Sender<bool>,
    receiver: Receiver<bool>,
}

impl Cleanup {
    fn new() -> Self {
        let (sender, receiver) = watch::channel(false);
        Self { sender, receiver }
    }

    fn send_exit_signal(&self) {
        self.sender.send(true).ok();
    }

    fn should_exit(&self) -> bool {
        *self.receiver.borrow()
    }
}

pub struct JwkAuth {
    verifier: Arc<RwLock<JwkVerifier>>,
    cleanup: Arc<Cleanup>,
}

impl Drop for JwkAuth {
    fn drop(&mut self) {
        self.cleanup.send_exit_signal();
    }
}

impl JwkAuth {
    pub async fn new() -> JwkAuth {
        let jwk_keys = fetch_keys()
            .await
            .context("Unable to fetch jwk keys! Cannot verify user tokens! Shutting down...")
            .unwrap();

        let verifier = Arc::new(RwLock::new(JwkVerifier::new(jwk_keys.keys)));

        let instance = JwkAuth {
            verifier,
            cleanup: Arc::new(Cleanup::new()),
        };

        instance.start_key_update().await;
        instance
    }

    pub fn verify(&self, token: &str) -> Option<TokenData<Claims>> {
        let verifier = Handle::current().block_on(self.verifier.read());
        verifier.verify(token)
    }

    async fn start_key_update(&self) {
        let verifier = Arc::clone(&self.verifier);

        let cleanup = Arc::clone(&self.cleanup);

        tokio::spawn(async move {
            let mut cleanup_receiver = cleanup.receiver.clone();

            loop {
                if cleanup.should_exit() {
                    info!("Stopping key update thread");
                    break;
                }
                tokio::select! {
                    _ = cleanup_receiver.changed() => {
                        continue;
                    }
                    _ = key_update(&verifier) => {}
                }
            }
        });
    }
}

async fn key_update(verifier: &Arc<RwLock<JwkVerifier>>) {
    let duration = match fetch_keys().await {
        Ok(jwk_keys) => {
            {
                let mut verifier = verifier.write().await;
                verifier.set_keys(jwk_keys.keys);
            }

            info!(
                "Updated JWK keys. Next refresh will be in {:?}",
                jwk_keys.validity
            );
            jwk_keys.validity
        }
        Err(_) => Duration::from_secs(10),
    };

    time::sleep(duration).await;
}
