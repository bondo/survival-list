#[derive(Debug)]
pub struct JwkConfiguration {
    pub jwk_url: &'static str,
    pub audience: &'static str,
    pub issuer: &'static str,
}

pub fn get_configuration() -> JwkConfiguration {
    JwkConfiguration {
        jwk_url: "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com",
        audience: "survival-list-authentication",
        issuer: "https://securetoken.google.com/survival-list-authentication",
    }
}
