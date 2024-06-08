terraform {
  cloud {
    organization = "Rooftop_outsiders"
    hostname = "app.terraform.io" # Optional; defaults to app.terraform.io

    workspaces {
      name = "development"
    }
  }
  
  # required_providers {
  #   aws = {
  #     source  = "hashicorp/aws"
  #     version = "~> 5.43.0"
  #   }

  #   random = {
  #     source  = "hashicorp/random"
  #     version = "3.1.0"
  #   }
  # }

  # required_version = "~> 1.7.0"
}
