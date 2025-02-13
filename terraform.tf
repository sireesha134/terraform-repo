# Provider configuration
provider "aws" {
  region = "us-west-2" 
}

# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "sireesha-test" 
  acl    = "private"              

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}
# Create a Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Allow MySQL inbound traffic"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the internet. Restrict to specific IP ranges in production.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an RDS instance
resource "aws_db_instance" "my_db_instance" {
  identifier        = "my-db-instance"
  engine            = "postgress"            # Change to your desired database engine (e.g., mysql, postgres)
  instance_class    = "db.t2.micro"      # Adjust the instance type as needed
  allocated_storage = 20                 # Storage in GB
  db_name           = "mydatabase"       # The initial database name
  username          = "admin"            # The master username for RDS
  password          = "7=FE,Ty%LZz("    # Replace with a secure password
  port              = 5432               # Default MySQL port
  backup_retention_period = 7            # Retain backups for 7 days
  multi_az          = false              # Set to true for high availability (Multi-AZ)
  publicly_accessible = false            # Set to true if you need to access RDS publicly

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "my-db-instance"
  }
}

output "db_instance_endpoint" {
  value = aws_db_instance.my_db_instance.endpoint
}
