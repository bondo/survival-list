use std::{convert::Infallible, env, str};

use hyper::{
    body::{self, HttpBody},
    server::conn::AddrStream,
    service::{make_service_fn, service_fn},
    Body, Method, Request, Response, Server,
};
use serde::Deserialize;
use serde_json::{json, Value};

mod db;
use db::Database;

mod error;
use error::{ClientError, Error};

async fn shutdown_signal() {
    // Wait for the CTRL+C signal
    tokio::signal::ctrl_c()
        .await
        .expect("failed to install CTRL+C signal handler");
}

#[tokio::main]
async fn main() {
    pretty_env_logger::init();

    let port = env::var("PORT")
        .ok()
        .and_then(|p| p.parse().ok())
        .unwrap_or(8080);
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
        Ok::<_, Infallible>(service_fn(move |req: Request<Body>| async move {
            match dispatch(database, req).await {
                Ok(value) => Response::builder().body(json!({ "result": value }).to_string()),
                Err(e) => {
                    let error = format!("{e}");
                    Response::builder()
                        .status(e.status())
                        .body(json!({ "error": error }).to_string())
                }
            }
        }))
    });

    let server = Server::bind(&addr).serve(make_svc);

    let graceful = server.with_graceful_shutdown(shutdown_signal());

    println!("Listening on http://{}", addr);
    if let Err(e) = graceful.await {
        eprintln!("server error: {}", e);
    }
}

async fn dispatch(db: &Database, req: Request<Body>) -> Result<Value, Error> {
    match (req.method(), req.uri().path()) {
        (&Method::GET, "/tasks") => {
            let tasks = db.get_tasks().await?;
            Ok(json!(tasks))
        }

        (&Method::POST, "/task") => {
            #[derive(Deserialize)]
            struct ParsedBody {
                title: String,
            }

            let body: ParsedBody = parse_body(req).await?;
            let result = db.create_task(&body.title).await?;
            Ok(json!(result))
        }

        _ => Err(ClientError::NotFoundError.into()),
    }
}

async fn parse_body<'a, T>(req: Request<Body>) -> Result<T, ClientError>
where
    T: Deserialize<'a>,
{
    let upper = req.body().size_hint().upper().unwrap_or(u64::MAX);
    if upper > 1024 * 64 {
        return Err(ClientError::PayloadTooLarge);
    }

    let body = req.into_body();
    let bytes = body::to_bytes(body).await?;
    // let str = String::from_utf8(bytes.into_iter().collect())?;
    // serde_json::from_str(Box::leak(Box::new(str))).map_err(|e| e.into())

    let str = str::from_utf8(&bytes[..])?;
    serde_json::from_str(str).map_err(|e| e.into())
}
