resource "google_storage_bucket" "starting-db-bucket" {
  name  = "start-sql-process"
  count = var.env == "dev" ? 1 : 0
}

resource "google_storage_bucket_object" "starting-db-archive" {
  name   = "start-sql.zip"
  bucket = google_storage_bucket.starting-db-bucket[count.index].name
  source = "../../modules/cloud-sql/start-sql.zip"
  count  = var.env == "dev" ? 1 : 0
}

resource "google_cloudfunctions_function" "starting-db-function" {
  name                  = "psql-start-function"
  description           = "My function"
  runtime               = "python37"
  available_memory_mb   = "128"
  source_archive_bucket = google_storage_bucket.starting-db-bucket[count.index].name
  source_archive_object = google_storage_bucket_object.starting-db-archive[count.index].name
  trigger_http          = true
  entry_point           = "start_psql"
  count                 = var.env == "dev" ? 1 : 0
  environment_variables = {
    DB_INSTANCE_NAME = google_sql_database_instance.cloud-sql.name
  }
}


resource "google_cloudfunctions_function_iam_member" "invoker-for-starting-db" {
  project        = google_cloudfunctions_function.starting-db-function[count.index].project
  region         = google_cloudfunctions_function.starting-db-function[count.index].region
  cloud_function = google_cloudfunctions_function.starting-db-function[count.index].name
  member         = "allUsers"
  role           = "roles/cloudfunctions.invoker"
  count          = var.env == "dev" ? 1 : 0
}