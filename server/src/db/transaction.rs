use futures_core::future::BoxFuture;
use log::error;
use sqlx::{self, Pool, Postgres};
use tonic::Status;

type Tx<'c> = sqlx::Transaction<'c, Postgres>;

#[derive(Debug)]
pub struct Transaction<'c>(Tx<'c>);

impl<'c> Transaction<'c> {
    pub async fn begin(pool: &Pool<Postgres>) -> Result<Transaction<'c>, Status> {
        pool.begin().await.map(Self).map_err(|e| {
            let e = e.to_string();
            error!("Failed to begin transaction: {e}");
            Status::internal("Failed to begin transaction")
        })
    }

    async fn commit(self) -> Result<(), Status> {
        self.0.commit().await.map_err(|e| {
            let e = e.to_string();
            error!("Failed to commit transaction: {e}");
            Status::internal("Failed to commit transaction")
        })
    }

    async fn rollback(self) -> Result<(), Status> {
        self.0.rollback().await.map_err(|e| {
            let e = e.to_string();
            error!("Failed to rollback transaction: {e}");
            Status::internal("Failed to rollback transaction")
        })
    }

    pub async fn end<T>(self, result: Result<T, Status>) -> Result<T, Status> {
        match result {
            Ok(_) => self.commit().await,
            Err(_) => self.rollback().await,
        }?;
        result
    }
}

impl<'c, 't> sqlx::Executor<'t> for &'t mut Transaction<'c> {
    type Database = Postgres;

    fn fetch_many<'e, 'q: 'e, E: 'q>(
        self,
        query: E,
    ) -> futures_core::stream::BoxStream<
        'e,
        Result<
            sqlx::Either<
                <Self::Database as sqlx::Database>::QueryResult,
                <Self::Database as sqlx::Database>::Row,
            >,
            sqlx::Error,
        >,
    >
    where
        't: 'e,
        E: sqlx::Execute<'q, Self::Database>,
    {
        self.0.fetch_many(query)
    }

    fn fetch_optional<'e, 'q: 'e, E: 'q>(
        self,
        query: E,
    ) -> BoxFuture<'e, Result<Option<<Self::Database as sqlx::Database>::Row>, sqlx::Error>>
    where
        't: 'e,
        E: sqlx::Execute<'q, Self::Database>,
    {
        self.0.fetch_optional(query)
    }

    fn prepare_with<'e, 'q: 'e>(
        self,
        sql: &'q str,
        parameters: &'e [<Self::Database as sqlx::Database>::TypeInfo],
    ) -> BoxFuture<
        'e,
        Result<<Self::Database as sqlx::database::HasStatement<'q>>::Statement, sqlx::Error>,
    >
    where
        't: 'e,
    {
        self.0.prepare_with(sql, parameters)
    }

    fn describe<'e, 'q: 'e>(
        self,
        sql: &'q str,
    ) -> BoxFuture<'e, Result<sqlx::Describe<Self::Database>, sqlx::Error>>
    where
        't: 'e,
    {
        self.0.describe(sql)
    }
}
