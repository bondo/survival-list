mod ping;
mod proto;
mod v1;

use tonic::codegen::{CompressionEncoding, InterceptedService};

use self::ping::Service as ServicePing;
use self::proto::api::ping::api_server::ApiServer as ApiServerPing;
use self::proto::api::v1::api_server::ApiServer as ApiServerV1;
use self::v1::Service as ServiceV1;
use crate::{Auth, Database};

#[cfg(test)]
pub(crate) use proto::*;

pub fn build_v1_service<A: Auth>(
    auth: A,
    database: &Database,
) -> InterceptedService<ApiServerV1<ServiceV1>, A> {
    let server = ApiServerV1::new(ServiceV1::new(database.to_owned()))
        .accept_compressed(CompressionEncoding::Gzip)
        .send_compressed(CompressionEncoding::Gzip);
    InterceptedService::new(server, auth)
}

pub fn build_ping_service() -> ApiServerPing<ServicePing> {
    ApiServerPing::new(ServicePing {})
        .accept_compressed(CompressionEncoding::Gzip)
        .send_compressed(CompressionEncoding::Gzip)
}
