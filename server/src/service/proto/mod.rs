pub mod google {
    pub mod r#type {
        include!("google.r#type.rs");

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
            type Error = &'static str;

            fn try_from(value: Date) -> Result<Self, Self::Error> {
                let month: u8 = value.month.try_into().or(Err("Month value out of range"))?;
                let month = month.try_into().or(Err("Month value out of range"))?;

                let day = value.day.try_into().or(Err("Day value out of range"))?;

                Self::from_calendar_date(value.year, month, day).or(Err("Invalid date"))
            }
        }
    }
}

pub mod api {
    pub mod ping {
        include!("api.ping.rs");
    }
    pub mod v1 {
        include!("api.v1.rs");
    }
}
