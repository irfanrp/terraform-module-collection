output "endpoint" {
  description = "The RDS endpoint address"
  value       = try(aws_db_instance.this.endpoint, null)
}

output "port" {
  description = "The database port"
  value       = try(aws_db_instance.this.port, null)
}

output "id" {
  description = "The RDS DB instance id"
  value       = try(aws_db_instance.this.id, null)
}
