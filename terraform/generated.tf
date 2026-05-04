# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "ocid1.vcn.oc1.eu-zurich-1.amaaaaaao4rrwnyao6yhyjeqnfblstie3lhjjkni6j3baxc6f2t5qf5dggaa"
resource "oci_core_vcn" "main" {
  cidr_block     = "10.0.0.0/16"
  cidr_blocks    = ["10.0.0.0/16"]
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaayc5qzhaqzq7zmqwimuo3pyfbe4sm6otqal7h5ipcr3ff32pjd7a"
  defined_tags = {
    "Oracle-Tags.CreatedBy" = "vypxl0@gmail.com"
    "Oracle-Tags.CreatedOn" = "2022-01-19T10:30:48.424Z"
  }
  display_name            = "vcn-20220119-1121"
  dns_label               = "vcn01191130"
  freeform_tags           = {}
  ipv6private_cidr_blocks = []
  is_ipv6enabled          = true
  security_attributes     = {}
}

# __generated__ by Terraform from "ocid1.internetgateway.oc1.eu-zurich-1.aaaaaaaam4y647vgmpdlkhhv3orqs33mgcj2rnqfu67pnjojgt6m4sevvfoq"
resource "oci_core_internet_gateway" "main" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaayc5qzhaqzq7zmqwimuo3pyfbe4sm6otqal7h5ipcr3ff32pjd7a"
  defined_tags = {
    "Oracle-Tags.CreatedBy" = "vypxl0@gmail.com"
    "Oracle-Tags.CreatedOn" = "2022-01-19T10:30:49.096Z"
  }
  display_name  = "Internet Gateway vcn-20220119-1121"
  enabled       = true
  freeform_tags = {}
  vcn_id        = "ocid1.vcn.oc1.eu-zurich-1.amaaaaaao4rrwnyao6yhyjeqnfblstie3lhjjkni6j3baxc6f2t5qf5dggaa"
}

# __generated__ by Terraform from "ocid1.dhcpoptions.oc1.eu-zurich-1.aaaaaaaang2qt23hvzipp6dxqyjaztonpqjenhcm3ivlbh7m24nabatdsj5a"
resource "oci_core_default_dhcp_options" "default" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaayc5qzhaqzq7zmqwimuo3pyfbe4sm6otqal7h5ipcr3ff32pjd7a"
  defined_tags = {
    "Oracle-Tags.CreatedBy" = "vypxl0@gmail.com"
    "Oracle-Tags.CreatedOn" = "2022-01-19T10:30:48.424Z"
  }
  display_name               = "Default DHCP Options for vcn-20220119-1121"
  domain_name_type           = "CUSTOM_DOMAIN"
  freeform_tags              = {}
  manage_default_resource_id = "ocid1.dhcpoptions.oc1.eu-zurich-1.aaaaaaaang2qt23hvzipp6dxqyjaztonpqjenhcm3ivlbh7m24nabatdsj5a"
  options {
    custom_dns_servers  = []
    search_domain_names = ["vcn01191130.oraclevcn.com"]
    type                = "SearchDomain"
  }
  options {
    custom_dns_servers  = []
    search_domain_names = []
    server_type         = "VcnLocalPlusInternet"
    type                = "DomainNameServer"
  }
}

# __generated__ by Terraform from "ocid1.subnet.oc1.eu-zurich-1.aaaaaaaafei7cjfsg5y5cocrrijkjw6q7s5g3tmj2hjmsgsvrkg7sdppl67q"
resource "oci_core_subnet" "main" {
  cidr_block     = "10.0.0.0/24"
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaayc5qzhaqzq7zmqwimuo3pyfbe4sm6otqal7h5ipcr3ff32pjd7a"
  defined_tags = {
    "Oracle-Tags.CreatedBy" = "vypxl0@gmail.com"
    "Oracle-Tags.CreatedOn" = "2022-01-19T10:30:49.945Z"
  }
  dhcp_options_id            = "ocid1.dhcpoptions.oc1.eu-zurich-1.aaaaaaaang2qt23hvzipp6dxqyjaztonpqjenhcm3ivlbh7m24nabatdsj5a"
  display_name               = "subnet-20220119-1121"
  dns_label                  = "subnet01191130"
  freeform_tags              = {}
  ipv6cidr_block             = "2603:c022:4:a17e::/64"
  ipv6cidr_blocks            = ["2603:c022:0004:a17e:0000:0000:0000:0000/64"]
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
  route_table_id             = "ocid1.routetable.oc1.eu-zurich-1.aaaaaaaaqmzu3zcfc2r6oqb6g7hhr2fznnbovpzaykr7yb4m3jen23imztxa"
  security_list_ids          = ["ocid1.securitylist.oc1.eu-zurich-1.aaaaaaaaexic7wfnyxheprvauurv4jwwxj52sllkbxucnxckohzavljkaubq"]
  vcn_id                     = "ocid1.vcn.oc1.eu-zurich-1.amaaaaaao4rrwnyao6yhyjeqnfblstie3lhjjkni6j3baxc6f2t5qf5dggaa"
}

# __generated__ by Terraform from "ocid1.routetable.oc1.eu-zurich-1.aaaaaaaaghsqx55yjymwli3eap74iq57xebjtdgpj4uvdnuejtfzd542722q"
resource "oci_core_route_table" "main" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaayc5qzhaqzq7zmqwimuo3pyfbe4sm6otqal7h5ipcr3ff32pjd7a"
  defined_tags = {
    "Oracle-Tags.CreatedBy" = "oracleidentitycloudservice/vypxl0@gmail.com"
    "Oracle-Tags.CreatedOn" = "2022-11-14T21:58:20.227Z"
  }
  display_name  = "route table"
  freeform_tags = {}
  vcn_id        = "ocid1.vcn.oc1.eu-zurich-1.amaaaaaao4rrwnyao6yhyjeqnfblstie3lhjjkni6j3baxc6f2t5qf5dggaa"
  route_rules {
    destination       = "10.0.0.0/8"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "ocid1.internetgateway.oc1.eu-zurich-1.aaaaaaaam4y647vgmpdlkhhv3orqs33mgcj2rnqfu67pnjojgt6m4sevvfoq"
  }
  route_rules {
    destination       = "::/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "ocid1.internetgateway.oc1.eu-zurich-1.aaaaaaaam4y647vgmpdlkhhv3orqs33mgcj2rnqfu67pnjojgt6m4sevvfoq"
  }
}

# __generated__ by Terraform from "ocid1.routetable.oc1.eu-zurich-1.aaaaaaaaqmzu3zcfc2r6oqb6g7hhr2fznnbovpzaykr7yb4m3jen23imztxa"
resource "oci_core_default_route_table" "default" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaayc5qzhaqzq7zmqwimuo3pyfbe4sm6otqal7h5ipcr3ff32pjd7a"
  defined_tags = {
    "Oracle-Tags.CreatedBy" = "vypxl0@gmail.com"
    "Oracle-Tags.CreatedOn" = "2022-01-19T10:30:48.424Z"
  }
  display_name               = "Default Route Table for vcn-20220119-1121"
  freeform_tags              = {}
  manage_default_resource_id = "ocid1.routetable.oc1.eu-zurich-1.aaaaaaaaqmzu3zcfc2r6oqb6g7hhr2fznnbovpzaykr7yb4m3jen23imztxa"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "ocid1.internetgateway.oc1.eu-zurich-1.aaaaaaaam4y647vgmpdlkhhv3orqs33mgcj2rnqfu67pnjojgt6m4sevvfoq"
  }
  route_rules {
    destination       = "::/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "ocid1.internetgateway.oc1.eu-zurich-1.aaaaaaaam4y647vgmpdlkhhv3orqs33mgcj2rnqfu67pnjojgt6m4sevvfoq"
  }
}

# __generated__ by Terraform from "ocid1.publicip.oc1.eu-zurich-1.amaaaaaao4rrwnyadg3jidf4tilbi2fzqupnunwzfxghmz55oj7qtltlkmxa"
resource "oci_core_public_ip" "armada" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaayc5qzhaqzq7zmqwimuo3pyfbe4sm6otqal7h5ipcr3ff32pjd7a"
  defined_tags = {
    "Oracle-Tags.CreatedBy" = "oracleidentitycloudservice/vypxl0@gmail.com"
    "Oracle-Tags.CreatedOn" = "2022-04-28T15:12:51.602Z"
  }
  display_name  = "arm-server"
  freeform_tags = {}
  lifetime      = "RESERVED"
  private_ip_id = "ocid1.privateip.oc1.eu-zurich-1.ab5heljrep4wxfnu63vfynr77elicv3cgq2kqpt3w5jsoe5lg6am3zmunppq"
}

# __generated__ by Terraform from "ocid1.securitylist.oc1.eu-zurich-1.aaaaaaaaexic7wfnyxheprvauurv4jwwxj52sllkbxucnxckohzavljkaubq"
resource "oci_core_default_security_list" "default" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaayc5qzhaqzq7zmqwimuo3pyfbe4sm6otqal7h5ipcr3ff32pjd7a"
  defined_tags = {
    "Oracle-Tags.CreatedBy" = "vypxl0@gmail.com"
    "Oracle-Tags.CreatedOn" = "2022-01-19T10:30:48.424Z"
  }
  display_name               = "Default Security List for vcn-20220119-1121"
  freeform_tags              = {}
  manage_default_resource_id = "ocid1.securitylist.oc1.eu-zurich-1.aaaaaaaaexic7wfnyxheprvauurv4jwwxj52sllkbxucnxckohzavljkaubq"
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }
  egress_security_rules {
    destination      = "::/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }
  ingress_security_rules {
    description = "Minecraft tcp"
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 25565
      min = 25565
    }
  }
  ingress_security_rules {
    description = "Minecraft udp"
    protocol    = "17"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    udp_options {
      max = 25565
      min = 25565
    }
  }
  ingress_security_rules {
    description = "mediaserver tunnel tcp"
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 2333
      min = 2333
    }
  }
  ingress_security_rules {
    description = "mediaserver tunnel udp"
    protocol    = "17"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    udp_options {
      max = 2333
      min = 2333
    }
  }
  ingress_security_rules {
    description = "wireguard"
    protocol    = "17"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    udp_options {
      max = 51820
      min = 51820
    }
  }
  ingress_security_rules {
    protocol    = "1"
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    stateless   = false
    icmp_options {
      code = -1
      type = 3
    }
  }
  ingress_security_rules {
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    icmp_options {
      code = 4
      type = 3
    }
  }
  ingress_security_rules {
    protocol    = "1"
    source      = "::/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 22
      min = 22
    }
  }
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 443
      min = 443
    }
  }
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 80
      min = 80
    }
  }
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 6443
      min = 6443
    }
  }
}

# __generated__ by Terraform from "ocid1.instance.oc1.eu-zurich-1.an5heljro4rrwnycltyix5cbkyx6z7a5atndx4spszhehtvkj5kqsd7ihj4q"
resource "oci_core_instance" "armada" {
  async                      = null
  availability_domain        = "FBlQ:EU-ZURICH-1-AD-1"
  cluster_placement_group_id = null
  compartment_id             = "ocid1.tenancy.oc1..aaaaaaaaayc5qzhaqzq7zmqwimuo3pyfbe4sm6otqal7h5ipcr3ff32pjd7a"
  defined_tags = {
    "Oracle-Tags.CreatedBy" = "vypxl0@gmail.com"
    "Oracle-Tags.CreatedOn" = "2022-01-19T10:30:53.600Z"
  }
  display_name      = "arm_server"
  extended_metadata = {}
  fault_domain      = "FAULT-DOMAIN-1"
  freeform_tags     = {}
  metadata = {
    ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqYPIXeKGcl6rG8eqRWFeEN4vfz9pPQ2+wUgtBAWsLTch7NkZT4SVmImuC2Jw0/T+zNuOxtE5AJQvzczc5v/9uiwC+avS12RSDZyKN7ucRTtnU29pyZs+W6FE2/qnxFNhqrkHv0DOKcB8xtivXhNGizKT3io8wZovWEuPx4BidQdEf/GzdALY/ZLtEolUzfncwiDYY0G3hjjwInVKT/+Dzo9U0fkDfY3X64C/4HaRMwtgq+rpcwCAmY9cbRAv/v1xcwlRMfPe3ANfVvJPI2vRe9wjcY+2OTt8jlPRmunu8ax5zkjZIr6kz79Stw2ztdBzai5kiH7M0YMCnrumJpGNPchcBEbabm52iLVDWNUr8BwiKzu7S5aCDgElNnS0zmOHA5/eXOD6Iyz7Tts2X3Yc+6SFQJXVYJGMrmuRekZjtPoobdFAUdtbtjRdKqbnqJ4Y97s5ig/oM9EQpklT25JwqcTJqhcAawFXTd+a/cCesJdadU4fmnLsThlflo1zfFcU= thomas@basalt"
  }
  preserve_boot_volume                    = null
  preserve_data_volumes_created_at_launch = null
  security_attributes                     = {}
  shape                                   = "VM.Standard.A1.Flex"
  state                                   = "RUNNING"
  update_operation_constraint             = null
  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }
  availability_config {
    is_live_migration_preferred = false
    recovery_action             = "RESTORE_INSTANCE"
  }
  create_vnic_details {
    assign_ipv6ip             = false
    assign_private_dns_record = false
    assign_public_ip          = "true"
    defined_tags = {
      "Oracle-Tags.CreatedBy" = "vypxl0@gmail.com"
      "Oracle-Tags.CreatedOn" = "2022-01-19T10:30:53.720Z"
    }
    display_name           = "arm-server"
    freeform_tags          = {}
    hostname_label         = "armserver"
    nsg_ids                = []
    private_ip             = "10.0.0.232"
    security_attributes    = {}
    skip_source_dest_check = true
    subnet_id              = "ocid1.subnet.oc1.eu-zurich-1.aaaaaaaafei7cjfsg5y5cocrrijkjw6q7s5g3tmj2hjmsgsvrkg7sdppl67q"
  }
  instance_options {
    are_legacy_imds_endpoints_disabled = false
  }
  launch_options {
    boot_volume_type                    = "PARAVIRTUALIZED"
    firmware                            = "UEFI_64"
    is_consistent_volume_naming_enabled = true
    is_pv_encryption_in_transit_enabled = true
    network_type                        = "PARAVIRTUALIZED"
    remote_data_volume_type             = "PARAVIRTUALIZED"
  }
  shape_config {
    memory_in_gbs = 24
    nvmes         = 0
    ocpus         = 4
    vcpus         = 4
  }
  source_details {
    boot_volume_size_in_gbs         = "100"
    boot_volume_vpus_per_gb         = "10"
    is_preserve_boot_volume_enabled = false
    kms_key_id                      = null
    source_id                       = "ocid1.image.oc1.eu-zurich-1.aaaaaaaatqomsnqxsskhlue3ywdk2ufbnj6brdkwcv4vcqdyuo6o6bd3tqzq"
    source_type                     = "image"
  }
}

# __generated__ by Terraform from "ocid1.instance.oc1.eu-zurich-1.an5heljro4rrwnycijz7lp5rcja5ru2hrel76vzsauzruruvfv6iowzgtiva"
resource "oci_core_instance" "x86_server" {
  async                      = null
  availability_domain        = "FBlQ:EU-ZURICH-1-AD-1"
  cluster_placement_group_id = null
  compartment_id             = "ocid1.tenancy.oc1..aaaaaaaaayc5qzhaqzq7zmqwimuo3pyfbe4sm6otqal7h5ipcr3ff32pjd7a"
  defined_tags = {
    "Oracle-Tags.CreatedBy" = "oracleidentitycloudservice/vypxl0@gmail.com"
    "Oracle-Tags.CreatedOn" = "2022-04-28T15:20:52.168Z"
  }
  display_name      = "x86-server-0"
  extended_metadata = {}
  fault_domain      = "FAULT-DOMAIN-2"
  freeform_tags     = {}
  metadata = {
    ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDK43S92kzw5CvpiKDNxhzP06TgLKEC+gPyCVitj9LqilqZf98e/0TyYd5HWsOU6E9R3jbPkplzLAENzxQ9lrZQSvKx9vs85cxeJ0qOjILoMdXg9LUA4rgqdeyiNluG/6iiqA/hphTDK78j7+A1wtwPUGCXdOPAf3OyNtII27LE7BdoEE4hSJUyRAtsjwpHK1ObT+jU/4zuuir/6kkPKW5oOyG3KG7YLEwQtCq+HGJXswf34zU85N7H2G0O/hvCn+T4M2Z2NdbE4P3TG1BKqAX9/s6aENZ4kDI14gObc2TrvwsOzWhhdEU2rb+EhysZz4xgqrL9RZkcUMYh2DP0gT6OhaWFGK5kncWBB8kfV01E6M/fcfRLuPGNZlWzZBUrXuskSiyJxwzKTMKo+oZWFalUuTvkzVGc51IpITKcP/9lOdLmu6+ychgiR6zwo2ntiPZSwh0VTsMDUWWBwEhDgcH4nOn7OmQIHHIijf/ug+hsb3fw03qZruFFh6EmLlKTAsgy10mNv2xTppcsHtJR072r6AVsq+iGgSplEgxYRUIXYb2IPbOtPpqqjL7KsVRbqlT7ebAQ58mUhTcBLpqfWeUvjcP1+SofadI6qsyWCxp1RYgeUY7bBNhJXI5SsxrXkJwzmWuNe1kLguxRZnykJjVaPBAF4OQXn9Qhc6/szMXfMw== vypxl0+coding@gmail.com"
  }
  preserve_boot_volume                    = null
  preserve_data_volumes_created_at_launch = null
  security_attributes                     = {}
  shape                                   = "VM.Standard.E2.1.Micro"
  state                                   = "RUNNING"
  update_operation_constraint             = null
  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }
  availability_config {
    is_live_migration_preferred = false
    recovery_action             = "RESTORE_INSTANCE"
  }
  create_vnic_details {
    assign_ipv6ip             = false
    assign_private_dns_record = false
    assign_public_ip          = "true"
    defined_tags = {
      "Oracle-Tags.CreatedBy" = "oracleidentitycloudservice/vypxl0@gmail.com"
      "Oracle-Tags.CreatedOn" = "2022-04-28T15:20:52.304Z"
    }
    display_name           = "x86-server-0"
    freeform_tags          = {}
    hostname_label         = "x86-server-0"
    nsg_ids                = []
    private_ip             = "10.0.0.169"
    security_attributes    = {}
    skip_source_dest_check = false
    subnet_id              = "ocid1.subnet.oc1.eu-zurich-1.aaaaaaaafei7cjfsg5y5cocrrijkjw6q7s5g3tmj2hjmsgsvrkg7sdppl67q"
  }
  instance_options {
    are_legacy_imds_endpoints_disabled = false
  }
  launch_options {
    boot_volume_type                    = "PARAVIRTUALIZED"
    firmware                            = "UEFI_64"
    is_consistent_volume_naming_enabled = true
    is_pv_encryption_in_transit_enabled = false
    network_type                        = "PARAVIRTUALIZED"
    remote_data_volume_type             = "PARAVIRTUALIZED"
  }
  shape_config {
    memory_in_gbs = 1
    nvmes         = 0
    ocpus         = 1
    vcpus         = 2
  }
  source_details {
    boot_volume_size_in_gbs         = "47"
    boot_volume_vpus_per_gb         = "10"
    is_preserve_boot_volume_enabled = false
    kms_key_id                      = null
    source_id                       = "ocid1.image.oc1.eu-zurich-1.aaaaaaaajnd3h3nq2hotdp4hctcfgib5aaao6dx43jr6zu65bgtrour6b24q"
    source_type                     = "image"
  }
}
