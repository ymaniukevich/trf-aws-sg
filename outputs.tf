output "id" {
  description = <<EOD
    The ID of the security group. |
```
sg-0bf150978338a2ade
```
EOD
  value       = element(concat(aws_security_group.this.*.id, [""]), 0)
}

output "arn" {
  description = <<EOD
    The ARN of the security group. |
```
arn:aws:ec2:us-east-1:690612908881:security-group/sg-0bf150978338a2ade
```
EOD
  value       = element(concat(aws_security_group.this.*.arn, [""]), 0)
}

output "vpc_id" {
  description = <<EOD
    The VPC ID. |
```
vpc-03f1c1e0ababa81ce
```
EOD
  value       = element(concat(aws_security_group.this.*.vpc_id, [""]), 0)
}

output "owner_id" {
  description = <<EOD
    The owner ID. |
```
690612908881
```
EOD
  value       = element(concat(aws_security_group.this.*.owner_id, [""]), 0)
}

output "name" {
  description = <<EOD
    The name of the security group. |
```
iad-1741-sg
```
EOD
  value       = element(concat(aws_security_group.this.*.name, [""]), 0)
}