use std::time::Duration;

use reqwest::{header::HeaderValue, Response};

use super::error::{JwkMaxAgeParseError, JwkResult};

// Determines the max age of an HTTP response
pub fn get_max_age(response: &Response) -> JwkResult<Duration> {
    let header = response
        .headers()
        .get("Cache-Control")
        .ok_or(JwkMaxAgeParseError::NoCacheControlHeader)?;

    parse_cache_control_header(header)
}

fn parse_max_age_value(cache_control_value: &str) -> JwkResult<Duration> {
    let tokens: Vec<&str> = cache_control_value.split(',').collect();
    for token in tokens {
        let key_value: Vec<&str> = token.split('=').map(|s| s.trim()).collect();
        let Some(key) = key_value.first() else {
            continue;
        };

        if String::from("max-age").eq(&key.to_lowercase()) {
            let value = key_value
                .get(1)
                .ok_or(JwkMaxAgeParseError::MaxAgeValueEmpty)?;

            let value = value
                .parse()
                .map_err(|_| JwkMaxAgeParseError::NonNumericMaxAge)?;

            return Ok(Duration::from_secs(value));
        }
    }
    Err(JwkMaxAgeParseError::NoMaxAgeSpecified.into())
}

fn parse_cache_control_header(header_value: &HeaderValue) -> JwkResult<Duration> {
    let string_value = header_value
        .to_str()
        .map_err(|_| JwkMaxAgeParseError::NoCacheControlHeader)?;

    parse_max_age_value(string_value)
}
