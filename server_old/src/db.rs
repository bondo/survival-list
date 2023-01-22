use native_tls::TlsConnector;
use postgres::Client;
use postgres_native_tls::MakeTlsConnector;

pub struct Database {
    client: Client,
}

impl Database {
    pub fn new(params: &str) -> Self {
        let connector = TlsConnector::builder()
            .build()
            .expect("should initiate tls connector");
        let connector = MakeTlsConnector::new(connector);
        let client =
            Client::connect(params, connector).expect("should be able to connect to postgres");
        return Database { client };
    }

    pub fn get_tasks(&mut self) -> Vec<postgres::Row> {
        self.client
            .query("SELECT * FROM tasks", &[])
            .expect("should be able to get tasks")
    }
}
