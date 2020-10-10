resource "google_cloud_scheduler_job" "starting-db-job" {
  name             = "starting-sql-job"
  description      = "Starting DB"
  schedule         = "0 9 * * *"
  time_zone        = "Europe/London"
  attempt_deadline = "320s"
  count            = var.env == "dev" ? 1 : 0
  retry_config {
    retry_count = 1
  }
  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.starting-db-function[count.index].https_trigger_url
  }
}

resource "google_cloud_scheduler_job" "stopping-db-job" {
  name             = "stopping-sql-job"
  description      = "Stopping DB"
  schedule         = "0 18 * * *"
  time_zone        = "Europe/London"
  attempt_deadline = "320s"
  count            = var.env == "dev" ? 1 : 0
  retry_config {
    retry_count = 1
  }
  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.stopping-db-function[count.index].https_trigger_url
  }
}