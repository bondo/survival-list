#[derive(thiserror::Error, Debug)]
pub enum JwkMaxAgeParseError {
    #[error("no max-age specified")]
    NoMaxAgeSpecified,

    #[error("no cache-control header")]
    NoCacheControlHeader,

    #[error("max-age value empty")]
    MaxAgeValueEmpty,

    #[error("non-numeric max-age")]
    NonNumericMaxAge,
}

#[derive(thiserror::Error, Debug)]
pub enum JwkFetchKeysError {
    #[error("fetch error: {0}")]
    FetchKeys(reqwest::Error),

    #[error("parse error: {0}")]
    ParseResponse(reqwest::Error),
}

#[derive(thiserror::Error, Debug)]
pub enum JwkVerificationError {
    #[error("invalid signature")]
    InvalidSignature,

    #[error("key decode error")]
    KeyDecodeError,

    #[error("unknown key algorithm")]
    UnknownKeyAlgorithm,
}

#[derive(thiserror::Error, Debug)]
pub enum JwkError {
    #[error("failed to fetch keys")]
    FetchKeys(#[from] JwkFetchKeysError),

    #[error("failed to parse max age")]
    MaxAge(#[from] JwkMaxAgeParseError),

    #[error("failed to verify token")]
    Verification(#[from] JwkVerificationError),
}

pub type JwkResult<T> = std::result::Result<T, JwkError>;
