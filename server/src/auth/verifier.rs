use std::{collections::HashMap, str::FromStr};

use jsonwebtoken::{decode, decode_header, Algorithm, DecodingKey, TokenData, Validation};
use serde::Deserialize;

use super::{
    fetch_keys::JwkKey,
    jwk::{self, JwkConfiguration},
};

#[derive(Debug, Deserialize)]
pub struct Claims {
    // The audience the token was issued for
    pub aud: String,
    // The expiry date -- as epoch seconds
    pub exp: i64,
    // The token issuer
    pub iss: String,
    // The subject the token refers to
    pub sub: String,
    // Issued at -- as epoch seconds
    pub iat: i64,
}

enum VerificationError {
    InvalidSignature,
    KeyDecodeError,
    UnknownKeyAlgorithm,
}

#[derive(Debug)]
pub struct JwkVerifier {
    keys: HashMap<String, JwkKey>,
    config: JwkConfiguration,
}

fn keys_to_map(keys: Vec<JwkKey>) -> HashMap<String, JwkKey> {
    let mut keys_as_map = HashMap::new();
    for key in keys {
        keys_as_map.insert(String::clone(&key.kid), key);
    }
    keys_as_map
}

impl JwkVerifier {
    pub fn new(keys: Vec<JwkKey>) -> JwkVerifier {
        JwkVerifier {
            keys: keys_to_map(keys),
            config: jwk::get_configuration(),
        }
    }

    pub fn verify(&self, token: &str) -> Option<TokenData<Claims>> {
        let token_kid = match decode_header(token).map(|header| header.kid) {
            Ok(Some(header)) => header,
            _ => return None,
        };

        let jwk_key = match self.get_key(token_kid) {
            Some(key) => key,
            _ => return None,
        };

        match self.decode_token_with_key(jwk_key, token) {
            Ok(token_data) => Some(token_data),
            _ => None,
        }
    }

    pub fn set_keys(&mut self, keys: Vec<JwkKey>) {
        self.keys = keys_to_map(keys);
    }

    fn get_key(&self, key_id: String) -> Option<&JwkKey> {
        self.keys.get(&key_id)
    }

    fn decode_token_with_key(
        &self,
        key: &JwkKey,
        token: &str,
    ) -> Result<TokenData<Claims>, VerificationError> {
        let algorithm = match Algorithm::from_str(&key.alg) {
            Ok(alg) => alg,
            Err(_error) => return Err(VerificationError::UnknownKeyAlgorithm),
        };

        let mut validation = Validation::new(algorithm);
        validation.set_audience(&[self.config.audience]);
        validation.set_issuer(&[self.config.issuer]);

        let key = match DecodingKey::from_rsa_components(&key.n, &key.e) {
            Ok(key) => key,
            Err(_) => return Err(VerificationError::KeyDecodeError),
        };

        decode::<Claims>(token, &key, &validation).map_err(|_| VerificationError::InvalidSignature)
    }
}
