resource "google_secret_manager_secret" "redis-host" {
  secret_id = "RADIS_HOST"

  labels = {
    label = "redis-host"
  }
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-version-for-redis-host" {
  secret      = google_secret_manager_secret.redis-host.id
  secret_data = google_redis_instance.cache.host
}