locals {
  cmk_uai = {
    resource_group_name = split("/", var.cmk_uai_id)[4]
    name                = split("/", var.cmk_uai_id)[8]
  }
}
