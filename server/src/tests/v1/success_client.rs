use tokio_stream::StreamExt;
use tonic::{
    transport::{Channel, Uri},
    IntoRequest, Request,
};

use crate::service::api::v1::{api_client::ApiClient, *};

pub(super) struct SuccessClient {
    authenticated_uid: &'static str,
    client: ApiClient<Channel>,
}

impl SuccessClient {
    pub async fn connect(uri: Uri, authenticated_uid: &'static str) -> Self {
        Self {
            authenticated_uid,
            client: ApiClient::connect(uri).await.unwrap(),
        }
    }

    pub fn set_authenticated_uid(&mut self, uid: &'static str) {
        self.authenticated_uid = uid;
    }

    fn authenticate_request<T, R: IntoRequest<T>>(&self, request: R) -> Request<T> {
        let mut request = request.into_request();

        request
            .metadata_mut()
            .insert("test-user-uid", self.authenticated_uid.parse().unwrap());

        request
    }

    pub async fn login(&mut self, request: LoginRequest) -> LoginResponse {
        let request = self.authenticate_request(request);
        self.client.login(request).await.unwrap().into_inner()
    }

    pub async fn create_task(&mut self, request: CreateTaskRequest) -> CreateTaskResponse {
        let request = self.authenticate_request(request);
        self.client.create_task(request).await.unwrap().into_inner()
    }

    pub async fn update_task(&mut self, request: UpdateTaskRequest) -> UpdateTaskResponse {
        let request = self.authenticate_request(request);
        self.client.update_task(request).await.unwrap().into_inner()
    }

    pub async fn toggle_task_completed(
        &mut self,
        request: ToggleTaskCompletedRequest,
    ) -> ToggleTaskCompletedResponse {
        let request = self.authenticate_request(request);
        self.client
            .toggle_task_completed(request)
            .await
            .unwrap()
            .into_inner()
    }

    pub async fn delete_task(&mut self, request: DeleteTaskRequest) -> DeleteTaskResponse {
        let request = self.authenticate_request(request);
        self.client.delete_task(request).await.unwrap().into_inner()
    }

    pub async fn get_tasks(&mut self) -> Vec<GetTasksResponse> {
        let request = GetTasksRequest::default();
        let request = self.authenticate_request(request);
        self.client
            .get_tasks(request)
            .await
            .unwrap()
            .into_inner()
            .collect::<Result<Vec<GetTasksResponse>, tonic::Status>>()
            .await
            .unwrap()
    }

    pub async fn create_group(&mut self, request: CreateGroupRequest) -> CreateGroupResponse {
        let request = self.authenticate_request(request);
        self.client
            .create_group(request)
            .await
            .unwrap()
            .into_inner()
    }

    pub async fn join_group(&mut self, request: JoinGroupRequest) -> JoinGroupResponse {
        let request = self.authenticate_request(request);
        self.client.join_group(request).await.unwrap().into_inner()
    }

    pub async fn update_group(&mut self, request: UpdateGroupRequest) -> UpdateGroupResponse {
        let request = self.authenticate_request(request);
        self.client
            .update_group(request)
            .await
            .unwrap()
            .into_inner()
    }

    pub async fn leave_group(&mut self, request: LeaveGroupRequest) -> LeaveGroupResponse {
        let request = self.authenticate_request(request);
        self.client.leave_group(request).await.unwrap().into_inner()
    }

    pub async fn get_groups(&mut self) -> Vec<GetGroupsResponse> {
        let request = GetGroupsRequest::default();
        let request = self.authenticate_request(request);
        self.client
            .get_groups(request)
            .await
            .unwrap()
            .into_inner()
            .collect::<Result<Vec<GetGroupsResponse>, tonic::Status>>()
            .await
            .unwrap()
    }

    pub async fn get_group_participants(
        &mut self,
        request: GetGroupParticipantsRequest,
    ) -> Vec<GetGroupParticipantsResponse> {
        let request = self.authenticate_request(request);
        self.client
            .get_group_participants(request)
            .await
            .unwrap()
            .into_inner()
            .collect::<Result<Vec<GetGroupParticipantsResponse>, tonic::Status>>()
            .await
            .unwrap()
    }
}
