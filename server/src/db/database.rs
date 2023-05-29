use std::{env, fs};

use anyhow::Result;
use dotenvy::dotenv;
use futures_core::future::BoxFuture;
use sqlx::{self, migrate::MigrateError, postgres::PgPoolOptions, PgPool, Postgres, Transaction};
use tonic::Status;

#[derive(Clone, Debug)]
pub struct Database {
    pool: PgPool,
}

pub type Tx<'c> = Transaction<'c, Postgres>;

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

    pub async fn begin_transaction<'c>(&self) -> Result<Tx<'c>, Status> {
        self.pool
            .begin()
            .await
            .map_err(|_| Status::internal("Failed to begin transaction"))
    }

    pub async fn end_transaction<T>(
        &self,
        tx: Tx<'_>,
        result: Result<T, Status>,
    ) -> Result<T, Status> {
        match result {
            Ok(_) => tx
                .commit()
                .await
                .map_err(|_| Status::internal("Failed to commit transaction")),
            Err(_) => tx
                .rollback()
                .await
                .map_err(|_| Status::internal("Failed to rollback transaction")),
        }?;
        result
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
