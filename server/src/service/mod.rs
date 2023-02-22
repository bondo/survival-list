mod v1;

use tonic::codegen::{CompressionEncoding, InterceptedService};

use self::v1::api_server::ApiServer as ApiServerV1;
use self::v1::Service as ServiceV1;
use crate::auth::Auth;
use crate::db::Database;

pub fn build_v1_service(
    auth: &Auth,
    database: &Database,
) -> InterceptedService<ApiServerV1<ServiceV1>, Auth> {
    let server = ApiServerV1::new(ServiceV1::new(database.to_owned()))
        .accept_compressed(CompressionEncoding::Gzip)
        .send_compressed(CompressionEncoding::Gzip);
    InterceptedService::new(server, auth.to_owned())
}
