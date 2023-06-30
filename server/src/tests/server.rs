use std::{
    net::{SocketAddr, TcpListener},
    panic::UnwindSafe,
    time::{Duration, Instant},
};

use futures_core::Future;
use tokio::{runtime::Handle, task, time::sleep};
use tokio_util::sync::CancellationToken;
use tonic::transport::{Channel, Uri};

use crate::{
    server,
    service::grpc::ping::{api_client::ApiClient as PingClient, PingRequest},
};

use super::with_postgres_ready;

pub fn with_server_ready<T, Fut>(f: T)
where
    T: FnOnce(Uri) -> Fut + UnwindSafe,
    Fut: Future<Output = ()> + Send + 'static,
{
    let timeout = Duration::from_secs(10);
    let start = Instant::now();

    with_postgres_ready(|url| {
        let addr = get_available_address().unwrap();
        let uri = format!("http://{}", addr).parse().unwrap();
        let token = CancellationToken::new();

        let cloned_token = token.clone();
        let server_handle = tokio::spawn(async move {
            tokio::select! {
                res = server::start(addr, &url) => res.unwrap(),
                _ = cloned_token.cancelled() => (),
            }
        });

        block_on(async {
            tokio::select! {
                _ = wait_for_connection(&uri) => (),
                _ = sleep(timeout - start.elapsed()) => panic!("Connection timeout after {:?}", start.elapsed()),
            }
        });

        block_on(async {
            f(uri).await;
            token.cancel();
        });

        async {
            server_handle.await.unwrap();
        }
    });
}

fn block_on<F: Future>(future: F) -> F::Output {
    task::block_in_place(|| Handle::current().block_on(future))
}

fn get_available_address() -> Option<SocketAddr> {
    (8081..65535)
        .map(|port| SocketAddr::from(([0, 0, 0, 0], port)))
        .find(|addr| TcpListener::bind(addr).is_ok())
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

    PingClient::new(channel)
        .ping(PingRequest {})
        .await
        .is_ok_and(|res| res.into_inner().message == "pong")
}
