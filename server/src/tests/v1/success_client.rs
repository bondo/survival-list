use tokio_stream::StreamExt;
use tonic::transport::{Channel, Uri};

use crate::service::api::v1::{api_client::ApiClient, *};

pub(super) struct SuccessClient {
    client: ApiClient<Channel>,
}

impl SuccessClient {
    pub async fn connect(uri: Uri) -> Self {
        Self {
            client: ApiClient::connect(uri).await.unwrap(),
        }
    }

    pub async fn login(&mut self, request: LoginRequest) -> LoginResponse {
        self.client.login(request).await.unwrap().into_inner()
    }

    pub async fn create_task(&mut self, request: CreateTaskRequest) -> CreateTaskResponse {
        self.client.create_task(request).await.unwrap().into_inner()
    }

    pub async fn update_task(&mut self, request: UpdateTaskRequest) -> UpdateTaskResponse {
        self.client.update_task(request).await.unwrap().into_inner()
    }

    pub async fn toggle_task_completed(
        &mut self,
        request: ToggleTaskCompletedRequest,
    ) -> ToggleTaskCompletedResponse {
        self.client
            .toggle_task_completed(request)
            .await
            .unwrap()
            .into_inner()
    }

    pub async fn delete_task(&mut self, request: DeleteTaskRequest) -> DeleteTaskResponse {
        self.client.delete_task(request).await.unwrap().into_inner()
    }

    pub async fn get_tasks(&mut self) -> Vec<GetTasksResponse> {
        self.client
            .get_tasks(GetTasksRequest::default())
            .await
            .unwrap()
            .into_inner()
            .collect::<Result<Vec<GetTasksResponse>, tonic::Status>>()
            .await
            .unwrap()
    }

    pub async fn create_group(&mut self, request: CreateGroupRequest) -> CreateGroupResponse {
        self.client
            .create_group(request)
            .await
            .unwrap()
            .into_inner()
    }

    pub async fn join_group(&mut self, request: JoinGroupRequest) -> JoinGroupResponse {
        self.client.join_group(request).await.unwrap().into_inner()
    }

    pub async fn update_group(&mut self, request: UpdateGroupRequest) -> UpdateGroupResponse {
        self.client
            .update_group(request)
            .await
            .unwrap()
            .into_inner()
    }

    pub async fn leave_group(&mut self, request: LeaveGroupRequest) -> LeaveGroupResponse {
        self.client.leave_group(request).await.unwrap().into_inner()
    }

    pub async fn get_groups(&mut self) -> Vec<GetGroupsResponse> {
        self.client
            .get_groups(GetGroupsRequest::default())
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
