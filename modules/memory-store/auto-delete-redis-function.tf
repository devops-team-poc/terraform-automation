resource "google_storage_bucket" "deleting-redis-bucket" {
  name  = "deleting-redis-process"
  count = var.env == "dev" ? 1 : 0
}

resource "google_storage_bucket_object" "deleting-redis-archive" {
  name   = "delete-redis.zip"
  bucket = google_storage_bucket.deleting-redis-bucket[count.index].name
  source = "../../modules/memory-store/delete-redis.zip"
  count  = var.env == "dev" ? 1 : 0
}

resource "google_cloudfunctions_function" "deleting-redis-function" {
  name                  = "redis-delete-function"
  description           = "My function"
  runtime               = "python37"
  available_memory_mb   = "128"
  source_archive_bucket = google_storage_bucket.deleting-redis-bucket[count.index].name
  source_archive_object = google_storage_bucket_object.deleting-redis-archive[count.index].name
  trigger_http          = true
  entry_point           = "delete_redis"
  count                 = var.env == "dev" ? 1 : 0
  environment_variables = {
    RADIS_INSTANCE_NAME = google_redis_instance.cache.name
  }
}

resource "google_cloudfunctions_function_iam_member" "invoker-for-deleting-redis" {
  project        = google_cloudfunctions_function.deleting-redis-function[count.index].project
  region         = google_cloudfunctions_function.deleting-redis-function[count.index].region
  cloud_function = google_cloudfunctions_function.deleting-redis-function[count.index].name
  member         = "allUsers"
  role           = "roles/cloudfunctions.invoker"
  count          = var.env == "dev" ? 1 : 0
}