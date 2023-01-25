use crate::db::Database;

#[derive(Clone)]
pub struct State {
    pub db: Database,
}

impl State {
    pub fn new(db: Database) -> Self {
        Self { db }
    }
}
