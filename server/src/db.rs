use deadpool_postgres::{Manager, ManagerConfig, Pool, RecyclingMethod};
use std::{env, str::FromStr};
use tokio_postgres::{Config, NoTls};

mod cornucopia;
use self::cornucopia::queries::tasks::{get_tasks, GetTasks};

pub struct Database {
    pool: Pool,
}

impl Database {
    pub async fn new() -> Self {
        let pg_connection = env::var("POSTGRES_CONNECTION")
            .unwrap_or_else(|_| panic!("Environment variable POSTGRES_CONNECTION missing"));
        let pg_config = Config::from_str(&pg_connection)
            .unwrap_or_else(|_| panic!("Failed to parse Postgres connection string"));
        let mgr_config = ManagerConfig {
            recycling_method: RecyclingMethod::Fast,
        };
        let mgr = Manager::from_config(pg_config, NoTls, mgr_config);
        let pool = Pool::builder(mgr)
            .build()
            .expect("Should be able to create PG pool");
        Database { pool }
    }

    pub async fn get_tasks(&mut self) -> Vec<GetTasks> {
        let client = self.pool.get().await.unwrap();
        get_tasks().bind(&client).all().await.unwrap()
    }
}
