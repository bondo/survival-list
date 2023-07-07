use test_log::test;

use server::proto::{
    api::v1::{api_client::ApiClient, *},
    google::r#type::Date,
};

use super::AuthenticatedClient;
use crate::utils::with_server_ready;

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

        assert_eq!(client.get_tasks().await.unwrap(), vec![]);

        let CreateTaskResponse { id: task_id, .. } = client
            .create_task(CreateTaskRequest {
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                ..Default::default()
            })
            .await
            .unwrap();

        let user = client
            .login(LoginRequest::default())
            .await
            .unwrap()
            .user
            .unwrap();

        assert_eq!(
            client.get_tasks().await.unwrap(),
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
            .await
            .unwrap();

        assert_eq!(
            client.get_tasks().await.unwrap(),
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
            .await
            .unwrap();

        assert_eq!(
            client.get_tasks().await.unwrap(),
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

        client
            .delete_task(DeleteTaskRequest { id: task_id })
            .await
            .unwrap();

        assert_eq!(client.get_tasks().await.unwrap(), vec![]);
    });
}

#[test]
fn it_can_handle_groups() {
    with_server_ready(|uri| async {
        let mut client = AuthenticatedClient::connect(uri).await;

        assert_eq!(client.get_groups().await.unwrap(), vec![]);

        let CreateGroupResponse {
            id: group_id,
            uid: group_uid,
            ..
        } = client
            .create_group(CreateGroupRequest {
                title: "My group".to_string(),
            })
            .await
            .unwrap();

        assert_eq!(
            client.get_groups().await.unwrap(),
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
            .await
            .unwrap();

        assert_eq!(
            client.get_groups().await.unwrap(),
            vec![GetGroupsResponse {
                id: group_id,
                title: "My group, new name".to_string(),
                uid: group_uid.clone(),
            }]
        );

        let user = client
            .login(LoginRequest::default())
            .await
            .unwrap()
            .user
            .unwrap();
        assert_eq!(
            client
                .get_group_participants(GetGroupParticipantsRequest { group_id })
                .await
                .unwrap(),
            vec![GetGroupParticipantsResponse {
                user: Some(user.clone()),
            }]
        );

        client
            .leave_group(LeaveGroupRequest { id: group_id })
            .await
            .unwrap();

        assert_eq!(client.get_groups().await.unwrap(), vec![]);
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
            .unwrap()
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
            .await
            .unwrap();

        let CreateGroupResponse {
            id: group_id,
            uid: group_uid,
            ..
        } = client
            .create_group(CreateGroupRequest {
                title: "My group".to_string(),
            })
            .await
            .unwrap();

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
            .await
            .unwrap();

        assert_eq!(client.get_tasks().await.unwrap().len(), 2);
        assert_eq!(client.get_groups().await.unwrap().len(), 1);
        assert_eq!(
            client
                .get_group_participants(GetGroupParticipantsRequest { group_id })
                .await
                .unwrap(),
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
            .unwrap()
            .user
            .unwrap();

        assert_eq!(client.get_tasks().await.unwrap().len(), 0);
        assert_eq!(client.get_groups().await.unwrap().len(), 0);

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
            .await
            .unwrap();

        assert_eq!(client.get_tasks().await.unwrap().len(), 1);

        client
            .join_group(JoinGroupRequest {
                uid: group_uid.clone(),
            })
            .await
            .unwrap();

        assert_eq!(
            client.get_tasks().await.unwrap(),
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
            client.get_groups().await.unwrap(),
            vec![GetGroupsResponse {
                id: group_id,
                title: "My group".to_string(),
                uid: group_uid.clone(),
            }]
        );
        assert_eq!(
            client
                .get_group_participants(GetGroupParticipantsRequest { group_id })
                .await
                .unwrap(),
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
        let user = client
            .login(LoginRequest::default())
            .await
            .unwrap()
            .user
            .unwrap();

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
            .await
            .unwrap();

        assert_eq!(
            client.get_tasks().await.unwrap(),
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
            .await
            .unwrap();

        assert_eq!(
            client.get_tasks().await.unwrap(),
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
            .await
            .unwrap();

        assert_eq!(
            client.get_tasks().await.unwrap(),
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

#[test]
fn it_can_handle_categories() {
    with_server_ready(|uri| async {
        let mut client = AuthenticatedClient::connect(uri).await;

        let categories = client.get_categories().await.unwrap();

        let get_category_id = |raw_title: &str| {
            categories
                .iter()
                .find(|c| c.raw_title == raw_title)
                .map(|c| c.id)
                .unwrap_or_default()
        };

        let finance_id = get_category_id("finance");
        let health_id = get_category_id("health");
        let home_id = get_category_id("home");
        let social_id = get_category_id("social");
        let work_id = get_category_id("work");

        assert_eq!(
            categories,
            vec![
                GetCategoriesResponse {
                    id: finance_id,
                    raw_title: "finance".to_string(),
                    color: "".to_string(),
                    is_enabled: true,
                    subcategories: vec![],
                },
                GetCategoriesResponse {
                    id: health_id,
                    raw_title: "health".to_string(),
                    color: "".to_string(),
                    is_enabled: true,
                    subcategories: vec![],
                },
                GetCategoriesResponse {
                    id: home_id,
                    raw_title: "home".to_string(),
                    color: "".to_string(),
                    is_enabled: true,
                    subcategories: vec![],
                },
                GetCategoriesResponse {
                    id: social_id,
                    raw_title: "social".to_string(),
                    color: "".to_string(),
                    is_enabled: true,
                    subcategories: vec![],
                },
                GetCategoriesResponse {
                    id: work_id,
                    raw_title: "work".to_string(),
                    color: "".to_string(),
                    is_enabled: true,
                    subcategories: vec![],
                },
            ]
        );

        client
            .update_category(UpdateCategoryRequest {
                id: work_id,
                color: "#ff0000".to_string(),
                is_enabled: false,
            })
            .await
            .unwrap();

        client
            .update_category(UpdateCategoryRequest {
                id: work_id,
                color: "#ff00ff".to_string(),
                is_enabled: false,
            })
            .await
            .unwrap();

        let cleaning = client
            .create_subcategory(CreateSubcategoryRequest {
                category_id: home_id,
                title: "Cleaning!".to_string(),
                color: "".to_string(),
            })
            .await
            .unwrap();

        let cleaning = client
            .update_subcategory(UpdateSubcategoryRequest {
                id: cleaning.id,
                title: "Cleaning".to_string(),
                color: "#00ff00".to_string(),
            })
            .await
            .unwrap();

        let delete = client
            .create_subcategory(CreateSubcategoryRequest {
                category_id: home_id,
                title: "Delete me".to_string(),
                color: "".to_string(),
            })
            .await
            .unwrap();

        client
            .delete_subcategory(DeleteSubcategoryRequest { id: delete.id })
            .await
            .unwrap();

        let categories = client.get_categories().await.unwrap();

        assert_eq!(
            categories,
            vec![
                GetCategoriesResponse {
                    id: finance_id,
                    raw_title: "finance".to_string(),
                    color: "".to_string(),
                    is_enabled: true,
                    subcategories: vec![],
                },
                GetCategoriesResponse {
                    id: health_id,
                    raw_title: "health".to_string(),
                    color: "".to_string(),
                    is_enabled: true,
                    subcategories: vec![],
                },
                GetCategoriesResponse {
                    id: home_id,
                    raw_title: "home".to_string(),
                    color: "".to_string(),
                    is_enabled: true,
                    subcategories: vec![Subcategory {
                        id: cleaning.id,
                        title: "Cleaning".to_string(),
                        color: "#00ff00".to_string(),
                    },],
                },
                GetCategoriesResponse {
                    id: social_id,
                    raw_title: "social".to_string(),
                    color: "".to_string(),
                    is_enabled: true,
                    subcategories: vec![],
                },
                GetCategoriesResponse {
                    id: work_id,
                    raw_title: "work".to_string(),
                    color: "#ff00ff".to_string(),
                    is_enabled: false,
                    subcategories: vec![],
                },
            ]
        );
    });
}

#[test]
fn it_can_have_tasks_with_subcategories() {
    with_server_ready(|uri| async {
        let mut client = AuthenticatedClient::connect(uri).await;
        let user = client
            .login(LoginRequest::default())
            .await
            .unwrap()
            .user
            .unwrap();

        let categories = client.get_categories().await.unwrap();

        let get_category_id = |raw_title: &str| {
            categories
                .iter()
                .find(|c| c.raw_title == raw_title)
                .map(|c| c.id)
                .unwrap_or_default()
        };

        let finance_id = get_category_id("finance");
        let home_id = get_category_id("home");

        let cleaning = client
            .create_subcategory(CreateSubcategoryRequest {
                category_id: home_id,
                title: "Cleaning!".to_string(),
                color: "".to_string(),
            })
            .await
            .unwrap();

        let simple_task = client
            .create_task(CreateTaskRequest {
                title: "Simple task".to_string(),
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                ..Default::default()
            })
            .await
            .unwrap();

        let finance_task = client
            .create_task(CreateTaskRequest {
                title: "Finance task".to_string(),
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                category_id: finance_id,
                ..Default::default()
            })
            .await
            .unwrap();

        let cleaning_task = client
            .create_task(CreateTaskRequest {
                title: "Cleaning task".to_string(),
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                category_id: home_id,
                subcategory_id: cleaning.id,
                ..Default::default()
            })
            .await
            .unwrap();

        assert_eq!(
            client.get_tasks().await.unwrap(),
            vec![
                GetTasksResponse {
                    id: simple_task.id,
                    title: "Simple task".to_string(),
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
                },
                GetTasksResponse {
                    id: finance_task.id,
                    title: "Finance task".to_string(),
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
                    category_id: finance_id,
                    ..Default::default()
                },
                GetTasksResponse {
                    id: cleaning_task.id,
                    title: "Cleaning task".to_string(),
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
                    category_id: home_id,
                    subcategory_id: cleaning.id,
                    ..Default::default()
                },
            ]
        );
    });
}

#[test]
fn it_fails_to_create_task_with_invalid_category() {
    with_server_ready(|uri| async {
        let mut client = AuthenticatedClient::connect(uri).await;

        let categories = client.get_categories().await.unwrap();

        let get_category_id = |raw_title: &str| {
            categories
                .iter()
                .find(|c| c.raw_title == raw_title)
                .map(|c| c.id)
                .unwrap_or_default()
        };

        let finance_id = get_category_id("finance");
        let home_id = get_category_id("home");

        let cleaning = client
            .create_subcategory(CreateSubcategoryRequest {
                category_id: home_id,
                title: "Cleaning!".to_string(),
                color: "".to_string(),
            })
            .await
            .unwrap();

        let err = client
            .create_task(CreateTaskRequest {
                title: "Cleaning task".to_string(),
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                category_id: finance_id,
                subcategory_id: cleaning.id,
                ..Default::default()
            })
            .await
            .unwrap_err();

        assert_eq!(err.code(), tonic::Code::InvalidArgument);
        assert_eq!(err.message(), "Subcategory must be child of category");
    });
}
