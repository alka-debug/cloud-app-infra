terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}
provider "docker" {}
resource "docker_image" "flask_app" {
 name           = "alka2212/flask-cloud-app:latest"
 keep_locally   = false
}
resource "docker_container" "flask_container" {
  name  = "flask-app"
  image = docker_image.flask_app.name
  must-run = true
  restart = "unless-stopped"
  ports {
       internal = 7000
       external = 7000
  }
}
