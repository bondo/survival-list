use std::{sync::Arc, time::Duration};

use jsonwebtoken::TokenData;
use tokio::{
    sync::{
        oneshot::{self, error::TryRecvError, Sender},
        Mutex,
    },
    time::sleep,
};

use super::{
    fetch_keys::{fetch_keys, JwkKeys},
    verifier::{Claims, JwkVerifier},
};

pub struct JwkAuth {
    verifier: Arc<Mutex<JwkVerifier>>,
    cleanup: Mutex<Option<Sender<&'static str>>>,
}

impl Drop for JwkAuth {
    fn drop(&mut self) {
        // Stop the update thread when the updater is destructed
        let mut guard = self.cleanup.blocking_lock();
        println!("Stopping...");
        if let Some(shutdown_tx) = guard.take() {
            let _ = shutdown_tx.send("stop");
        }
    }
}

impl JwkAuth {
    pub async fn new() -> JwkAuth {
        let jwk_key_result = fetch_keys().await;
        let jwk_keys: JwkKeys = match jwk_key_result {
            Ok(keys) => keys,
            Err(_) => {
                panic!("Unable to fetch jwk keys! Cannot verify user tokens! Shutting down...")
            }
        };
        let verifier = Arc::new(Mutex::new(JwkVerifier::new(jwk_keys.keys)));

        let mut instance = JwkAuth {
            verifier: verifier,
            cleanup: Mutex::new(None),
        };

        instance.start_key_update().await;
        instance
    }

    pub fn verify(&self, token: &String) -> Option<TokenData<Claims>> {
        let verifier = self.verifier.blocking_lock();
        verifier.verify(token)
    }

    async fn start_key_update(&mut self) {
        let verifier_ref = Arc::clone(&self.verifier);

        let (shutdown_tx, mut shutdown_rx) = oneshot::channel();

        tokio::spawn(async move {
            loop {
                let duration = match fetch_keys().await {
                    Ok(jwk_keys) => {
                        {
                            let mut verifier = verifier_ref.blocking_lock();
                            verifier.set_keys(jwk_keys.keys);
                        }

                        println!(
                            "Updated JWK keys. Next refresh will be in {:?}",
                            jwk_keys.validity
                        );
                        jwk_keys.validity
                    }
                    Err(_) => Duration::from_secs(10),
                };
                sleep(duration).await;

                if let Ok(_) | Err(TryRecvError::Closed) = shutdown_rx.try_recv() {
                    break;
                }
            }
        });

        let mut cleanup = self.cleanup.lock().await;
        *cleanup = Some(shutdown_tx);
    }
}
