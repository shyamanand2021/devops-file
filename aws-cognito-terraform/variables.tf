# variables.tf
variable "minimum_password_length" {
  description = "Minimum password length for the user pool"
  type        = number
  default     = 8
}

variable "client_name" {
  description = "Name of the Cognito user pool client"
  type        = string
  default     = "prod-ats_admin_client"
}

variable "generate_client_secret" {
  description = "Whether to generate a client secret"
  type        = bool
  default     = false
}

variable "callback_urls" {
  description = "List of allowed callback URLs for the app client"
  type        = list(string)
  default     = ["http://localhost:3000/callback"]
}

variable "logout_urls" {
  description = "List of allowed logout URLs for the app client"
  type        = list(string)
  default     = ["http://localhost:3000"]
}
