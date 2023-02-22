use std::env;

use dotenvy::dotenv;

#[derive(Debug)]
pub struct JwkConfiguration {
    pub jwk_url: String,
    pub audience: String,
    pub issuer: String,
}

fn get_secret(name: &str) -> String {
    let path = format!("/secrets/{name}/latest");

    if let Ok(value) = std::fs::read_to_string(&path) {
        return value;
    }

    dotenv().ok();
    if let Ok(value) = env::var(name) {
        return value;
    }

    panic!("Failed to read secret {name}, tried env and path {path}");
}

pub fn get_configuration() -> JwkConfiguration {
    JwkConfiguration {
        jwk_url: get_secret("JWK_URL"),
        audience: get_secret("JWK_AUDIENCE"),
        issuer: get_secret("JWK_ISSUER"),
    }
}
