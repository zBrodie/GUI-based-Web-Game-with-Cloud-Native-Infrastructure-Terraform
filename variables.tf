variable "domain_name" {
  type = string
  description = "Website domain name."
}

variable "cognito_domain_name" {
  type = string
  description = "Cognito subdomain name."
}

variable "bucket_name" {
  type = string
  description = "The name of the S3 bucket that holds the website files"
}

variable "game_bucket" {
  type = string
  description = "The name of the S3 bucket that holds the game files"
}

variable "error_page" {
  type = string
  description = "File name for the error document."
}

variable "index_page" {
  type = string
  description = "File name for the index document."
}

variable "region" {
  type = string
  description = "Default aws region"
}