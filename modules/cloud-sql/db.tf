resource "random_password" "psql_root_password" {
  length  = 16
  special = false
}



resource "google_sql_database_instance" "cloud-sql" {
  database_version = "POSTGRES_12"
  root_password    = random_password.psql_root_password.result
  settings {
    tier = var.db_instance_type
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }
    backup_configuration {
      enabled    = var.env == "prod" ? true : false
      start_time = "01:30"
    }
  }
}

resource "google_sql_database" "database" {
  name     = "sql-db"
  instance = google_sql_database_instance.cloud-sql.name
}