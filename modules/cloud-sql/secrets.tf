resource "google_secret_manager_secret" "db-root-user-pwd" {
  secret_id = "PSQL_ROOT_USER_PWD"

  labels = {
    label = "root-user-db-password"
  }
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "secret-version-for-root-user" {
  secret      = google_secret_manager_secret.db-root-user-pwd.id
  secret_data = random_password.psql_root_password.result
}

resource "google_secret_manager_secret" "db-host" {
  secret_id = "DB_HOST"

  labels = {
    label = "db-host"
  }
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-version-for-db-host" {
  secret      = google_secret_manager_secret.db-host.id
  secret_data = google_sql_database_instance.cloud-sql.private_ip_address
}