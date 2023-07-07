use tokio_stream::StreamExt;
use tonic::{
    transport::{Channel, Uri},
    IntoRequest, Request, Response, Status,
};

use server::proto::api::v1::{api_client::ApiClient, *};

pub(super) struct AuthenticatedClient {
    client: ApiClient<Channel>,
    user_uid: &'static str,
}

impl AuthenticatedClient {
    pub async fn connect(uri: Uri) -> Self {
        Self {
            client: ApiClient::connect(uri).await.unwrap(),
            user_uid: "user uid",
        }
    }

    pub fn set_current_user_uid(&mut self, user_uid: &'static str) {
        self.user_uid = user_uid;
    }

    fn authenticate_request<T, R: IntoRequest<T>>(&self, request: R) -> Request<T> {
        let mut request = request.into_request();

        request
            .metadata_mut()
            .insert("test-user-uid", self.user_uid.parse().unwrap());

        request
    }

    pub async fn login(
        &mut self,
        request: LoginRequest,
    ) -> std::result::Result<LoginResponse, Status> {
        let request = self.authenticate_request(request);
        self.client.login(request).await.map(Response::into_inner)
    }

    pub async fn create_task(
        &mut self,
        request: CreateTaskRequest,
    ) -> std::result::Result<CreateTaskResponse, Status> {
        let request = self.authenticate_request(request);
        self.client
            .create_task(request)
            .await
            .map(Response::into_inner)
    }

    pub async fn update_task(
        &mut self,
        request: UpdateTaskRequest,
    ) -> std::result::Result<UpdateTaskResponse, Status> {
        let request = self.authenticate_request(request);
        self.client
            .update_task(request)
            .await
            .map(Response::into_inner)
    }

    pub async fn toggle_task_completed(
        &mut self,
        request: ToggleTaskCompletedRequest,
    ) -> std::result::Result<ToggleTaskCompletedResponse, Status> {
        let request = self.authenticate_request(request);
        self.client
            .toggle_task_completed(request)
            .await
            .map(Response::into_inner)
    }

    pub async fn delete_task(
        &mut self,
        request: DeleteTaskRequest,
    ) -> std::result::Result<DeleteTaskResponse, Status> {
        let request = self.authenticate_request(request);
        self.client
            .delete_task(request)
            .await
            .map(Response::into_inner)
    }

    pub async fn get_tasks(&mut self) -> std::result::Result<Vec<GetTasksResponse>, Status> {
        let request = GetTasksRequest::default();
        let request = self.authenticate_request(request);
        let response = self.client.get_tasks(request).await?;
        response.into_inner().collect().await
    }

    pub async fn create_group(
        &mut self,
        request: CreateGroupRequest,
    ) -> std::result::Result<CreateGroupResponse, Status> {
        let request = self.authenticate_request(request);
        self.client
            .create_group(request)
            .await
            .map(Response::into_inner)
    }

    pub async fn join_group(
        &mut self,
        request: JoinGroupRequest,
    ) -> std::result::Result<JoinGroupResponse, Status> {
        let request = self.authenticate_request(request);
        self.client
            .join_group(request)
            .await
            .map(Response::into_inner)
    }

    pub async fn update_group(
        &mut self,
        request: UpdateGroupRequest,
    ) -> std::result::Result<UpdateGroupResponse, Status> {
        let request = self.authenticate_request(request);
        self.client
            .update_group(request)
            .await
            .map(Response::into_inner)
    }

    pub async fn leave_group(
        &mut self,
        request: LeaveGroupRequest,
    ) -> std::result::Result<LeaveGroupResponse, Status> {
        let request = self.authenticate_request(request);
        self.client
            .leave_group(request)
            .await
            .map(Response::into_inner)
    }

    pub async fn get_groups(&mut self) -> std::result::Result<Vec<GetGroupsResponse>, Status> {
        let request = GetGroupsRequest::default();
        let request = self.authenticate_request(request);
        let response = self.client.get_groups(request).await?;
        response.into_inner().collect().await
    }

    pub async fn get_group_participants(
        &mut self,
        request: GetGroupParticipantsRequest,
    ) -> std::result::Result<Vec<GetGroupParticipantsResponse>, Status> {
        let request = self.authenticate_request(request);
        let response = self.client.get_group_participants(request).await?;
        response.into_inner().collect().await
    }

    pub async fn get_categories(
        &mut self,
    ) -> std::result::Result<Vec<GetCategoriesResponse>, Status> {
        let request = GetCategoriesRequest::default();
        let request = self.authenticate_request(request);
        let response = self.client.get_categories(request).await?;
        response.into_inner().collect().await
    }

    pub async fn update_category(
        &mut self,
        request: UpdateCategoryRequest,
    ) -> std::result::Result<UpdateCategoryResponse, Status> {
        let request = self.authenticate_request(request);
        self.client
            .update_category(request)
            .await
            .map(Response::into_inner)
    }

    pub async fn create_subcategory(
        &mut self,
        request: CreateSubcategoryRequest,
    ) -> std::result::Result<CreateSubcategoryResponse, Status> {
        let request = self.authenticate_request(request);
        self.client
            .create_subcategory(request)
            .await
            .map(Response::into_inner)
    }

    pub async fn update_subcategory(
        &mut self,
        request: UpdateSubcategoryRequest,
    ) -> std::result::Result<UpdateSubcategoryResponse, Status> {
        let request = self.authenticate_request(request);
        self.client
            .update_subcategory(request)
            .await
            .map(Response::into_inner)
    }

    pub async fn delete_subcategory(
        &mut self,
        request: DeleteSubcategoryRequest,
    ) -> std::result::Result<DeleteSubcategoryResponse, Status> {
        let request = self.authenticate_request(request);
        self.client
            .delete_subcategory(request)
            .await
            .map(Response::into_inner)
    }
}
