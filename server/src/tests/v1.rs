use test_log::test;
use tokio_stream::StreamExt;

use crate::{
    service::{
        api::v1::{
            api_client::ApiClient, CreateTaskRequest, GetTasksRequest, GetTasksResponse,
            LoginRequest, User,
        },
        google::r#type::Date,
    },
    tests::auth::AuthStub,
};

use super::with_server_ready;

#[test]
fn it_requires_authentication() {
    let auth = AuthStub::new(None);

    with_server_ready(auth, |uri| async {
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
    let auth = AuthStub::new(Some("abcdefg".to_owned()));

    with_server_ready(auth, |uri| async {
        let mut client = ApiClient::connect(uri).await.unwrap();

        let response = client
            .login(LoginRequest::default())
            .await
            .unwrap()
            .into_inner();

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
fn it_can_create_task() {
    let auth = AuthStub::new(Some("abcdefg".to_owned()));

    with_server_ready(auth, |uri| async {
        let mut client = ApiClient::connect(uri).await.unwrap();

        let response = client
            .create_task(CreateTaskRequest {
                start_date: Some(Date {
                    year: 2022,
                    month: 1,
                    day: 1,
                }),
                ..Default::default()
            })
            .await
            .unwrap()
            .into_inner();

        assert_eq!(response.id, 1);
    });
}

#[test]
fn it_can_get_tasks() {
    let auth = AuthStub::new(Some("abcdefg".to_owned()));

    with_server_ready(auth, |uri| async {
        let mut client = ApiClient::connect(uri).await.unwrap();

        let response: Result<Vec<GetTasksResponse>, tonic::Status> = client
            .get_tasks(GetTasksRequest::default())
            .await
            .unwrap()
            .into_inner()
            .collect()
            .await;
        assert_eq!(response.unwrap(), vec![]);
    });
}

// TODO: Test handle panic
