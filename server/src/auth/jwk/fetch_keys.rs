use std::time::Duration;

use serde::Deserialize;

use super::{
    config::{self, JwkConfiguration},
    error::{JwkFetchKeysError, JwkResult},
    get_max_age::get_max_age,
};

#[derive(Debug, Deserialize)]
struct KeyResponse {
    keys: Vec<JwkKey>,
}

#[derive(Debug, Deserialize, Eq, PartialEq)]
pub struct JwkKey {
    pub e: String,
    pub alg: String,
    pub kty: String,
    pub kid: String,
    pub n: String,
}

#[derive(Debug)]
pub struct JwkKeys {
    pub keys: Vec<JwkKey>,
    pub validity: Duration,
}

const FALLBACK_TIMEOUT: Duration = Duration::from_secs(60);

pub async fn fetch_keys_for_config(config: &JwkConfiguration) -> JwkResult<JwkKeys> {
    let http_response = reqwest::get(config.jwk_url)
        .await
        .map_err(JwkFetchKeysError::FetchKeys)?;

    let max_age = get_max_age(&http_response).unwrap_or(FALLBACK_TIMEOUT);

    let result = Ok(http_response
        .json::<KeyResponse>()
        .await
        .map_err(JwkFetchKeysError::ParseResponse)?);

    result.map(|res| JwkKeys {
        keys: res.keys,
        validity: max_age,
    })
}

pub async fn fetch_keys() -> JwkResult<JwkKeys> {
    fetch_keys_for_config(&config::get_configuration()).await
}
