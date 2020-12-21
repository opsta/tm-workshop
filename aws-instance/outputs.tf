output "instance_name" {
  description = "Instance Name"
  value       = var.instance_name
}

output "public_ip" {
  description = "Instance Public IP"
  value       = aws_instance.instance[0].public_ip
}

output "private_ip" {
  description = "Instance Private IP"
  value       = aws_instance.instance[0].private_ip
}
