# iam-role/main.tf — IAM role with trust policy and managed policy attachments

## IAM Role
resource "aws_iam_role" "this" {
  count = module.this.enabled ? 1 : 0
  name  = module.this.id

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

  tags = module.this.tags
}

## IAM Role Policy Attachments
resource "aws_iam_role_policy_attachment" "this" {
  for_each = module.this.enabled ? toset(var.managed_policies) : toset([])

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}
