resource "google_compute_instance" "autocomplete_central" {
  name         = "autocompletecentral"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  provider = "google.central"

  tags = ["autocomplete"]

  disk {
    image = "ubuntu-java8"
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<EOT
#!/bin/bash

cd /home/sding
git clone https://github.com/datianshi/autocomplete-sample
cd autocomplete-sample
mvn clean package -Dmaven.test.skip=true
SPRING_CACHE_TYPE=none java -jar target/demo-0.0.1-SNAPSHOT.jar &


EOT

  service_account {
    email = "terraform@ps-sding.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "autocomplete_east" {
  name         = "autocompleteeast"
  machine_type = "n1-standard-1"
  zone         = "us-east1-b"

  tags = ["autocomplete"]

  disk {
    image = "ubuntu-java8"
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<EOT
#!/bin/bash

cd /home/sding
git clone https://github.com/datianshi/autocomplete-sample
cd autocomplete-sample
mvn clean package -Dmaven.test.skip=true
SPRING_CACHE_TYPE=none java -jar target/demo-0.0.1-SNAPSHOT.jar &


EOT

  service_account {
    email = "terraform@ps-sding.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}
