use std::{
    sync::{
        atomic::{AtomicBool, Ordering::Relaxed},
        Arc,
    },
    time::Duration,
};

use anyhow::Context;
use futures_core::Future;
use jsonwebtoken::TokenData;
use log::info;
use tokio::{
    runtime::Handle,
    sync::{
        oneshot::{self, Sender},
        Mutex, RwLock,
    },
    task, time,
};

use super::{
    fetch_keys::fetch_keys,
    verifier::{Claims, JwkVerifier},
};

struct Cleanup {
    notifier: Mutex<Option<Sender<()>>>,
    should_close: AtomicBool,
}

pub struct JwkAuth {
    verifier: Arc<RwLock<JwkVerifier>>,
    cleanup: Arc<Cleanup>,
}

fn await_sync<F: Future>(future: F) -> F::Output {
    task::block_in_place(|| Handle::current().block_on(future))
}

impl Drop for JwkAuth {
    fn drop(&mut self) {
        info!("Dropping JwkAuth");

        self.cleanup.should_close.store(true, Relaxed);

        let mut guard = await_sync(self.cleanup.notifier.lock());
        if let Some(shutdown_tx) = guard.take() {
            shutdown_tx.send(()).ok();
        }
    }
}

impl JwkAuth {
    pub async fn new() -> JwkAuth {
        let jwk_keys = fetch_keys()
            .await
            .context("Unable to fetch jwk keys! Cannot verify user tokens! Shutting down...")
            .unwrap();

        let verifier = Arc::new(RwLock::new(JwkVerifier::new(jwk_keys.keys)));

        let mut instance = JwkAuth {
            verifier,
            cleanup: Arc::new(Cleanup {
                notifier: Mutex::new(None),
                should_close: AtomicBool::new(false),
            }),
        };

        instance.start_key_update().await;
        instance
    }

    pub fn verify(&self, token: &str) -> Option<TokenData<Claims>> {
        let verifier = await_sync(self.verifier.read());
        verifier.verify(token)
    }

    async fn start_key_update(&mut self) {
        let verifier = Arc::clone(&self.verifier);
        let cleanup = Arc::clone(&self.cleanup);

        tokio::spawn(async move {
            loop {
                if cleanup.should_close.load(Relaxed) {
                    info!("Stopping key update thread");
                    break;
                }

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

                let (cleanup_tx, cleanup_rx) = oneshot::channel::<()>();
                {
                    let mut cleanup = cleanup.notifier.lock().await;
                    *cleanup = Some(cleanup_tx);
                }

                if cleanup.should_close.load(Relaxed) {
                    info!("Stopping key update thread");
                    break;
                }

                time::timeout(duration, cleanup_rx).await.ok();
            }
        });
    }
}
