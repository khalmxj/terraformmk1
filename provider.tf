provider "aws" {
  region     = "eu-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

# terraform { 
#   cloud { 
    
#     organization = "Meraj-Natwest" 

#     workspaces { 
#       name = "Project-Terraform" 
#     } 
#   } 
# }