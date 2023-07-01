use test_log::test;

use super::SuccessClient;
use crate::{
    service::{
        api::v1::{api_client::ApiClient, *},
        google::r#type::Date,
    },
    tests::utils::{authenticated, unauthenticated, with_server_ready},
};

#[test]
fn it_requires_authentication() {
    with_server_ready(unauthenticated(), |uri| async {
        let mut client = ApiClient::connect(uri).await.unwrap();

        assert_eq!(
            client
                .get_tasks(GetTasksRequest::default())
                .await
                .err()
                .map(|e| e.code()),
            Some(tonic::Code::Unauthenticated)
        );
    });
}

#[test]
fn it_can_handle_tasks() {
    with_server_ready(authenticated(), |uri| async {
        let mut client = SuccessClient::connect(uri).await;

        assert_eq!(client.get_tasks().await, vec![]);

        let CreateTaskResponse { id: task_id, .. } = client
            .create_task(CreateTaskRequest {
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                ..Default::default()
            })
            .await;

        let user = client.login(LoginRequest::default()).await.user.unwrap();

        assert_eq!(
            client.get_tasks().await,
            vec![GetTasksResponse {
                id: task_id,
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                responsible: Some(user.clone()),
                can_update: true,
                can_toggle: true,
                can_delete: true,
                ..Default::default()
            }]
        );

        client
            .update_task(UpdateTaskRequest {
                id: task_id,
                title: "My task".to_string(),
                start_date: Some(Date {
                    year: 2023,
                    month: 1,
                    day: 1,
                }),
                ..Default::default()
            })
            .await;

        assert_eq!(
            client.get_tasks().await,
            vec![GetTasksResponse {
                id: task_id,
                title: "My task".to_string(),
                start_date: Some(Date {
                    year: 2023,
                    month: 1,
                    day: 1,
                }),
                responsible: Some(user.clone()),
                can_update: true,
                can_toggle: true,
                can_delete: true,
                ..Default::default()
            }]
        );

        client
            .toggle_task_completed(ToggleTaskCompletedRequest {
                id: task_id,
                is_completed: true,
            })
            .await;

        assert_eq!(
            client.get_tasks().await,
            vec![GetTasksResponse {
                id: task_id,
                title: "My task".to_string(),
                start_date: Some(Date {
                    year: 2023,
                    month: 1,
                    day: 1,
                }),
                responsible: Some(user.clone()),
                can_update: true,
                can_toggle: true,
                can_delete: true,
                is_completed: true,
                ..Default::default()
            }]
        );

        client.delete_task(DeleteTaskRequest { id: task_id }).await;

        assert_eq!(client.get_tasks().await, vec![]);
    });
}

#[test]
fn it_can_handle_groups() {
    with_server_ready(authenticated(), |uri| async {
        let mut client = SuccessClient::connect(uri).await;

        assert_eq!(client.get_groups().await, vec![]);

        let CreateGroupResponse {
            id: group_id,
            uid: group_uid,
            ..
        } = client
            .create_group(CreateGroupRequest {
                title: "My group".to_string(),
            })
            .await;

        assert_eq!(
            client.get_groups().await,
            vec![GetGroupsResponse {
                id: group_id,
                title: "My group".to_string(),
                uid: group_uid.clone(),
            }]
        );

        client
            .update_group(UpdateGroupRequest {
                id: group_id,
                title: "My group, new name".to_string(),
            })
            .await;

        assert_eq!(
            client.get_groups().await,
            vec![GetGroupsResponse {
                id: group_id,
                title: "My group, new name".to_string(),
                uid: group_uid.clone(),
            }]
        );

        let user = client.login(LoginRequest::default()).await.user.unwrap();
        assert_eq!(
            client
                .get_group_participants(GetGroupParticipantsRequest { group_id })
                .await,
            vec![GetGroupParticipantsResponse {
                user: Some(user.clone()),
            }]
        );

        client.leave_group(LeaveGroupRequest { id: group_id }).await;

        assert_eq!(client.get_groups().await, vec![]);
    });
}
