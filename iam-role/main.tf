resource "aws_iam_role" "this" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = var.trusted_services }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    ManagedBy   = "TerraBoard"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.managed_policies)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}
