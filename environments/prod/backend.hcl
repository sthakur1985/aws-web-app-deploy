bucket         = "terraform-state-bucket-prod-021125"
key            = "envs/prod/terraform.tfstate"
region         = "eu-west-2"
dynamodb_table = "terraform-lock-table"
encrypt        = true
