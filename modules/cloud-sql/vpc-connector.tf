resource "google_vpc_access_connector" "connector" {
  name          = "for-cloud-sql-connection"
  region        = "us-central1"
  ip_cidr_range = "10.9.0.0/28"
  network       = "default"
  min_throughput = 200
  max_throughput = 300
}