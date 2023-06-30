use test_log::test;

use super::with_server_ready;

#[test]
fn it_can_fail() {
    with_server_ready(|| async {
        assert!(false);
    });
}

// TODO: Test handle panic
