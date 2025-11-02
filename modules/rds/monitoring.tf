

# Parameter group for better configuration
resource "aws_db_parameter_group" "this" {
  count  = var.create_parameter_group ? 1 : 0
  family = var.parameter_group_family
  name   = "${var.project}-rds-params"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.project}-rds-params"
  })
}