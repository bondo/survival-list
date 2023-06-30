use test_log::test;
use tokio_stream::StreamExt;

use crate::{
    service::grpc::v1::{api_client::ApiClient, GetTasksRequest, GetTasksResponse},
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
fn it_can_authenticate() {
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
