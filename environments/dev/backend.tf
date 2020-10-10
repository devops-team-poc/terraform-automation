terraform {
  backend "gcs" {
    bucket = "terraform-state-management-7705"
    prefix = "env/dev"
  }
}