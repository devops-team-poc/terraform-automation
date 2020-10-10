resource "google_cloudbuild_trigger" "api-deployment" {
  provider    = "google-beta"
  filename    = "cloudbuild.json"
  name        = "api-deployment-trigger"
  description = "build from cloud build file"
  github  {
    owner = "pateketu"
    name  = "inventry-info-api"
    push {
      branch = "^${var.github_repository_branch}$"
    }
  }
}
