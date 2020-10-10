resource "google_storage_bucket" "stopping-db-bucket" {
  name  = "stop-sql-process"
  count = var.env == "dev" ? 1 : 0
}

resource "google_storage_bucket_object" "stopping-db-archive" {
  name   = "stop-sql.zip"
  bucket = google_storage_bucket.stopping-db-bucket[count.index].name
  source = "../../modules/cloud-sql/stop-sql.zip"
  count  = var.env == "dev" ? 1 : 0
}

resource "google_cloudfunctions_function" "stopping-db-function" {
  name                  = "psql-stop-function"
  description           = "My function"
  runtime               = "python37"
  available_memory_mb   = "128"
  source_archive_bucket = google_storage_bucket.stopping-db-bucket[count.index].name
  source_archive_object = google_storage_bucket_object.stopping-db-archive[count.index].name
  trigger_http          = true
  entry_point           = "stop_psql"
  count                 = var.env == "dev" ? 1 : 0
  environment_variables = {
    DB_INSTANCE_NAME = google_sql_database_instance.cloud-sql.name
  }
}

resource "google_cloudfunctions_function_iam_member" "invoker-for-stopping-db" {
  project        = google_cloudfunctions_function.stopping-db-function[count.index].project
  region         = google_cloudfunctions_function.stopping-db-function[count.index].region
  cloud_function = google_cloudfunctions_function.stopping-db-function[count.index].name
  member         = "allUsers"
  role           = "roles/cloudfunctions.invoker"
  count          = var.env == "dev" ? 1 : 0
}