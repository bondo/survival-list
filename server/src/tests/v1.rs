use test_log::test;

use crate::service::grpc::v1::{api_client::ApiClient, GetTasksRequest};

use super::with_server_ready;

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

// TODO: Test handle panic
