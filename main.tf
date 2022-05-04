terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.22.2"
    }
  }
}

provider "rancher2" {
  api_url   = var.rancher_url
  token_key = var.rancher_token_key
  insecure  = true
}

data "rancher2_user" "foo" {
  count    = 500
  username = "tuser${count.index}"
}


resource "rancher2_project_role_template_binding" "foo" {
  count            = 500
  name             = "foo"
  project_id       = "p-r5ctd"
  role_template_id = "cluster-member"
  user_id          = data.rancher2_user.foo[count.index].id
}


output "data" {
  value = [
    for rancher2_user in data.rancher2_user.foo : rancher2_user.id
  ]
}

# Variable section

variable "rancher_url" {
  type        = string
  description = "URL for Rancher."
}

variable "rancher_token_key" {
  type        = string
  description = "API bearer token for Rancher."
  sensitive   = true
}

