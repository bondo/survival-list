use std::{
    net::{SocketAddr, TcpListener},
    panic::UnwindSafe,
    time::{Duration, Instant},
};

use futures_core::Future;
use rand::{thread_rng, Rng};
use tokio::time::sleep;
use tokio_util::sync::CancellationToken;
use tonic::transport::{Channel, Uri};

use crate::{
    server,
    service::proto::ping::v1::{ping_api_client::PingApiClient, PingRequest},
    tests::utils::AuthStub,
};

use super::{block_on, with_postgres_ready};

pub(crate) fn with_server_ready<T, Fut>(f: T)
where
    T: FnOnce(Uri) -> Fut + UnwindSafe,
    Fut: Future<Output = ()> + Send + 'static,
{
    let timeout = Duration::from_secs(10);
    let start = Instant::now();

    with_postgres_ready(|database_url| {
        let addr = get_available_address();
        let uri = format!("http://{}", addr).parse().unwrap();
        let token = CancellationToken::new();

        let cloned_token = token.clone();
        let server_handle = tokio::spawn(async move {
            let options = server::Options {
                addr,
                auth: AuthStub,
                database_url,
            };

            tokio::select! {
                res = server::start(options) => res.unwrap(),
                _ = cloned_token.cancelled() => (),
            }
        });

        block_on(async {
            tokio::select! {
                _ = wait_for_connection(&uri) => (),
                _ = sleep(timeout - start.elapsed()) => panic!("Connection timeout after {:?}", start.elapsed()),
            }

            tokio::select! {
                _ = f(uri) => (),
                _ = sleep(timeout - start.elapsed()) => panic!("Test timeout after {:?}", start.elapsed()),
            }
        });

        token.cancel();
        async {
            server_handle.await.unwrap();
        }
    });
}

fn get_available_address() -> SocketAddr {
    let mut rng = thread_rng();
    loop {
        let port = rng.gen_range(8081..65535);
        let addr = SocketAddr::from(([0, 0, 0, 0], port));
        if TcpListener::bind(addr).is_ok() {
            return addr;
        }
    }
}

async fn wait_for_connection(uri: &Uri) {
    while !is_server_ready(uri).await {
        tokio::time::sleep(tokio::time::Duration::from_millis(100)).await;
    }
}

async fn is_server_ready(uri: &Uri) -> bool {
    let Ok(channel) = Channel::builder(uri.clone())
        .connect()
        .await else {
            return false;
    };

    PingApiClient::new(channel)
        .ping(PingRequest {})
        .await
        .is_ok_and(|res| res.into_inner().message == "pong")
}
