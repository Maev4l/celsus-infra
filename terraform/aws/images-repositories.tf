resource "aws_ecr_repository" "image_resize_repository" {
  name                 = "celsus-image-resize"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}
