mod v1;

use anyhow::Result;
use tonic::codegen::CompressionEncoding;
use tonic_reflection::server::{ServerReflection, ServerReflectionServer};

use self::v1::api_server::ApiServer as ApiServerV1;
use self::v1::Service as ServiceV1;
use crate::db::Database;

const FILE_DESCRIPTOR_SET: &[u8] = include_bytes!("proto/descriptor");

pub fn build_reflection_service() -> Result<ServerReflectionServer<impl ServerReflection>> {
    let service = tonic_reflection::server::Builder::configure()
        .register_encoded_file_descriptor_set(FILE_DESCRIPTOR_SET)
        .build()?;
    Ok(service)
}

pub fn build_v1_service(database: &Database) -> ApiServerV1<ServiceV1> {
    ApiServerV1::new(ServiceV1::new(database.to_owned()))
        .accept_compressed(CompressionEncoding::Gzip)
        .send_compressed(CompressionEncoding::Gzip)
}
