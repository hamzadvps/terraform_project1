output "instance_public_ip" {
  value = aws_instance.my_instance1.public_ip
}

output "terraform_message" {
  value = "This is my first instance in AWS created using Terraform"
}
