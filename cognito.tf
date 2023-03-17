resource "aws_cognito_user_pool" "user_pool" {
  name = "user-pool"
  alias_attributes = ["preferred_username"]
  auto_verified_attributes = ["email"]

  username_configuration {
    case_sensitive = false
  }

  password_policy {
    minimum_length = 8
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_LINK"
    email_subject_by_link = "Upward Mobility Account Confirmation"
    email_message_by_link = "To confirm your Upward Mobility account, navigate to {##Click Here##}"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "cognito-client"

  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = false
  refresh_token_validity = 90
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]

}

resource "aws_route53_record" "auth-cognito-A" {
  name    = aws_cognito_user_pool_domain.cognito-domain.domain
  type    = "A"
  zone_id = aws_route53_zone.route53_zone.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.cognito-domain.cloudfront_distribution_arn
    # This zone_id is fixed
    zone_id = "Z2FDTNDATAQYW2"
  }
}

resource "aws_cognito_user_pool_domain" "cognito-domain" {
  domain       = var.cognito_domain_name
  certificate_arn = aws_acm_certificate.ssl_certificate.arn
  user_pool_id = "${aws_cognito_user_pool.user_pool.id}"
}

