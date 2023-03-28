// Test to try and get GameLift working via terraform. Will likely need to be scrapped for time in favor of CloudFormation.
resource "aws_s3_bucket" "game_bucket" {
  bucket = "${var.game_bucket}"
}

resource "aws_s3_object" "game_zip" {
  bucket = aws_s3_bucket.game_bucket.id
  key = "upwardmobility"
  source = "path/to/file"
  etag = filemd5("path/to/file")
}

resource "aws_iam_role" "game_role" {
  name = "test_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_gamelift_build" "build" {
  name             = "upward-mobility"
  operating_system = "WINDOWS_2012"

  storage_location {
    bucket   = aws_s3_bucket.game_bucket.id
    key      = aws_s3_object.game_zip.key
    role_arn = aws_iam_role.game_role.arn
  }
}

resource "aws_gamelift_fleet" "fleet" {
  build_id          = aws_gamelift_build.build.id
  ec2_instance_type = "t2.micro"
  fleet_type        = "ON_DEMAND"
  name              = "upward-mobility-fleet"

  runtime_configuration {
    server_process {
      concurrent_executions = 1
      launch_path           = "C:\\game\\UpwardMobility.exe"
    }
  }
}