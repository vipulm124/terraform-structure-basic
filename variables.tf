variable "resource_location" {
  default = "centralindia"

}

variable "resource_group_name" {
  default = "MyResourceGroupNew"
}

variable "service_plan_name" {
  default = "serviceplandev"
}

variable "frontend_app_name" {
  default = "terraformfrontendapp"
}

variable "backend_app_name" {
  default = "terraformbackendapp"
}

variable "mysql_servername" {
  default = "terraformmysql"
}

variable "mysql_db_username" {
  default = "adminuser"
}
variable "mysql_db_password" {
  default = "Password123$$"
}