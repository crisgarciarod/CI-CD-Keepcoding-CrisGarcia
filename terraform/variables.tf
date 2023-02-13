variable "region" {
  default = "eu-west-1"
  description = "Region en la que se ha creado el proyecto"
}

variable "aws_s3_bucket" {
  default = "acme-storage"
  description = "Nombre del bucket"
}

variable "aws_s3_bucket_env" {
  default = "dev"
  description = "Entorno del bucket"
}
