#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct LoginRequest {
    #[prost(string, tag = "1")]
    pub name: ::prost::alloc::string::String,
    #[prost(string, tag = "2")]
    pub picture_url: ::prost::alloc::string::String,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct LoginResponse {
    #[prost(message, optional, tag = "1")]
    pub user: ::core::option::Option<User>,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct CreateTaskRequest {
    #[prost(string, tag = "1")]
    pub title: ::prost::alloc::string::String,
    #[prost(message, optional, tag = "2")]
    pub start_date: ::core::option::Option<super::super::google::r#type::Date>,
    #[prost(message, optional, tag = "3")]
    pub end_date: ::core::option::Option<super::super::google::r#type::Date>,
    #[prost(int32, tag = "4")]
    pub responsible_id: i32,
    #[prost(int32, tag = "5")]
    pub group_id: i32,
    #[prost(message, optional, tag = "6")]
    pub estimate: ::core::option::Option<Duration>,
    #[prost(oneof = "create_task_request::Recurring", tags = "7, 8")]
    pub recurring: ::core::option::Option<create_task_request::Recurring>,
}
/// Nested message and enum types in `CreateTaskRequest`.
pub mod create_task_request {
    #[allow(clippy::derive_partial_eq_without_eq)]
    #[derive(Clone, PartialEq, ::prost::Oneof)]
    pub enum Recurring {
        #[prost(message, tag = "7")]
        Checked(super::RecurringChecked),
        #[prost(message, tag = "8")]
        Every(super::RecurringEveryRequest),
    }
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct CreateTaskResponse {
    #[prost(int32, tag = "1")]
    pub id: i32,
    #[prost(string, tag = "2")]
    pub title: ::prost::alloc::string::String,
    #[prost(message, optional, tag = "3")]
    pub start_date: ::core::option::Option<super::super::google::r#type::Date>,
    #[prost(message, optional, tag = "4")]
    pub end_date: ::core::option::Option<super::super::google::r#type::Date>,
    #[prost(message, optional, tag = "5")]
    pub responsible: ::core::option::Option<User>,
    #[prost(message, optional, tag = "6")]
    pub group: ::core::option::Option<Group>,
    #[prost(message, optional, tag = "7")]
    pub estimate: ::core::option::Option<Duration>,
    #[prost(bool, tag = "10")]
    pub can_update: bool,
    #[prost(bool, tag = "11")]
    pub can_toggle: bool,
    #[prost(bool, tag = "12")]
    pub can_delete: bool,
    #[prost(oneof = "create_task_response::Recurring", tags = "8, 9")]
    pub recurring: ::core::option::Option<create_task_response::Recurring>,
}
/// Nested message and enum types in `CreateTaskResponse`.
pub mod create_task_response {
    #[allow(clippy::derive_partial_eq_without_eq)]
    #[derive(Clone, PartialEq, ::prost::Oneof)]
    pub enum Recurring {
        #[prost(message, tag = "8")]
        Checked(super::RecurringChecked),
        #[prost(message, tag = "9")]
        Every(super::RecurringEveryResponse),
    }
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct UpdateTaskRequest {
    #[prost(int32, tag = "1")]
    pub id: i32,
    #[prost(string, tag = "2")]
    pub title: ::prost::alloc::string::String,
    #[prost(message, optional, tag = "3")]
    pub start_date: ::core::option::Option<super::super::google::r#type::Date>,
    #[prost(message, optional, tag = "4")]
    pub end_date: ::core::option::Option<super::super::google::r#type::Date>,
    #[prost(int32, tag = "5")]
    pub responsible_id: i32,
    #[prost(int32, tag = "6")]
    pub group_id: i32,
    #[prost(message, optional, tag = "7")]
    pub estimate: ::core::option::Option<Duration>,
    #[prost(oneof = "update_task_request::Recurring", tags = "8, 9")]
    pub recurring: ::core::option::Option<update_task_request::Recurring>,
}
/// Nested message and enum types in `UpdateTaskRequest`.
pub mod update_task_request {
    #[allow(clippy::derive_partial_eq_without_eq)]
    #[derive(Clone, PartialEq, ::prost::Oneof)]
    pub enum Recurring {
        #[prost(message, tag = "8")]
        Checked(super::RecurringChecked),
        #[prost(message, tag = "9")]
        Every(super::RecurringEveryRequest),
    }
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct UpdateTaskResponse {
    #[prost(int32, tag = "1")]
    pub id: i32,
    #[prost(string, tag = "2")]
    pub title: ::prost::alloc::string::String,
    #[prost(bool, tag = "3")]
    pub is_completed: bool,
    #[prost(message, optional, tag = "4")]
    pub start_date: ::core::option::Option<super::super::google::r#type::Date>,
    #[prost(message, optional, tag = "5")]
    pub end_date: ::core::option::Option<super::super::google::r#type::Date>,
    #[prost(message, optional, tag = "6")]
    pub responsible: ::core::option::Option<User>,
    #[prost(message, optional, tag = "7")]
    pub group: ::core::option::Option<Group>,
    #[prost(message, optional, tag = "8")]
    pub estimate: ::core::option::Option<Duration>,
    #[prost(bool, tag = "11")]
    pub can_update: bool,
    #[prost(bool, tag = "12")]
    pub can_toggle: bool,
    #[prost(bool, tag = "13")]
    pub can_delete: bool,
    #[prost(oneof = "update_task_response::Recurring", tags = "9, 10")]
    pub recurring: ::core::option::Option<update_task_response::Recurring>,
}
/// Nested message and enum types in `UpdateTaskResponse`.
pub mod update_task_response {
    #[allow(clippy::derive_partial_eq_without_eq)]
    #[derive(Clone, PartialEq, ::prost::Oneof)]
    pub enum Recurring {
        #[prost(message, tag = "9")]
        Checked(super::RecurringChecked),
        #[prost(message, tag = "10")]
        Every(super::RecurringEveryResponse),
    }
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct ToggleTaskCompletedRequest {
    #[prost(int32, tag = "1")]
    pub id: i32,
    #[prost(bool, tag = "2")]
    pub is_completed: bool,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct ToggleTaskCompletedResponse {
    #[prost(int32, tag = "1")]
    pub id: i32,
    #[prost(bool, tag = "2")]
    pub is_completed: bool,
    #[prost(message, optional, tag = "3")]
    pub task_created: ::core::option::Option<CreateTaskResponse>,
    #[prost(message, optional, tag = "4")]
    pub task_deleted: ::core::option::Option<DeleteTaskResponse>,
    #[prost(message, optional, tag = "5")]
    pub task_updated: ::core::option::Option<UpdateTaskResponse>,
    #[prost(bool, tag = "6")]
    pub can_update: bool,
    #[prost(bool, tag = "7")]
    pub can_toggle: bool,
    #[prost(bool, tag = "8")]
    pub can_delete: bool,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct DeleteTaskRequest {
    #[prost(int32, tag = "1")]
    pub id: i32,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct DeleteTaskResponse {
    #[prost(int32, tag = "1")]
    pub id: i32,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct GetTasksRequest {}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct GetTasksResponse {
    #[prost(int32, tag = "1")]
    pub id: i32,
    #[prost(string, tag = "2")]
    pub title: ::prost::alloc::string::String,
    #[prost(bool, tag = "3")]
    pub is_completed: bool,
    #[prost(message, optional, tag = "4")]
    pub start_date: ::core::option::Option<super::super::google::r#type::Date>,
    #[prost(message, optional, tag = "5")]
    pub end_date: ::core::option::Option<super::super::google::r#type::Date>,
    #[prost(message, optional, tag = "6")]
    pub responsible: ::core::option::Option<User>,
    #[prost(message, optional, tag = "7")]
    pub group: ::core::option::Option<Group>,
    #[prost(message, optional, tag = "8")]
    pub estimate: ::core::option::Option<Duration>,
    #[prost(bool, tag = "11")]
    pub can_update: bool,
    #[prost(bool, tag = "12")]
    pub can_toggle: bool,
    #[prost(bool, tag = "13")]
    pub can_delete: bool,
    #[prost(oneof = "get_tasks_response::Recurring", tags = "9, 10")]
    pub recurring: ::core::option::Option<get_tasks_response::Recurring>,
}
/// Nested message and enum types in `GetTasksResponse`.
pub mod get_tasks_response {
    #[allow(clippy::derive_partial_eq_without_eq)]
    #[derive(Clone, PartialEq, ::prost::Oneof)]
    pub enum Recurring {
        #[prost(message, tag = "9")]
        Checked(super::RecurringChecked),
        #[prost(message, tag = "10")]
        Every(super::RecurringEveryResponse),
    }
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct CreateGroupRequest {
    #[prost(string, tag = "1")]
    pub title: ::prost::alloc::string::String,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct CreateGroupResponse {
    #[prost(int32, tag = "1")]
    pub id: i32,
    #[prost(string, tag = "2")]
    pub title: ::prost::alloc::string::String,
    #[prost(string, tag = "3")]
    pub uid: ::prost::alloc::string::String,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct JoinGroupRequest {
    #[prost(string, tag = "1")]
    pub uid: ::prost::alloc::string::String,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct JoinGroupResponse {
    #[prost(int32, tag = "1")]
    pub id: i32,
    #[prost(string, tag = "2")]
    pub title: ::prost::alloc::string::String,
    #[prost(string, tag = "3")]
    pub uid: ::prost::alloc::string::String,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct UpdateGroupRequest {
    #[prost(int32, tag = "1")]
    pub id: i32,
    #[prost(string, tag = "2")]
    pub title: ::prost::alloc::string::String,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct UpdateGroupResponse {
    #[prost(int32, tag = "1")]
    pub id: i32,
    #[prost(string, tag = "2")]
    pub title: ::prost::alloc::string::String,
    #[prost(string, tag = "3")]
    pub uid: ::prost::alloc::string::String,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct LeaveGroupRequest {
    #[prost(int32, tag = "1")]
    pub id: i32,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct LeaveGroupResponse {
    #[prost(int32, tag = "1")]
    pub id: i32,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct GetGroupsRequest {}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct GetGroupsResponse {
    #[prost(int32, tag = "1")]
    pub id: i32,
    #[prost(string, tag = "2")]
    pub title: ::prost::alloc::string::String,
    #[prost(string, tag = "3")]
    pub uid: ::prost::alloc::string::String,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct GetGroupParticipantsRequest {
    #[prost(int32, tag = "1")]
    pub group_id: i32,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct GetGroupParticipantsResponse {
    #[prost(message, optional, tag = "1")]
    pub user: ::core::option::Option<User>,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct User {
    #[prost(int32, tag = "1")]
    pub id: i32,
    #[prost(string, tag = "2")]
    pub name: ::prost::alloc::string::String,
    #[prost(string, tag = "3")]
    pub picture_url: ::prost::alloc::string::String,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct Group {
    #[prost(int32, tag = "1")]
    pub id: i32,
    #[prost(string, tag = "2")]
    pub title: ::prost::alloc::string::String,
    #[prost(string, tag = "3")]
    pub uid: ::prost::alloc::string::String,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct Duration {
    #[prost(int32, tag = "1")]
    pub days: i32,
    #[prost(int32, tag = "2")]
    pub hours: i32,
    #[prost(int32, tag = "3")]
    pub minutes: i32,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RecurringChecked {
    #[prost(int32, tag = "1")]
    pub days: i32,
    #[prost(int32, tag = "2")]
    pub months: i32,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RecurringEveryRequest {
    #[prost(int32, tag = "1")]
    pub days: i32,
    #[prost(int32, tag = "2")]
    pub months: i32,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RecurringEveryResponse {
    #[prost(int32, tag = "1")]
    pub days: i32,
    #[prost(int32, tag = "2")]
    pub months: i32,
    #[prost(int32, tag = "3")]
    pub num_ready_to_start: i32,
    #[prost(bool, tag = "4")]
    pub num_ready_to_start_is_lower_bound: bool,
    #[prost(int32, tag = "5")]
    pub num_reached_deadline: i32,
    #[prost(bool, tag = "6")]
    pub num_reached_deadline_is_lower_bound: bool,
}
/// Generated server implementations.
pub mod api_server {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    /// Generated trait containing gRPC methods that should be implemented for use with ApiServer.
    #[async_trait]
    pub trait Api: Send + Sync + 'static {
        async fn login(
            &self,
            request: tonic::Request<super::LoginRequest>,
        ) -> std::result::Result<tonic::Response<super::LoginResponse>, tonic::Status>;
        async fn create_task(
            &self,
            request: tonic::Request<super::CreateTaskRequest>,
        ) -> std::result::Result<
            tonic::Response<super::CreateTaskResponse>,
            tonic::Status,
        >;
        async fn update_task(
            &self,
            request: tonic::Request<super::UpdateTaskRequest>,
        ) -> std::result::Result<
            tonic::Response<super::UpdateTaskResponse>,
            tonic::Status,
        >;
        async fn toggle_task_completed(
            &self,
            request: tonic::Request<super::ToggleTaskCompletedRequest>,
        ) -> std::result::Result<
            tonic::Response<super::ToggleTaskCompletedResponse>,
            tonic::Status,
        >;
        async fn delete_task(
            &self,
            request: tonic::Request<super::DeleteTaskRequest>,
        ) -> std::result::Result<
            tonic::Response<super::DeleteTaskResponse>,
            tonic::Status,
        >;
        /// Server streaming response type for the GetTasks method.
        type GetTasksStream: futures_core::Stream<
                Item = std::result::Result<super::GetTasksResponse, tonic::Status>,
            >
            + Send
            + 'static;
        async fn get_tasks(
            &self,
            request: tonic::Request<super::GetTasksRequest>,
        ) -> std::result::Result<tonic::Response<Self::GetTasksStream>, tonic::Status>;
        async fn create_group(
            &self,
            request: tonic::Request<super::CreateGroupRequest>,
        ) -> std::result::Result<
            tonic::Response<super::CreateGroupResponse>,
            tonic::Status,
        >;
        async fn join_group(
            &self,
            request: tonic::Request<super::JoinGroupRequest>,
        ) -> std::result::Result<
            tonic::Response<super::JoinGroupResponse>,
            tonic::Status,
        >;
        async fn update_group(
            &self,
            request: tonic::Request<super::UpdateGroupRequest>,
        ) -> std::result::Result<
            tonic::Response<super::UpdateGroupResponse>,
            tonic::Status,
        >;
        async fn leave_group(
            &self,
            request: tonic::Request<super::LeaveGroupRequest>,
        ) -> std::result::Result<
            tonic::Response<super::LeaveGroupResponse>,
            tonic::Status,
        >;
        /// Server streaming response type for the GetGroups method.
        type GetGroupsStream: futures_core::Stream<
                Item = std::result::Result<super::GetGroupsResponse, tonic::Status>,
            >
            + Send
            + 'static;
        async fn get_groups(
            &self,
            request: tonic::Request<super::GetGroupsRequest>,
        ) -> std::result::Result<tonic::Response<Self::GetGroupsStream>, tonic::Status>;
        /// Server streaming response type for the GetGroupParticipants method.
        type GetGroupParticipantsStream: futures_core::Stream<
                Item = std::result::Result<
                    super::GetGroupParticipantsResponse,
                    tonic::Status,
                >,
            >
            + Send
            + 'static;
        async fn get_group_participants(
            &self,
            request: tonic::Request<super::GetGroupParticipantsRequest>,
        ) -> std::result::Result<
            tonic::Response<Self::GetGroupParticipantsStream>,
            tonic::Status,
        >;
    }
    #[derive(Debug)]
    pub struct ApiServer<T: Api> {
        inner: _Inner<T>,
        accept_compression_encodings: EnabledCompressionEncodings,
        send_compression_encodings: EnabledCompressionEncodings,
        max_decoding_message_size: Option<usize>,
        max_encoding_message_size: Option<usize>,
    }
    struct _Inner<T>(Arc<T>);
    impl<T: Api> ApiServer<T> {
        pub fn new(inner: T) -> Self {
            Self::from_arc(Arc::new(inner))
        }
        pub fn from_arc(inner: Arc<T>) -> Self {
            let inner = _Inner(inner);
            Self {
                inner,
                accept_compression_encodings: Default::default(),
                send_compression_encodings: Default::default(),
                max_decoding_message_size: None,
                max_encoding_message_size: None,
            }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> InterceptedService<Self, F>
        where
            F: tonic::service::Interceptor,
        {
            InterceptedService::new(Self::new(inner), interceptor)
        }
        /// Enable decompressing requests with the given encoding.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.accept_compression_encodings.enable(encoding);
            self
        }
        /// Compress responses with the given encoding, if the client supports it.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.send_compression_encodings.enable(encoding);
            self
        }
        /// Limits the maximum size of a decoded message.
        ///
        /// Default: `4MB`
        #[must_use]
        pub fn max_decoding_message_size(mut self, limit: usize) -> Self {
            self.max_decoding_message_size = Some(limit);
            self
        }
        /// Limits the maximum size of an encoded message.
        ///
        /// Default: `usize::MAX`
        #[must_use]
        pub fn max_encoding_message_size(mut self, limit: usize) -> Self {
            self.max_encoding_message_size = Some(limit);
            self
        }
    }
    impl<T, B> tonic::codegen::Service<http::Request<B>> for ApiServer<T>
    where
        T: Api,
        B: Body + Send + 'static,
        B::Error: Into<StdError> + Send + 'static,
    {
        type Response = http::Response<tonic::body::BoxBody>;
        type Error = std::convert::Infallible;
        type Future = BoxFuture<Self::Response, Self::Error>;
        fn poll_ready(
            &mut self,
            _cx: &mut Context<'_>,
        ) -> Poll<std::result::Result<(), Self::Error>> {
            Poll::Ready(Ok(()))
        }
        fn call(&mut self, req: http::Request<B>) -> Self::Future {
            let inner = self.inner.clone();
            match req.uri().path() {
                "/api.v1.API/Login" => {
                    #[allow(non_camel_case_types)]
                    struct LoginSvc<T: Api>(pub Arc<T>);
                    impl<T: Api> tonic::server::UnaryService<super::LoginRequest>
                    for LoginSvc<T> {
                        type Response = super::LoginResponse;
                        type Future = BoxFuture<
                            tonic::Response<Self::Response>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::LoginRequest>,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move { (*inner).login(request).await };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = LoginSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/api.v1.API/CreateTask" => {
                    #[allow(non_camel_case_types)]
                    struct CreateTaskSvc<T: Api>(pub Arc<T>);
                    impl<T: Api> tonic::server::UnaryService<super::CreateTaskRequest>
                    for CreateTaskSvc<T> {
                        type Response = super::CreateTaskResponse;
                        type Future = BoxFuture<
                            tonic::Response<Self::Response>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::CreateTaskRequest>,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move { (*inner).create_task(request).await };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = CreateTaskSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/api.v1.API/UpdateTask" => {
                    #[allow(non_camel_case_types)]
                    struct UpdateTaskSvc<T: Api>(pub Arc<T>);
                    impl<T: Api> tonic::server::UnaryService<super::UpdateTaskRequest>
                    for UpdateTaskSvc<T> {
                        type Response = super::UpdateTaskResponse;
                        type Future = BoxFuture<
                            tonic::Response<Self::Response>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::UpdateTaskRequest>,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move { (*inner).update_task(request).await };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = UpdateTaskSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/api.v1.API/ToggleTaskCompleted" => {
                    #[allow(non_camel_case_types)]
                    struct ToggleTaskCompletedSvc<T: Api>(pub Arc<T>);
                    impl<
                        T: Api,
                    > tonic::server::UnaryService<super::ToggleTaskCompletedRequest>
                    for ToggleTaskCompletedSvc<T> {
                        type Response = super::ToggleTaskCompletedResponse;
                        type Future = BoxFuture<
                            tonic::Response<Self::Response>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::ToggleTaskCompletedRequest>,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move {
                                (*inner).toggle_task_completed(request).await
                            };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = ToggleTaskCompletedSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/api.v1.API/DeleteTask" => {
                    #[allow(non_camel_case_types)]
                    struct DeleteTaskSvc<T: Api>(pub Arc<T>);
                    impl<T: Api> tonic::server::UnaryService<super::DeleteTaskRequest>
                    for DeleteTaskSvc<T> {
                        type Response = super::DeleteTaskResponse;
                        type Future = BoxFuture<
                            tonic::Response<Self::Response>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::DeleteTaskRequest>,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move { (*inner).delete_task(request).await };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = DeleteTaskSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/api.v1.API/GetTasks" => {
                    #[allow(non_camel_case_types)]
                    struct GetTasksSvc<T: Api>(pub Arc<T>);
                    impl<
                        T: Api,
                    > tonic::server::ServerStreamingService<super::GetTasksRequest>
                    for GetTasksSvc<T> {
                        type Response = super::GetTasksResponse;
                        type ResponseStream = T::GetTasksStream;
                        type Future = BoxFuture<
                            tonic::Response<Self::ResponseStream>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::GetTasksRequest>,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move { (*inner).get_tasks(request).await };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = GetTasksSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.server_streaming(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/api.v1.API/CreateGroup" => {
                    #[allow(non_camel_case_types)]
                    struct CreateGroupSvc<T: Api>(pub Arc<T>);
                    impl<T: Api> tonic::server::UnaryService<super::CreateGroupRequest>
                    for CreateGroupSvc<T> {
                        type Response = super::CreateGroupResponse;
                        type Future = BoxFuture<
                            tonic::Response<Self::Response>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::CreateGroupRequest>,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move {
                                (*inner).create_group(request).await
                            };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = CreateGroupSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/api.v1.API/JoinGroup" => {
                    #[allow(non_camel_case_types)]
                    struct JoinGroupSvc<T: Api>(pub Arc<T>);
                    impl<T: Api> tonic::server::UnaryService<super::JoinGroupRequest>
                    for JoinGroupSvc<T> {
                        type Response = super::JoinGroupResponse;
                        type Future = BoxFuture<
                            tonic::Response<Self::Response>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::JoinGroupRequest>,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move { (*inner).join_group(request).await };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = JoinGroupSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/api.v1.API/UpdateGroup" => {
                    #[allow(non_camel_case_types)]
                    struct UpdateGroupSvc<T: Api>(pub Arc<T>);
                    impl<T: Api> tonic::server::UnaryService<super::UpdateGroupRequest>
                    for UpdateGroupSvc<T> {
                        type Response = super::UpdateGroupResponse;
                        type Future = BoxFuture<
                            tonic::Response<Self::Response>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::UpdateGroupRequest>,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move {
                                (*inner).update_group(request).await
                            };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = UpdateGroupSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/api.v1.API/LeaveGroup" => {
                    #[allow(non_camel_case_types)]
                    struct LeaveGroupSvc<T: Api>(pub Arc<T>);
                    impl<T: Api> tonic::server::UnaryService<super::LeaveGroupRequest>
                    for LeaveGroupSvc<T> {
                        type Response = super::LeaveGroupResponse;
                        type Future = BoxFuture<
                            tonic::Response<Self::Response>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::LeaveGroupRequest>,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move { (*inner).leave_group(request).await };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = LeaveGroupSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/api.v1.API/GetGroups" => {
                    #[allow(non_camel_case_types)]
                    struct GetGroupsSvc<T: Api>(pub Arc<T>);
                    impl<
                        T: Api,
                    > tonic::server::ServerStreamingService<super::GetGroupsRequest>
                    for GetGroupsSvc<T> {
                        type Response = super::GetGroupsResponse;
                        type ResponseStream = T::GetGroupsStream;
                        type Future = BoxFuture<
                            tonic::Response<Self::ResponseStream>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::GetGroupsRequest>,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move { (*inner).get_groups(request).await };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = GetGroupsSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.server_streaming(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/api.v1.API/GetGroupParticipants" => {
                    #[allow(non_camel_case_types)]
                    struct GetGroupParticipantsSvc<T: Api>(pub Arc<T>);
                    impl<
                        T: Api,
                    > tonic::server::ServerStreamingService<
                        super::GetGroupParticipantsRequest,
                    > for GetGroupParticipantsSvc<T> {
                        type Response = super::GetGroupParticipantsResponse;
                        type ResponseStream = T::GetGroupParticipantsStream;
                        type Future = BoxFuture<
                            tonic::Response<Self::ResponseStream>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::GetGroupParticipantsRequest>,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move {
                                (*inner).get_group_participants(request).await
                            };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = GetGroupParticipantsSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.server_streaming(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                _ => {
                    Box::pin(async move {
                        Ok(
                            http::Response::builder()
                                .status(200)
                                .header("grpc-status", "12")
                                .header("content-type", "application/grpc")
                                .body(empty_body())
                                .unwrap(),
                        )
                    })
                }
            }
        }
    }
    impl<T: Api> Clone for ApiServer<T> {
        fn clone(&self) -> Self {
            let inner = self.inner.clone();
            Self {
                inner,
                accept_compression_encodings: self.accept_compression_encodings,
                send_compression_encodings: self.send_compression_encodings,
                max_decoding_message_size: self.max_decoding_message_size,
                max_encoding_message_size: self.max_encoding_message_size,
            }
        }
    }
    impl<T: Api> Clone for _Inner<T> {
        fn clone(&self) -> Self {
            Self(Arc::clone(&self.0))
        }
    }
    impl<T: std::fmt::Debug> std::fmt::Debug for _Inner<T> {
        fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
            write!(f, "{:?}", self.0)
        }
    }
    impl<T: Api> tonic::server::NamedService for ApiServer<T> {
        const NAME: &'static str = "api.v1.API";
    }
}
