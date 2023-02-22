#[derive(Debug)]
pub struct JwkConfiguration {
    pub jwk_url: String,
    pub audience: String,
    pub issuer: String,
}

#[cfg(debug_assertions)]
fn get_secret(name: &str) -> String {
    match std::env::var(name) {
        Ok(value) => value,
        Err(_) => {
            println!("Failed to read ENV variable {name}");
            panic!("Failed to read ENV variable {name}");
        }
    }
}

#[cfg(not(debug_assertions))]
fn get_secret(name: &str) -> String {
    let path = format!("/secrets/{name}/latest");

    match std::fs::read_to_string(&path) {
        Ok(value) => value,
        Err(_) => {
            println!("Failed to read file {path}");
            panic!("Failed to read file {path}");
        }
    }
}

pub fn get_configuration() -> JwkConfiguration {
    JwkConfiguration {
        jwk_url: get_secret("JWK_URL"),
        audience: get_secret("JWK_AUDIENCE"),
        issuer: get_secret("JWK_ISSUER"),
    }
}
