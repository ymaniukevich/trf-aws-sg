locals {
  resource_name_pattern = "${var.resource_name_pattern}-sg"
}

resource "aws_security_group" "this" {
  count       = var.sg-create ? 1 : 0
  description = var.sg-description
  vpc_id      = var.sg-vpc_id
  name        = local.resource_name_pattern

  tags = merge({
    "Name"              = local.resource_name_pattern,
  }, var.tags)

  lifecycle {
    ignore_changes = [name]
  }
}

locals {
  sg-ingress_rules = { for rule in var.sg-ingress_rules :
    "${rule.protocol == "-1" ? "all" : rule.protocol}-allow-cidr-${rule.from_port}-${rule.to_port}-${md5(jsonencode(rule))}" => rule
  }
  sg-egress_rules = { for rule in var.sg-egress_rules :
    "${rule.protocol == "-1" ? "all" : rule.protocol}-allow-cidr-${rule.from_port}-${rule.to_port}-${md5(jsonencode(rule))}" => rule
  }

  # "for_each" value cannot depends on resource attributes that cannot be determined until apply (sg id, etc.)
  sg-ingress_rules_with_sg = { for rule in var.sg-ingress_rules_with_sg :
    "${rule.protocol == "-1" ? "all" : rule.protocol}-allow-sg-${rule.from_port}-${rule.to_port}-${md5(join("-", [rule.protocol, rule.from_port, rule.to_port, rule.description]))}" => rule
  }
  sg-ingress_rules_self = { for rule in var.sg-ingress_rules_self :
    "${rule.protocol == "-1" ? "all" : rule.protocol}-allow-sg-${rule.from_port}-${rule.to_port}-${md5(join("-", [rule.protocol, rule.from_port, rule.to_port, rule.description]))}" => rule
  }
  sg-egress_rules_with_sg = { for rule in var.sg-egress_rules_with_sg :
    "${rule.protocol == "-1" ? "all" : rule.protocol}-allow-sg-${rule.from_port}-${rule.to_port}-${md5(join("-", [rule.protocol, rule.from_port, rule.to_port, rule.description]))}" => rule
  }
  sg-egress_rules_self = { for rule in var.sg-egress_rules_self :
    "${rule.protocol == "-1" ? "all" : rule.protocol}-allow-sg-${rule.from_port}-${rule.to_port}-${md5(join("-", [rule.protocol, rule.from_port, rule.to_port, rule.description]))}" => rule
  }
}

resource "aws_security_group_rule" "ingress_rules_with_cidr" {
  for_each = length(aws_security_group.this[*]) > 0 ? local.sg-ingress_rules : {}

  security_group_id = aws_security_group.this[0].id
  type              = "ingress"

  from_port        = lookup(each.value, "from_port")
  to_port          = lookup(each.value, "to_port")
  protocol         = lookup(each.value, "protocol")
  cidr_blocks      = length(element(split(",", lookup(each.value, "cidr_block", "")), 0)) == 0 ? [] : split(",", lookup(each.value, "cidr_block"))
  ipv6_cidr_blocks = length(element(split(",", lookup(each.value, "ipv6_cidr_blocks", "")), 0)) == 0 ? [] : split(",", lookup(each.value, "ipv6_cidr_blocks"))
  description      = lookup(each.value, "description")
}

resource "aws_security_group_rule" "egress_rules_with_cidr" {
  for_each = length(aws_security_group.this[*]) > 0 ? local.sg-egress_rules : {}

  security_group_id = aws_security_group.this[0].id
  type              = "egress"

  from_port        = lookup(each.value, "from_port")
  to_port          = lookup(each.value, "to_port")
  protocol         = lookup(each.value, "protocol")
  cidr_blocks      = length(element(split(",", lookup(each.value, "cidr_block", "")), 0)) == 0 ? [] : split(",", lookup(each.value, "cidr_block"))
  ipv6_cidr_blocks = length(element(split(",", lookup(each.value, "ipv6_cidr_blocks", "")), 0)) == 0 ? [] : split(",", lookup(each.value, "ipv6_cidr_blocks"))
  description      = lookup(each.value, "description")
}

resource "aws_security_group_rule" "ingress_with_source_security_group_id" {
  for_each = length(aws_security_group.this[*]) > 0 ? local.sg-ingress_rules_with_sg : {}

  security_group_id = aws_security_group.this[0].id
  type              = "ingress"

  from_port                = lookup(each.value, "from_port")
  to_port                  = lookup(each.value, "to_port")
  protocol                 = lookup(each.value, "protocol")
  source_security_group_id = lookup(each.value, "source_security_group_id")
  description              = lookup(each.value, "description")
}

resource "aws_security_group_rule" "ingress_with_self" {
  for_each = length(aws_security_group.this[*]) > 0 ? local.sg-ingress_rules_self : {}

  security_group_id = aws_security_group.this[0].id
  type              = "ingress"

  from_port   = lookup(each.value, "from_port")
  to_port     = lookup(each.value, "to_port")
  protocol    = lookup(each.value, "protocol")
  self        = true
  description = lookup(each.value, "description")
}

resource "aws_security_group_rule" "egress_with_source_security_group_id" {
  for_each = length(aws_security_group.this[*]) > 0 ? local.sg-egress_rules_with_sg : {}

  security_group_id = aws_security_group.this[0].id
  type              = "egress"

  from_port                = lookup(each.value, "from_port")
  to_port                  = lookup(each.value, "to_port")
  protocol                 = lookup(each.value, "protocol")
  source_security_group_id = lookup(each.value, "source_security_group_id")
  description              = lookup(each.value, "description")
}

resource "aws_security_group_rule" "egress_with_self" {
  for_each = length(aws_security_group.this[*]) > 0 ? local.sg-egress_rules_self : {}

  security_group_id = aws_security_group.this[0].id
  type              = "egress"

  from_port   = lookup(each.value, "from_port")
  to_port     = lookup(each.value, "to_port")
  protocol    = lookup(each.value, "protocol")
  self        = true
  description = lookup(each.value, "description")
}
