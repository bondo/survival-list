use futures_core::future::BoxFuture;
use sqlx::{self, postgres::PgPoolOptions, PgPool, Postgres};

use crate::Result;

use super::Transaction;

#[derive(Clone, Debug)]
pub struct Database {
    pool: PgPool,
}

impl Database {
    pub async fn new(url: &str) -> anyhow::Result<Self> {
        let pool = PgPoolOptions::new().connect(url).await?;
        Ok(Database { pool })
    }

    pub async fn migrate(&self) -> anyhow::Result<()> {
        sqlx::migrate!().run(&self.pool).await?;
        Ok(())
    }

    pub async fn in_transaction<'c, R, F>(&'c self, f: F) -> Result<R>
    where
        F: for<'t> FnOnce(&'t mut Transaction<'c>) -> BoxFuture<'t, Result<R>>,
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
        sqlx::Result<
            sqlx::Either<
                <Self::Database as sqlx::Database>::QueryResult,
                <Self::Database as sqlx::Database>::Row,
            >,
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
    ) -> BoxFuture<'e, sqlx::Result<Option<<Self::Database as sqlx::Database>::Row>>>
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
    ) -> BoxFuture<'e, sqlx::Result<<Self::Database as sqlx::database::HasStatement<'q>>::Statement>>
    where
        'c: 'e,
    {
        self.pool.prepare_with(sql, parameters)
    }

    fn describe<'e, 'q: 'e>(
        self,
        sql: &'q str,
    ) -> BoxFuture<'e, sqlx::Result<sqlx::Describe<Self::Database>>>
    where
        'c: 'e,
    {
        self.pool.describe(sql)
    }
}
