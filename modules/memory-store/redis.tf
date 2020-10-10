resource "google_redis_instance" "cache" {
  name           = "redis-instance"
  display_name   = "Redis Memory Store"
  redis_version  = "REDIS_4_0"
  memory_size_gb = 1
  tier           = "BASIC"
}