variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

# Map resource tags
# Each of the resources and modules declared in main.tf includes two tags: project_name and environment. 
# Assign these tags with a map variable type.
# https://developer.hashicorp.com/terraform/tutorials/configuration-language/variables?utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS#map-resource-tags
variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default     = {
    project     = "all",
    service     = "dagster"
    environment = "dev"

  }
}