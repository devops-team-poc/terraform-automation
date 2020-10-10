provider "google" {
  project = var.project
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google-beta" {
  project = var.project
  region  = "us-central1"
  zone    = "us-central1-a"
}


#terraform import google_compute_network.default_network default
#terraform state rm google_compute_network.default_network
resource "google_compute_network" "default_network" {
  name        = "default"
  description = "Default network for the project"
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "default"
}

resource "google_service_networking_connection" "peering-with-servicenetworking" {
  network                 = "default"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}



module "cloud-sql" {
   source           = "../../modules/cloud-sql"
   db_instance_type = var.db_instance_type
   env              = var.env
   network_id       = "${google_compute_network.default_network.id}"
}

module "memory-store" {
   source           = "../../modules/memory-store"
   redis_instance_tier = var.redis_instance_tier
   env              = var.env
}

module "cloud-build" {
  source           = "../../modules/cloud-build"
  github_repository_branch = var.github_repository_branch
}
