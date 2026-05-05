# context.tf — standard cloudposse/label/null context boilerplate
# Source: https://github.com/cloudposse/terraform-null-label
# Do not hand-edit; re-download from source when upgrading.

module "this" {
  source  = "cloudposse/label/null"
  version = "~> 0.25"

  enabled             = var.enabled
  namespace           = var.namespace
  tenant              = var.tenant
  environment         = var.environment
  stage               = var.stage
  name                = var.name
  delimiter           = var.delimiter
  attributes          = var.attributes
  tags                = var.tags
  additional_tag_map  = var.additional_tag_map
  label_order         = var.label_order
  regex_replace_chars = var.regex_replace_chars
  id_length_limit     = var.id_length_limit
  label_key_case      = var.label_key_case
  label_value_case    = var.label_value_case
  descriptor_formats  = var.descriptor_formats
  labels_as_tags      = var.labels_as_tags

  context = var.context
}

variable "context" {
  type = any
  default = {
    enabled             = true
    namespace           = null
    tenant              = null
    environment         = null
    stage               = null
    name                = null
    delimiter           = null
    attributes          = []
    tags                = {}
    additional_tag_map  = {}
    regex_replace_chars = null
    label_order         = []
    id_length_limit     = null
    label_key_case      = null
    label_value_case    = null
    descriptor_formats  = {}
    labels_as_tags      = ["unset"]
  }
  description = "Single object for setting entire context at once. See description of individual variables for details. Leave string and numeric variables as `null` to use default value."

  validation {
    condition     = lookup(var.context, "label_key_case", null) == null ? true : contains(["lower", "title", "upper", "none"], lookup(var.context, "label_key_case"))
    error_message = "Allowed values: `lower`, `title`, `upper`, `none`."
  }

  validation {
    condition     = lookup(var.context, "label_value_case", null) == null ? true : contains(["lower", "title", "upper", "none"], lookup(var.context, "label_value_case"))
    error_message = "Allowed values: `lower`, `title`, `upper`, `none`."
  }
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "namespace" {
  type        = string
  default     = null
  description = "ID element. Usually the organization or company name."
}

variable "tenant" {
  type        = string
  default     = null
  description = "ID element. A customer identifier, used to scope resources."
}

variable "environment" {
  type        = string
  default     = null
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2'."
}

variable "stage" {
  type        = string
  default     = null
  description = "ID element. Usually used to indicate role, e.g. 'prod', 'staging'."
}

variable "name" {
  type        = string
  default     = null
  description = "ID element. Usually the component or solution name."
}

variable "delimiter" {
  type        = string
  default     = null
  description = "Delimiter to be used between ID elements. Defaults to `-` (hyphen)."
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "ID element. Additional attributes appended to the ID."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`)."
}

variable "additional_tag_map" {
  type        = map(string)
  default     = {}
  description = "Additional key-value pairs to add to each map in `tags_as_list_of_maps`."
}

variable "label_order" {
  type        = list(string)
  default     = null
  description = "The order in which the labels (ID elements) appear in the `id`. Defaults to [\"namespace\",\"environment\",\"stage\",\"name\",\"attributes\"]."
}

variable "regex_replace_chars" {
  type        = string
  default     = null
  description = "Terraform regular expression (regex) string to replace chars with `-` in namespace, name, tenant, and environment."
}

variable "id_length_limit" {
  type        = number
  default     = null
  description = "Limit `id` to this many characters (minimum 6). Set to `0` for unlimited length."

  validation {
    condition     = var.id_length_limit == null ? true : var.id_length_limit >= 6 || var.id_length_limit == 0
    error_message = "The id_length_limit must be >= 6 if supplied (not null), or 0 for unlimited length."
  }
}

variable "label_key_case" {
  type        = string
  default     = null
  description = "Controls the letter case of the `tags` keys (label names). Possible values: `lower`, `title`, `upper`, `none`."

  validation {
    condition     = var.label_key_case == null ? true : contains(["lower", "title", "upper", "none"], var.label_key_case)
    error_message = "Allowed values: `lower`, `title`, `upper`, `none`."
  }
}

variable "label_value_case" {
  type        = string
  default     = null
  description = "Controls the letter case of ID elements (labels) as included in `id`. Possible values: `lower`, `title`, `upper`, `none`."

  validation {
    condition     = var.label_value_case == null ? true : contains(["lower", "title", "upper", "none"], var.label_value_case)
    error_message = "Allowed values: `lower`, `title`, `upper`, `none`."
  }
}

variable "descriptor_formats" {
  type        = any
  default     = {}
  description = "Describe additional descriptors to be output in the `descriptors` output map. Keys are names of descriptors. Values are maps of the form `{format = string, labels = list(string)}` (labels are optional; defaults to `[]`)."
}

variable "labels_as_tags" {
  type        = set(string)
  default     = ["unset"]
  description = "Set of labels (ID elements) to include as tags in the `tags` output. Default is to include all labels."
}
