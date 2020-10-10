resource "google_cloudbuild_trigger" "admin-build" {
  provider    = google-beta
  filename    = "cloudbuild.json"
  name        = "inventory-info-admin"
  description = "Build for Admin app"
  substitutions = {
    _SHOPIFY_ENV:"test"
    _APP_URL_PART:"inventory-info-dev"
  }

  github  {
    owner = "pateketu"
    name  = "inventory-info-admin"
    push {
      branch = "^${var.github_repository_branch}$"
    }
  }
}
