use std::time::Duration;

use anyhow::Result;
use serde::Deserialize;

use super::{
    get_max_age::get_max_age,
    jwk::{self, JwkConfiguration},
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

pub async fn fetch_keys_for_config(config: &JwkConfiguration) -> Result<JwkKeys> {
    let http_response = reqwest::get(&config.jwk_url).await?;
    let max_age = get_max_age(&http_response).unwrap_or(FALLBACK_TIMEOUT);
    let result = Result::Ok(http_response.json::<KeyResponse>().await?);

    return result.map(|res| JwkKeys {
        keys: res.keys,
        validity: max_age,
    });
}

pub async fn fetch_keys() -> Result<JwkKeys> {
    return fetch_keys_for_config(&jwk::get_configuration()).await;
}
