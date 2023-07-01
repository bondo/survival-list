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
fn it_can_login() {
    with_server_ready(authenticated(), |uri| async {
        let mut client = SuccessClient::connect(uri).await;

        let response = client.login(LoginRequest::default()).await;

        assert_eq!(
            response.user,
            Some(User {
                id: 1,
                ..Default::default()
            })
        );
    });
}

#[test]
fn it_can_handle_tasks() {
    with_server_ready(authenticated(), |uri| async {
        let mut client = SuccessClient::connect(uri).await;

        let response = client
            .create_task(CreateTaskRequest {
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                ..Default::default()
            })
            .await;

        assert_eq!(response.id, 1);
    });
}

#[test]
fn it_can_get_tasks() {
    with_server_ready(authenticated(), |uri| async {
        let mut client = SuccessClient::connect(uri).await;

        let response = client.get_tasks().await;
        assert_eq!(response, vec![]);
    });
}

// TODO: Test handle panic
