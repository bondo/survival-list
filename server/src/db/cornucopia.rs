// This file was generated with `cornucopia`. Do not modify.

#[allow(clippy :: all, clippy :: pedantic)] #[allow(unused_variables)]
#[allow(unused_imports)] #[allow(dead_code)] pub mod types { }#[allow(clippy :: all, clippy :: pedantic)] #[allow(unused_variables)]
#[allow(unused_imports)] #[allow(dead_code)] pub mod queries
{ pub mod tasks
{ use futures::{{StreamExt, TryStreamExt}};use futures; use cornucopia_async::GenericClient;#[derive( Debug, Clone, PartialEq, )] pub struct GetTasks
{ pub id : i32,pub title : Option<String>,pub start_date : Option<time::Date>,pub end_date : Option<time::Date>,}pub struct GetTasksBorrowed < 'a >
{ pub id : i32,pub title : Option<&'a str>,pub start_date : Option<time::Date>,pub end_date : Option<time::Date>,} impl < 'a > From < GetTasksBorrowed <
'a >> for GetTasks
{
    fn
    from(GetTasksBorrowed { id,title,start_date,end_date,} : GetTasksBorrowed < 'a >)
    -> Self { Self { id,title: title.map(|v| v.into()),start_date,end_date,} }
}pub struct GetTasksQuery < 'a, C : GenericClient, T, const N : usize >
{
    client : & 'a  C, params :
    [& 'a (dyn postgres_types :: ToSql + Sync) ; N], stmt : & 'a mut cornucopia_async
    :: private :: Stmt, extractor : fn(& tokio_postgres :: Row) -> GetTasksBorrowed,
    mapper : fn(GetTasksBorrowed) -> T,
} impl < 'a, C, T : 'a, const N : usize > GetTasksQuery < 'a, C, T, N >
where C : GenericClient
{
    pub fn map < R > (self, mapper : fn(GetTasksBorrowed) -> R) -> GetTasksQuery
    < 'a, C, R, N >
    {
        GetTasksQuery
        {
            client : self.client, params : self.params, stmt : self.stmt,
            extractor : self.extractor, mapper,
        }
    } pub async fn one(self) -> Result < T, tokio_postgres :: Error >
    {
        let stmt = self.stmt.prepare(self.client) .await ? ; let row =
        self.client.query_one(stmt, & self.params) .await ? ;
        Ok((self.mapper) ((self.extractor) (& row)))
    } pub async fn all(self) -> Result < Vec < T >, tokio_postgres :: Error >
    { self.iter() .await ?.try_collect().await } pub async fn opt(self) -> Result
    < Option < T >, tokio_postgres :: Error >
    {
        let stmt = self.stmt.prepare(self.client) .await ? ;
        Ok(self.client.query_opt(stmt, & self.params) .await
        ?.map(| row | (self.mapper) ((self.extractor) (& row))))
    } pub async fn iter(self,) -> Result < impl futures::Stream < Item = Result
    < T, tokio_postgres :: Error >> + 'a, tokio_postgres :: Error >
    {
        let stmt = self.stmt.prepare(self.client) .await ? ; let it =
        self.client.query_raw(stmt, cornucopia_async :: private ::
        slice_iter(& self.params)) .await ?
        .map(move | res |
        res.map(| row | (self.mapper) ((self.extractor) (& row)))) .into_stream() ;
        Ok(it)
    }
}pub fn get_tasks() -> GetTasksStmt
{ GetTasksStmt(cornucopia_async :: private :: Stmt :: new("SELECT
    id,
    title,
    start_date,
    end_date
FROM
    tasks")) } pub
struct GetTasksStmt(cornucopia_async :: private :: Stmt) ; impl
GetTasksStmt { pub fn bind < 'a, C : GenericClient, >
(& 'a mut self, client : & 'a  C,
) -> GetTasksQuery < 'a, C,
GetTasks, 0 >
{
    GetTasksQuery
    {
        client, params : [], stmt : & mut self.0, extractor :
        | row | { GetTasksBorrowed { id : row.get(0),title : row.get(1),start_date : row.get(2),end_date : row.get(3),} }, mapper : | it | { <GetTasks>::from(it) },
    }
} }}}