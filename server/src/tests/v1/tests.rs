use test_log::test;

use super::AuthenticatedClient;
use crate::{
    service::{
        api::v1::{api_client::ApiClient, *},
        google::r#type::Date,
    },
    tests::utils::with_server_ready,
};

#[test]
fn it_requires_authentication() {
    with_server_ready(|uri| async {
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
    with_server_ready(|uri| async {
        let mut client = AuthenticatedClient::connect(uri).await;

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
    with_server_ready(|uri| async {
        let mut client = AuthenticatedClient::connect(uri).await;

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

#[test]
fn it_can_have_multiple_users() {
    with_server_ready(|uri| async {
        let mut client = AuthenticatedClient::connect(uri).await;

        client.set_current_user_uid("alice uid");

        let alice = client
            .login(LoginRequest {
                name: "Alice".to_string(),
                ..Default::default()
            })
            .await
            .user
            .unwrap();

        let CreateTaskResponse {
            id: alice_task_id, ..
        } = client
            .create_task(CreateTaskRequest {
                title: "Alice's task".to_string(),
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                ..Default::default()
            })
            .await;

        let CreateGroupResponse {
            id: group_id,
            uid: group_uid,
            ..
        } = client
            .create_group(CreateGroupRequest {
                title: "My group".to_string(),
            })
            .await;

        let CreateTaskResponse {
            id: group_task_id, ..
        } = client
            .create_task(CreateTaskRequest {
                title: "Group task".to_string(),
                group_id,
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                ..Default::default()
            })
            .await;

        assert_eq!(client.get_tasks().await.len(), 2);
        assert_eq!(client.get_groups().await.len(), 1);
        assert_eq!(
            client
                .get_group_participants(GetGroupParticipantsRequest { group_id })
                .await,
            vec![GetGroupParticipantsResponse {
                user: Some(alice.clone())
            }]
        );

        client.set_current_user_uid("bob uid");

        let bob = client
            .login(LoginRequest {
                name: "Bob".to_string(),
                ..Default::default()
            })
            .await
            .user
            .unwrap();

        assert_eq!(client.get_tasks().await.len(), 0);
        assert_eq!(client.get_groups().await.len(), 0);

        let CreateTaskResponse {
            id: bob_task_id, ..
        } = client
            .create_task(CreateTaskRequest {
                title: "Bob's task".to_string(),
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                ..Default::default()
            })
            .await;

        assert_eq!(client.get_tasks().await.len(), 1);

        client
            .join_group(JoinGroupRequest {
                uid: group_uid.clone(),
            })
            .await;

        assert_eq!(
            client.get_tasks().await,
            vec![
                GetTasksResponse {
                    id: alice_task_id,
                    title: "Alice's task".to_string(),
                    start_date: Some(Date {
                        year: 2022,
                        month: 1,
                        day: 1,
                    }),
                    responsible: Some(alice.clone()),
                    can_update: false,
                    can_toggle: false,
                    can_delete: false,
                    is_friend_task: true,
                    group: None,
                    ..Default::default()
                },
                GetTasksResponse {
                    id: group_task_id,
                    title: "Group task".to_string(),
                    start_date: Some(Date {
                        year: 2022,
                        month: 1,
                        day: 1,
                    }),
                    responsible: Some(alice.clone()),
                    can_update: true,
                    can_toggle: true,
                    can_delete: true,
                    is_friend_task: false,
                    group: Some(Group {
                        id: group_id,
                        title: "My group".to_string(),
                        uid: group_uid.clone(),
                    }),
                    ..Default::default()
                },
                GetTasksResponse {
                    id: bob_task_id,
                    title: "Bob's task".to_string(),
                    start_date: Some(Date {
                        year: 2022,
                        month: 1,
                        day: 1,
                    }),
                    responsible: Some(bob.clone()),
                    can_update: true,
                    can_toggle: true,
                    can_delete: true,
                    is_friend_task: false,
                    group: None,
                    ..Default::default()
                },
            ]
        );
        assert_eq!(
            client.get_groups().await,
            vec![GetGroupsResponse {
                id: group_id,
                title: "My group".to_string(),
                uid: group_uid.clone(),
            }]
        );
        assert_eq!(
            client
                .get_group_participants(GetGroupParticipantsRequest { group_id })
                .await,
            vec![
                GetGroupParticipantsResponse {
                    user: Some(alice.clone())
                },
                GetGroupParticipantsResponse {
                    user: Some(bob.clone())
                }
            ]
        );
    });
}

#[test]
fn it_can_change_between_recurrence_types() {
    with_server_ready(|uri| async {
        let mut client = AuthenticatedClient::connect(uri).await;
        let user = client.login(LoginRequest::default()).await.user.unwrap();

        let CreateTaskResponse { id: task_id, .. } = client
            .create_task(CreateTaskRequest {
                title: "My task".to_string(),
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                recurring: None,
                ..Default::default()
            })
            .await;

        assert_eq!(
            client.get_tasks().await,
            vec![GetTasksResponse {
                id: task_id,
                title: "My task".to_string(),
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                recurring: None,
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
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                recurring: Some(update_task_request::Recurring::Checked(RecurringChecked {
                    days: 1,
                    months: 0,
                })),
                ..Default::default()
            })
            .await;

        assert_eq!(
            client.get_tasks().await,
            vec![GetTasksResponse {
                id: task_id,
                title: "My task".to_string(),
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                recurring: Some(get_tasks_response::Recurring::Checked(RecurringChecked {
                    days: 1,
                    months: 0,
                })),
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
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                recurring: Some(update_task_request::Recurring::Every(
                    RecurringEveryRequest { days: 1, months: 0 },
                )),
                ..Default::default()
            })
            .await;

        assert_eq!(
            client.get_tasks().await,
            vec![GetTasksResponse {
                id: task_id,
                title: "My task".to_string(),
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                recurring: Some(get_tasks_response::Recurring::Every(
                    RecurringEveryResponse {
                        days: 1,
                        months: 0,
                        num_reached_deadline: 0,
                        num_ready_to_start: 6,
                        num_reached_deadline_is_lower_bound: false,
                        num_ready_to_start_is_lower_bound: true,
                    }
                )),
                responsible: Some(user.clone()),
                can_update: true,
                can_toggle: true,
                can_delete: true,
                ..Default::default()
            }]
        );
    });
}
