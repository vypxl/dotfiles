variable "oci_profile" {
  description = "Profile name in ~/.oci/config (created by `oci session authenticate`)"
  type        = string
  default     = "DEFAULT"
}

variable "region" {
  description = "OCI region identifier (e.g. eu-zurich-1)"
  type        = string
}

variable "compartment_ocid" {
  description = "OCID of the compartment containing the resources"
  type        = string
}
