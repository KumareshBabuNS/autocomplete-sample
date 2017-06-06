provider "google" {
  credentials = "${file("account.json")}"
  project     = "${var.projectid}"
  region      = "${var.region}"
}

provider "google" {
  alias = "central"
  credentials = "${file("account.json")}"
  project     = "${var.projectid}"
  region = "us-central1"
}


variable "projectid" {
    type = "string"
}

variable "region" {
    type = "string"
    default = "us-east1"
}

variable "zone" {
    type = "string"
    default = "us-east1-d"
}


resource "google_compute_firewall" "default" {
  name    = "default"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["autocomplete"]
}

resource "google_compute_instance_group" "webserverseast" {
  name        = "webserverseast"
  description = "Terraform test instance group"

  instances = [
    "${google_compute_instance.autocomplete_east.self_link}"
  ]

  named_port {
    name = "http"
    port = "8080"
  }

  zone = "us-east1-b"
}

resource "google_compute_instance_group" "webserverscentral" {
  name        = "webserverscentral"
  description = "Terraform test instance group"

  instances = [
    "${google_compute_instance.autocomplete_central.self_link}"
  ]

  named_port {
    name = "http"
    port = "8080"
  }

  zone = "us-central1-a"
  provider="google.central"
}


resource "google_compute_http_health_check" "default" {
  name               = "test"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port = 8080
}

resource "google_compute_backend_service" "backend" {
  name        = "backend"
  description = "Backend Service"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = true

  backend {
    group = "${google_compute_instance_group.webserverscentral.self_link}"
  }

  backend {
    group = "${google_compute_instance_group.webserverseast.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.default.self_link}"]
}

resource "google_compute_global_address" "lb_ip" {
  name = "lbip"
}

resource "google_compute_target_http_proxy" "http_lb_proxy" {
  name        = "http-proxy"
  description = "Load balancing front end http"
  url_map     = "${google_compute_url_map.http_lb_url_map.self_link}"
}

resource "google_compute_url_map" "http_lb_url_map" {
  name            = "global-url-map"
  default_service = "${google_compute_backend_service.backend.self_link}"
}

resource "google_compute_global_forwarding_rule" "http-lb" {
  name       = "lb-http"
  ip_address = "${google_compute_global_address.lb_ip.address}"
  target     = "${google_compute_target_http_proxy.http_lb_proxy.self_link}"
  port_range = "80"
}
