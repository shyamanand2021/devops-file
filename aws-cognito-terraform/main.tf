# modules/cognito_user_pool/main.tf

provider "aws" {
  region = "us-east-1"
}

resource "aws_cognito_user_pool" "user_pool" {
  name = "prod-ats_admin_cognito_pool_test"

  # Email is used as the username
  username_attributes = ["email"]
  auto_verified_attributes = ["email"]

  # Password policy
  password_policy {
    minimum_length                   = var.minimum_password_length
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  # Schema attributes
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true  # Only standard attributes can be required

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  # Custom attributes - all set to required=false
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "firstName"
    required                 = false  # Changed from true to false

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "lastName"
    required                 = false  # Changed from true to false

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "companyName"
    required                 = false

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "mobileNo"
    required                 = false

    string_attribute_constraints {
      min_length = 1
      max_length = 20
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "role"
    required                 = false  # Changed from true to false

    string_attribute_constraints {
      min_length = 1
      max_length = 50
    }
  }

  # Email configuration
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # Verification message template
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Your verification code"
    email_message        = "Your verification code is {####}"
  }

  # Account recovery settings
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  tags = {
    Environment = "prod"
    Application = "ats_admin"
  }
}

# Client application
resource "aws_cognito_user_pool_client" "client" {
  name                                 = var.client_name
  user_pool_id                         = aws_cognito_user_pool.user_pool.id
  generate_secret                      = var.generate_client_secret
  explicit_auth_flows                  = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  supported_identity_providers         = ["COGNITO"]
}
