resource "google_storage_bucket" "updating-redis-host-value-bucket" {
  name  = "updating-redis-host-value-process"
  count = var.env == "dev" ? 1 : 0
}

resource "google_storage_bucket_object" "updating-redis-host-value-archive" {
  name   = "update-redis-host-value.zip"
  bucket = google_storage_bucket.updating-redis-host-value-bucket[count.index].name
  source = "../../modules/memory-store/update-redis-host-value.zip"
  count  = var.env == "dev" ? 1 : 0
}


resource "google_cloudfunctions_function" "updating-redis-host-value-function" {
  name                  = "redis-update-function"
  description           = "My function"
  runtime               = "python37"
  available_memory_mb   = "128"
  source_archive_bucket = google_storage_bucket.updating-redis-host-value-bucket[count.index].name
  source_archive_object = google_storage_bucket_object.updating-redis-host-value-archive[count.index].name
  trigger_http          = true
  entry_point           = "update_redis_host"
  count                 = var.env == "dev" ? 1 : 0
  environment_variables = {
    RADIS_INSTANCE_NAME = google_redis_instance.cache.name,
    RADIS_HOST = google_secret_manager_secret.redis-host.secret_id
  }
}

resource "google_cloudfunctions_function_iam_member" "invoker-for-updating-redis-host-value" {
  project        = google_cloudfunctions_function.updating-redis-host-value-function[count.index].project
  region         = google_cloudfunctions_function.updating-redis-host-value-function[count.index].region
  cloud_function = google_cloudfunctions_function.updating-redis-host-value-function[count.index].name
  member         = "allUsers"
  role           = "roles/cloudfunctions.invoker"
  count          = var.env == "dev" ? 1 : 0
}