pub mod google {
    pub mod r#type {
        include!("google.r#type.rs");

        use crate::{Error, Result};

        impl From<sqlx::types::time::Date> for Date {
            fn from(value: sqlx::types::time::Date) -> Self {
                Self {
                    year: value.year(),
                    month: value.month() as i32,
                    day: value.day() as i32,
                }
            }
        }

        impl TryFrom<Date> for sqlx::types::time::Date {
            type Error = Error;

            fn try_from(value: Date) -> Result<Self> {
                let month: u8 = value
                    .month
                    .try_into()
                    .or(Err(Error::InvalidArgument("Month value out of range")))?;
                let month = month
                    .try_into()
                    .or(Err(Error::InvalidArgument("Month value out of range")))?;

                let day = value
                    .day
                    .try_into()
                    .or(Err(Error::InvalidArgument("Day value out of range")))?;

                Self::from_calendar_date(value.year, month, day)
                    .or(Err(Error::InvalidArgument("Invalid date")))
            }
        }
    }
}

pub mod api {
    pub mod v1 {
        include!("api.v1.rs");
    }
}

pub mod ping {
    pub mod v1 {
        include!("ping.v1.rs");
    }
}
