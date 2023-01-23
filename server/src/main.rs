use hyper::{
    server::conn::AddrStream,
    service::{make_service_fn, service_fn},
    Body, Request, Response, Server,
};
use sqlx::Error;
use std::env;

mod db;
use db::Database;

#[tokio::main]
async fn main() {
    pretty_env_logger::init();

    let mut port: u16 = 8080;
    match env::var("PORT") {
        Ok(p) => {
            match p.parse::<u16>() {
                Ok(n) => {
                    port = n;
                }
                Err(_e) => {}
            };
        }
        Err(_e) => {}
    };
    let addr = ([0, 0, 0, 0], port).into();

    let database: &Database = Box::leak(Box::new(
        Database::new()
            .await
            .expect("should be able to connect to database"),
    ));

    database
        .migrate()
        .await
        .expect("should be able to migrate database");

    let make_svc = make_service_fn(|_socket: &AddrStream| async move {
        Ok::<_, Error>(service_fn(move |_: Request<Body>| async move {
            let tasks = database.get_tasks().await?;
            Ok::<_, Error>(Response::new(Body::from(format!("{:?}", tasks))))
        }))
    });

    let server = Server::bind(&addr).serve(make_svc);

    println!("Listening on http://{}", addr);
    if let Err(e) = server.await {
        eprintln!("server error: {}", e);
    }
}
