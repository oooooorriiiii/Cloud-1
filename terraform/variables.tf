variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-northeast1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "asia-northeast1-b"
}

variable "credentials_file" {
  description = "Path to the GCP Service Account JSON key"
  type        = string
}

variable "ssh_user" {
  description = "SSH Username for Ansible"
  type        = string
  default     = "deploy_user"
}

variable "ssh_pub_key_path" {
  description = "Path to public SSH key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "machine_type" {
  description = "GCP VM Machine Type"
  type        = string
  default     = "e2-medium"
}