resource "google_cloud_scheduler_job" "creating-redis-job" {
  name             = "creating-redis-job"
  description      = "Creating Redis"
  schedule         = "30 08 * * *"
  time_zone        = "Europe/London"
  attempt_deadline = "320s"
  count            = var.env == "dev" ? 1 : 0
  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.creating-redis-function[count.index].https_trigger_url
  }
}

resource "google_cloud_scheduler_job" "deleting-redis-job" {
  name             = "deleting-redis-job"
  description      = "Deleting Redis"
  schedule         = "00 19 * * *"
  time_zone        = "Europe/London"
  attempt_deadline = "320s"
  count            = var.env == "dev" ? 1 : 0
  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.deleting-redis-function[count.index].https_trigger_url
  }
}

resource "google_cloud_scheduler_job" "updating-redis-host-job" {
  name             = "updating-redis-host-job"
  description      = "updating redis host value in secret manager"
  schedule         = "0 9 * * *"
  time_zone        = "Europe/London"
  attempt_deadline = "320s"
  count            = var.env == "dev" ? 1 : 0
  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.updating-redis-host-value-function[count.index].https_trigger_url
  }
}