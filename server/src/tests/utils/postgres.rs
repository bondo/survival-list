use std::{
    future::Future,
    panic::UnwindSafe,
    time::{Duration, Instant},
};

use dockertest::{waitfor::RunningWait, Composition, DockerTest, Image};
use futures_util::FutureExt;
use sqlx::postgres::PgPoolOptions;
use tokio::{runtime::Handle, task, time::sleep};

const POSTGRES_PASSWORD: &str = "postgres";

pub fn with_postgres_ready<T, Fut>(f: T)
where
    T: FnOnce(String) -> Fut + UnwindSafe,
    Fut: Future<Output = ()> + Send + UnwindSafe + 'static,
{
    let timeout = Duration::from_secs(10);
    let start = Instant::now();

    let mut test = DockerTest::new();

    let image = Image::with_repository("postgres").tag("15.3-alpine3.18");
    let mut composition = Composition::with_image(image)
        .with_env(
            [(
                "POSTGRES_PASSWORD".to_string(),
                POSTGRES_PASSWORD.to_string(),
            )]
            .into(),
        )
        .with_wait_for(Box::new(RunningWait {
            check_interval: 1,
            max_checks: timeout.as_secs() + 1,
        }));
    composition.publish_all_ports();
    test.add_composition(composition);

    test.run(|ops| {
        let url = {
            let handle = ops.handle("postgres");
            let (ip, port) = handle
                .host_port(5432)
                .expect("Should have port 5432 mapped");
            format!("postgresql://postgres:{POSTGRES_PASSWORD}@{ip}:{port}/postgres")
        };

        block_on(async {
            tokio::select! {
                _ = wait_for_connection(&url) => (),
                _ = sleep(timeout - start.elapsed()) => panic!("Connection timeout after {:?}", start.elapsed()),
            }
        });

        let res = block_on(
            async {
                f(url).await;
            }.catch_unwind()
        );

        async {res.unwrap()}
    });
}

fn block_on<F: Future>(future: F) -> F::Output {
    task::block_in_place(|| Handle::current().block_on(future))
}

async fn wait_for_connection(url: &str) {
    while PgPoolOptions::new().connect(url).await.is_err() {
        sleep(Duration::from_millis(100)).await;
    }
}
