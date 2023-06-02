# Interpolate variables in strings:
# Terraform configuration supports string interpolation — 
# inserting the output of an expression into a string.
# This allows you to use variables, local values, and the output of functions 
# to create strings in your configuration.
# https://developer.hashicorp.com/terraform/tutorials/configuration-language/variables?utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS#interpolate-variables-in-strings

# Use locals to name resources:
# In the configuration's main.tf file, several resource names consist of interpolations 
# of the resource type and the project and environment values from the resource_tags variable. 
# Reduce duplication and simplify the configuration by setting the shared part 
# of each name as a local value to re-use across your configuration.
# https://developer.hashicorp.com/terraform/tutorials/configuration-language/locals#use-locals-to-name-resources
locals {
  namespace_suffix = "${var.resource_tags["project"]}-${var.resource_tags["environment"]}"
  name_svc_suffix = "${var.resource_tags["project"]}-${var.resource_tags["service"]}-${var.resource_tags["environment"]}"
}

# Namespaces in Kubernetes are logical isolation for deployment.
# Creating namespace with the Kubernetes provider is better than auto-creation in the helm_release.
# You can reuse the namespace and customize it with quotas and labels.
resource "kubernetes_namespace_v1" "namespace" {
    metadata {
        name    = "${local.name_svc_suffix}"
        labels  = {
          "app" = "${var.resource_tags["project"]}"
        }
    }
}