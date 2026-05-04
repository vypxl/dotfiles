terraform {
  required_version = ">= 1.5.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.0"
    }
  }

  # Remote state in OCI Object Storage (S3-compatible API)
  backend "s3" {
    bucket = "terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"  # dummy — OCI region is in the endpoint URL, but AWS SDK needs a valid AWS region for signing

    # Replace <NAMESPACE> with the state_bucket_namespace output
    endpoints = { s3 = "https://zr0lewt7dddt.compat.objectstorage.eu-zurich-1.oraclecloud.com" }

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    use_path_style              = true
    skip_s3_checksum            = true
  }
}

provider "oci" {
  auth                = "SecurityToken"
  config_file_profile = var.oci_profile
  region              = var.region
}
