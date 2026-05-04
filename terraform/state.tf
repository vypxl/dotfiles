data "oci_objectstorage_namespace" "this" {
  compartment_id = var.compartment_ocid
}

resource "oci_objectstorage_bucket" "terraform_state" {
  compartment_id = var.compartment_ocid
  namespace      = data.oci_objectstorage_namespace.this.namespace
  name           = "terraform-state"
  access_type    = "NoPublicAccess"
  versioning     = "Enabled"
}

output "state_bucket_namespace" {
  value = data.oci_objectstorage_namespace.this.namespace
}

output "state_bucket_s3_endpoint" {
  value = "https://${data.oci_objectstorage_namespace.this.namespace}.compat.objectstorage.${var.region}.oraclecloud.com"
}
