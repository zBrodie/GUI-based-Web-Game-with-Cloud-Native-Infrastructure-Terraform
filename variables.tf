variable "domain_name" {
  type = string
  description = "Website domain name."
}

variable "bucket_name" {
  type = string
}

variable "error_page" {
  type = string
  description = "File name for the error document."
}

variable "index_page" {
  type = string
  description = "File name for the index document."
}