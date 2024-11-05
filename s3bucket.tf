 #created new file s3_bucket to generate excel file upload
resource "aws_s3_bucket" "yakshith" {
    bucket = "yakshith1"

    tags = {
        "Name" ="koushik11"
    }
  
}


resource "aws_s3_bucket_public_access_block" "koushik123" {
    bucket = aws_s3_bucket.yakshith.id
    block_public_acls       = false
    ignore_public_acls      = false
    block_public_policy     = false
    restrict_public_buckets = false

}

resource "aws_s3_bucket_policy" "ajay-policy" {
    bucket = aws_s3_bucket.yakshith.id
    policy = jsonencode({
            Id = "policy1730694967293"
            Version = "2012-10-17"
            Statement = [
            {
            Sid = "Stmt1730694965546"
            Action = "s3:GetObject"
            Effect = "Allow"
            Resource ="${aws_s3_bucket.yakshith.arn}/*"
            principal = "*"

            }
            ]
            })
  
}

resource "aws_s3_object" "veni1" {
    bucket = aws_s3_bucket.yakshith.id
    key    = "Screenshot.png"
    source = "C:\\Users\\LENOVO T460\\Pictures\\Screenshots\\Screenshot.png"
    content_type = "Image/png"
  
}