use std::{env, fs};

use dotenvy::dotenv;
use futures_core::future::BoxFuture;
use sqlx::{self, migrate::MigrateError, postgres::PgPoolOptions, PgPool, Postgres};

use crate::error::Error;

use super::Transaction;

#[derive(Clone, Debug)]
pub struct Database {
    pool: PgPool,
}

impl Database {
    pub async fn new() -> Result<Self, sqlx::Error> {
        let url = fs::read_to_string("/secrets/POSTGRES_CONNECTION/latest").unwrap_or_else(|_| {
            dotenv().ok();
            env::var("DATABASE_URL").expect(
                "File /secrets/POSTGRES_CONNECTION/latest or environment variable DATABASE_URL missing",
            )
        });

        let pool = PgPoolOptions::new().connect(url.as_str()).await?;

        Ok(Database { pool })
    }

    pub async fn migrate(&self) -> Result<(), MigrateError> {
        sqlx::migrate!().run(&self.pool).await
    }

    pub async fn in_transaction<'c, R, F>(&'c self, f: F) -> Result<R, Error>
    where
        F: for<'t> FnOnce(&'t mut Transaction<'c>) -> BoxFuture<'t, Result<R, Error>>,
    {
        let mut tx = Transaction::begin(&self.pool).await?;
        let result = f(&mut tx).await;
        tx.end(result).await
    }
}

impl<'c> sqlx::Executor<'c> for &Database {
    type Database = Postgres;

    fn fetch_many<'e, 'q: 'e, E: 'q>(
        self,
        query: E,
    ) -> futures_core::stream::BoxStream<
        'e,
        std::result::Result<
            sqlx::Either<
                <Self::Database as sqlx::Database>::QueryResult,
                <Self::Database as sqlx::Database>::Row,
            >,
            sqlx::Error,
        >,
    >
    where
        'c: 'e,
        E: sqlx::Execute<'q, Self::Database>,
    {
        self.pool.fetch_many(query)
    }

    fn fetch_optional<'e, 'q: 'e, E: 'q>(
        self,
        query: E,
    ) -> BoxFuture<
        'e,
        std::result::Result<Option<<Self::Database as sqlx::Database>::Row>, sqlx::Error>,
    >
    where
        'c: 'e,
        E: sqlx::Execute<'q, Self::Database>,
    {
        self.pool.fetch_optional(query)
    }

    fn prepare_with<'e, 'q: 'e>(
        self,
        sql: &'q str,
        parameters: &'e [<Self::Database as sqlx::Database>::TypeInfo],
    ) -> BoxFuture<
        'e,
        std::result::Result<
            <Self::Database as sqlx::database::HasStatement<'q>>::Statement,
            sqlx::Error,
        >,
    >
    where
        'c: 'e,
    {
        self.pool.prepare_with(sql, parameters)
    }

    fn describe<'e, 'q: 'e>(
        self,
        sql: &'q str,
    ) -> BoxFuture<'e, std::result::Result<sqlx::Describe<Self::Database>, sqlx::Error>>
    where
        'c: 'e,
    {
        self.pool.describe(sql)
    }
}
