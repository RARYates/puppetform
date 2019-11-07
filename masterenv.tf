provider "google" {
  credentials = "${file("puppetform-7fcde307cc58.json")}"
  project     = "puppetform"
  region      = "us-central1"
}

resource "google_compute_instance" "master" {
  name         = "master"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["master"]

  boot_disk {
    initialize_params {
      image = "centos-7"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
  metadata = {
    startup-script = "${file("master.sh")}"
  }

#  provisioner "file" {
#    source      = "conf/master.sh"
#    destination = "/root/master.sh"
#  }

#  provisioner "local-exec" {
#    command = "/root/master.sh"
#  }

}

resource "google_compute_instance" "webserver" {
  name         = "webserver"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  tags = ["webserver"]

  boot_disk {
    initialize_params {
      image = "centos-7"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  provisioner "puppet" {
    server             = google_compute_instance.master.network_interface[0].network_ip
    extension_requests = {
      pp_role = "webserver"
    }
  }

  depends_on = [
    google_compute_instance.master
  ]

}