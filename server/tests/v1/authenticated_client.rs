use tokio_stream::StreamExt;
use tonic::{
    transport::{Channel, Uri},
    IntoRequest, Request, Status,
};

use server::proto::api::v1::{api_client::ApiClient, *};

pub(super) struct AuthenticatedClient {
    client: ApiClient<Channel>,
    user_uid: &'static str,
}

type Result<T> = std::result::Result<T, Status>;

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

    pub async fn login(&mut self, request: LoginRequest) -> Result<LoginResponse> {
        let request = self.authenticate_request(request);
        let response = self.client.login(request).await?;
        Ok(response.into_inner())
    }

    pub async fn create_task(&mut self, request: CreateTaskRequest) -> Result<CreateTaskResponse> {
        let request = self.authenticate_request(request);
        let response = self.client.create_task(request).await?;
        Ok(response.into_inner())
    }

    pub async fn update_task(&mut self, request: UpdateTaskRequest) -> Result<UpdateTaskResponse> {
        let request = self.authenticate_request(request);
        let response = self.client.update_task(request).await?;
        Ok(response.into_inner())
    }

    pub async fn toggle_task_completed(
        &mut self,
        request: ToggleTaskCompletedRequest,
    ) -> Result<ToggleTaskCompletedResponse> {
        let request = self.authenticate_request(request);
        let response = self.client.toggle_task_completed(request).await?;
        Ok(response.into_inner())
    }

    pub async fn delete_task(&mut self, request: DeleteTaskRequest) -> Result<DeleteTaskResponse> {
        let request = self.authenticate_request(request);
        let response = self.client.delete_task(request).await?;
        Ok(response.into_inner())
    }

    pub async fn get_tasks(&mut self) -> Result<Vec<GetTasksResponse>> {
        let request = self.authenticate_request(GetTasksRequest::default());
        let response = self.client.get_tasks(request).await?;
        response.into_inner().collect().await
    }

    pub async fn create_group(
        &mut self,
        request: CreateGroupRequest,
    ) -> Result<CreateGroupResponse> {
        let request = self.authenticate_request(request);
        let response = self.client.create_group(request).await?;
        Ok(response.into_inner())
    }

    pub async fn join_group(&mut self, request: JoinGroupRequest) -> Result<JoinGroupResponse> {
        let request = self.authenticate_request(request);
        let response = self.client.join_group(request).await?;
        Ok(response.into_inner())
    }

    pub async fn update_group(
        &mut self,
        request: UpdateGroupRequest,
    ) -> Result<UpdateGroupResponse> {
        let request = self.authenticate_request(request);
        let response = self.client.update_group(request).await?;
        Ok(response.into_inner())
    }

    pub async fn leave_group(&mut self, request: LeaveGroupRequest) -> Result<LeaveGroupResponse> {
        let request = self.authenticate_request(request);
        let response = self.client.leave_group(request).await?;
        Ok(response.into_inner())
    }

    pub async fn get_groups(&mut self) -> Result<Vec<GetGroupsResponse>> {
        let request = self.authenticate_request(GetGroupsRequest::default());
        let response = self.client.get_groups(request).await?;
        response.into_inner().collect().await
    }

    pub async fn get_group_participants(
        &mut self,
        request: GetGroupParticipantsRequest,
    ) -> Result<Vec<GetGroupParticipantsResponse>> {
        let request = self.authenticate_request(request);
        let response = self.client.get_group_participants(request).await?;
        response.into_inner().collect().await
    }

    pub async fn get_categories(&mut self) -> Result<Vec<GetCategoriesResponse>> {
        let request = self.authenticate_request(GetCategoriesRequest::default());
        let response = self.client.get_categories(request).await?;
        response.into_inner().collect().await
    }

    pub async fn update_category(
        &mut self,
        request: UpdateCategoryRequest,
    ) -> Result<UpdateCategoryResponse> {
        let request = self.authenticate_request(request);
        let response = self.client.update_category(request).await?;
        Ok(response.into_inner())
    }

    pub async fn create_subcategory(
        &mut self,
        request: CreateSubcategoryRequest,
    ) -> Result<CreateSubcategoryResponse> {
        let request = self.authenticate_request(request);
        let response = self.client.create_subcategory(request).await?;
        Ok(response.into_inner())
    }

    pub async fn update_subcategory(
        &mut self,
        request: UpdateSubcategoryRequest,
    ) -> Result<UpdateSubcategoryResponse> {
        let request = self.authenticate_request(request);
        let response = self.client.update_subcategory(request).await?;
        Ok(response.into_inner())
    }

    pub async fn delete_subcategory(
        &mut self,
        request: DeleteSubcategoryRequest,
    ) -> Result<DeleteSubcategoryResponse> {
        let request = self.authenticate_request(request);
        let response = self.client.delete_subcategory(request).await?;
        Ok(response.into_inner())
    }
}
