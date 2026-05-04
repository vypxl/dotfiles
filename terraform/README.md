# Terraform (OCI)

Manages the Oracle Cloud infrastructure for `armada` and `x86-server-0`.

## Setup on a new machine

1. `oci session authenticate` — browser login, creates `~/.oci/config`
2. Create `terraform.tfvars` with `region`, `compartment_ocid` (see `variables.tf`)
3. Create `backend.conf` with `access_key` and `secret_key` (OCI Customer Secret Key)
4. `terraform init -backend-config=backend.conf`

## OCI S3 quirks

State is stored in an OCI Object Storage bucket via the S3-compatible API. This
works but requires several workarounds because OCI's S3 implementation is incomplete:

- **`region = "us-east-1"`** — OCI ignores this (the real region is in the endpoint URL),
  but the AWS SDK refuses to sign requests with OCI region names.
- **`skip_s3_checksum = true`** — OCI doesn't support S3 checksums.
- **`skip_*_validation`** — disables various AWS-specific checks that fail against OCI.
- **`use_path_style = true`** — OCI uses path-style URLs, not virtual-hosted-style.
- **`AWS_REQUEST_CHECKSUM_CALCULATION=WHEN_REQUIRED`** / **`AWS_RESPONSE_CHECKSUM_VALIDATION=WHEN_REQUIRED`**
  (set in the devShell) — without these, the AWS SDK v2 in Terraform ≥1.10 sends
  chunked transfer encoding, which OCI rejects with `501 Not Implemented`.

## OCI provider auth

Uses `SecurityToken` auth (browser-based session via `oci session authenticate`).
Tokens last 1 hour, refresh with `oci session refresh` (up to 24h).
