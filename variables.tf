variable "sg-create" {
  description = <<EOD
Specify `true` in case you need to create Security group |
**Optional** |
```
false
```
EOD
  type        = bool

  default = true
}

variable "sg-description" {
  description = <<EOD
The security group description. |
**Optional** |
```
"Managed by Terraform"
```
EOD

  type    = string
  default = "Managed by Terraform"
}

variable "sg-vpc_id" {
  description = <<EOD
The VPC ID. |
**Optional** |
```
"vpc-0a821bd339d"
```
EOD

  type    = string
  default = ""
}

variable "sg-ingress_rules" {
  description = <<EOD
List of ingress rules. |
**Optional** |
```
[
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_block  = "172.31.32.0/20"
    ipv6_cidr_blocks = "::/0"
    description = "Allow Backend network."
  },
]
```
EOD

  type    = list(any)
  default = []
}

variable "sg-egress_rules" {
  description = <<EOD
List of egress rules. |
**Optional** |
```
[
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_block  = "0.0.0.0/0"
    ipv6_cidr_blocks = "::/0"
    description = "Allow all outgoing traffic"
  },
]
```
EOD

  type = list(any)

  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
      description = "Default outbound rule"
    },
  ]
}

variable "sg-ingress_rules_with_sg" {
  description = <<EOD
List of ingress rules with security group |
**Optional** |
```
[
  {
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    source_security_group_id = "sg-0070260fd979ebc55"
    description              = "Allow Backend sg."
  },
]
```
EOD

  type = list(object(
    {
      from_port                = number
      to_port                  = number
      protocol                 = string
      source_security_group_id = string
      description              = string
    }
  ))

  default = []
}

variable "sg-ingress_rules_self" {
  description = <<EOD
List of ingress rules allowed within created SG |
**Optional** |
```
[
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow inbound HTTP traffic within SG only"
  },
]
```
EOD

  type = list(object(
    {
      from_port   = number
      to_port     = number
      protocol    = string
      description = string
    }
  ))

  default = []
}

variable "sg-egress_rules_with_sg" {
  description = <<EOD
List of egress rules with security group |
**Optional** |
```
[
  {
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    source_security_group_id = "Allow Backend sg."
    cidr_block               = "sg-0070260fd979ebc55"
  },
]
```
EOD

  type = list(object(
    {
      from_port                = number
      to_port                  = number
      protocol                 = string
      source_security_group_id = string
      description              = string
    }
  ))

  default = []
}

variable "sg-egress_rules_self" {
  description = <<EOD
List of egress rules allowed within created SG |
**Optional** |
```
[
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow outbound HTTP traffic within SG only"
  },
]
```
EOD

  type = list(object(
    {
      from_port   = number
      to_port     = number
      protocol    = string
      description = string
    }
  ))

  default = []
}

variable "resource_name_pattern" {
  description = <<EOD
The name of the security group |
**Optional** |
```
"iad-na-dev"
```
EOD

  type    = string
  default = ""
}
variable "tags" {
  description = <<EOD
A mapping of tags to assign to the resource. |
**Required** |
```
{"iad" = "dev"}
```
EOD

  type = map(string)
}