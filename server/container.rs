use std::process::{Command, Stdio};

use self::error::Error;

pub fn setup() -> Result<(), Error> {
    spawn_container()?;
    healthcheck(120, 50)?;
    Ok(())
}

pub fn cleanup() -> Result<(), Error> {
    if container_running() {
        stop_container()?;
    }
    if container_exists() {
        remove_container()?;
    }
    Ok(())
}

fn container_running() -> bool {
    container_status().map_or_else(|_| false, |r| r.contains("running"))
}

fn container_exists() -> bool {
    container_status().is_ok()
}

fn container_status() -> Result<String, Error> {
    cmd(
        &[
            "container",
            "inspect",
            "survival_list_postgres",
            "--format",
            "'{{ .State.Status }}'",
        ],
        "inspect container",
    )
}

fn spawn_container() -> Result<(), Error> {
    cmd(
        &[
            "run",
            "-d",
            "--name",
            "survival_list_postgres",
            "-p",
            "5435:5432",
            "-e",
            "POSTGRES_PASSWORD=postgres",
            "postgres",
        ],
        "spawn container",
    )
    .map(|_| ())
}

fn is_postgres_healthy() -> Result<bool, Error> {
    Ok(cmd(
        &["exec", "survival_list_postgres", "pg_isready"],
        "check container health",
    )
    .is_ok())
}

/// This function controls how the healthcheck retries are handled.
fn healthcheck(max_retries: u64, ms_per_retry: u64) -> Result<(), Error> {
    let slow_threshold = 10 + max_retries / 10;
    let mut nb_retries = 0;
    while !is_postgres_healthy()? {
        if nb_retries >= max_retries {
            return Err(Error::new(String::from(
                "Reached the max number of healthcheck retries",
            )));
        };
        std::thread::sleep(std::time::Duration::from_millis(ms_per_retry));
        nb_retries += 1;

        if nb_retries % slow_threshold == 0 {
            println!("Container startup slower than expected ({nb_retries} retries out of {max_retries})");
        }
    }
    // Just for extra safety...
    std::thread::sleep(std::time::Duration::from_millis(250));
    Ok(())
}

fn stop_container() -> Result<(), Error> {
    cmd(&["stop", "survival_list_postgres"], "stop container").map(|_| ())
}

fn remove_container() -> Result<(), Error> {
    cmd(&["rm", "-v", "survival_list_postgres"], "remove container").map(|_| ())
}

fn cmd(args: &[&'static str], action: &'static str) -> Result<String, Error> {
    let output = Command::new("docker")
        .args(args)
        .stderr(Stdio::piped())
        .stdout(Stdio::piped())
        .output()?;

    if output.status.success() {
        Ok(String::from_utf8(output.stdout).unwrap_or_default())
    } else {
        let err = String::from_utf8_lossy(&output.stderr);
        Err(Error::new(format!("`docker` couldn't {action}: {err}")))
    }
}

pub(crate) mod error {
    use std::fmt::Debug;

    #[derive(Debug)]
    pub struct Error {
        #[allow(dead_code)]
        msg: String,
        pub help: Option<String>,
    }

    impl Error {
        pub fn new(msg: String) -> Self {
            let help =
                "First, check that the docker daemon is up-and-running. Then, make sure that port 5435 is usable and that no container named `survival_list_postgres` already exists."
            ;
            Self {
                msg,
                help: Some(String::from(help)),
            }
        }
    }

    impl From<std::io::Error> for Error {
        fn from(e: std::io::Error) -> Self {
            Self {
                msg: format!("{e:#}"),
                help: None,
            }
        }
    }

    impl From<sqlx::Error> for Error {
        fn from(e: sqlx::Error) -> Self {
            Self {
                msg: format!("{e:#}"),
                help: None,
            }
        }
    }

    impl From<sqlx::migrate::MigrateError> for Error {
        fn from(e: sqlx::migrate::MigrateError) -> Self {
            Self {
                msg: format!("{e:#}"),
                help: None,
            }
        }
    }
}
