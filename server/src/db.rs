use deadpool_postgres::{Manager, ManagerConfig, Object, Pool, PoolError, RecyclingMethod};
use openssl::ssl::{SslConnector, SslMethod};
use postgres_openssl::MakeTlsConnector;
use std::{fs, str::FromStr};
use tokio_postgres::Config;

mod cornucopia;
use self::cornucopia::queries::tasks::{get_tasks, GetTasks};

pub struct Database {
    pool: Pool,
}

pub struct DatabaseConnection {
    connection: Object,
}

impl Database {
    pub async fn new() -> Self {
        let pg_connection = fs::read_to_string("/secrets/POSTGRES_CONNECTION").unwrap();
        let pg_config = Config::from_str(&pg_connection)
            .unwrap_or_else(|_| panic!("Failed to parse Postgres connection string"));
        let mgr_config = ManagerConfig {
            recycling_method: RecyclingMethod::Fast,
        };
        let tls_builder = SslConnector::builder(SslMethod::tls()).unwrap();
        let tls_connector = MakeTlsConnector::new(tls_builder.build());
        let mgr = Manager::from_config(pg_config, tls_connector, mgr_config);
        let pool = Pool::builder(mgr)
            .build()
            .expect("Should be able to create PG pool");
        Database { pool }
    }

    pub async fn get_connection(&self) -> Result<DatabaseConnection, PoolError> {
        Ok(DatabaseConnection {
            connection: self.pool.get().await?,
        })
    }
}

impl DatabaseConnection {
    pub async fn get_tasks(&mut self) -> Result<Vec<GetTasks>, tokio_postgres::Error> {
        get_tasks().bind(&self.connection).all().await
    }
}
