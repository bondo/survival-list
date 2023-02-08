mod proto;
mod v1;

use anyhow::Result;
use tonic::codegen::CompressionEncoding;
use tonic_reflection::server::{ServerReflection, ServerReflectionServer};

use self::proto::v1::survival_server::SurvivalServer as SurvivalServerV1;
use self::proto::FILE_DESCRIPTOR_SET;
use self::v1::SurvivalService as SurvivalServiceV1;
use crate::db::Database;

pub fn build_reflection_service() -> Result<ServerReflectionServer<impl ServerReflection>> {
    let service = tonic_reflection::server::Builder::configure()
        .register_encoded_file_descriptor_set(FILE_DESCRIPTOR_SET)
        .build()?;
    Ok(service)
}

pub fn build_v1_service(database: &Database) -> SurvivalServerV1<SurvivalServiceV1> {
    SurvivalServerV1::new(SurvivalServiceV1::new(database.to_owned()))
        .accept_compressed(CompressionEncoding::Gzip)
        .send_compressed(CompressionEncoding::Gzip)
}
