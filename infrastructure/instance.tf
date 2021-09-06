resource "aws_instance" "server" {
  ami = "ami-042e8287309f5df03"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.server-kp.key_name
  availability_zone = "us-east-1a"
  tags = {
    Name = "minecraft-server"
  }

  security_groups = [aws_security_group.allow_all.name]
  iam_instance_profile = aws_iam_instance_profile.server-profile.id
}

resource "null_resource" "server-init" {
  count = 1
  depends_on = [aws_eip_association.server]
  connection {
    user = "ubuntu"
    host = aws_instance.server.public_ip
    private_key = tls_private_key.server-key.private_key_pem
  }


  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install apt-transport-https ca-certificates curl software-properties-common -y",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable\"",
      "sudo apt update",
      "sudo apt install docker.io docker-compose -y",
      "sudo usermod -aG docker ubuntu",
      "mkdir -p /home/ubuntu/bot"
    ]
  }
}


resource "aws_eip_association" "server" {
  instance_id = aws_instance.server.id
  allocation_id = aws_eip.server.id
}

resource "aws_eip" "server" {
  vpc = true
}


resource "tls_private_key" "server-key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "server-kp" {
  key_name   = "server-kp"
  public_key = tls_private_key.server-key.public_key_openssh
}

data "aws_caller_identity" "current" {
}

resource "aws_iam_user" "server" {
  path = "/"
  name = "server-user"
}

resource "aws_security_group" "allow_all" {
  name        = "server-sec-group"
  description = "Allow all traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_iam_role" "server-role" {
  name = "minecraft_server_ec2"
  path = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
				"sts:AssumeRole"
			],
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "server-profile" {
  name = "server-profile"
  role = aws_iam_role.server-role.name
}

resource "aws_iam_role_policy" "server-policy" {
  name = "server-role"
  role = aws_iam_role.server-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecr:GetRegistryPolicy",
                "ecr:DescribeRegistry",
                "ecr:GetAuthorizationToken",
                "ecr:DeleteRegistryPolicy",
                "ecr:PutRegistryPolicy",
                "ecr:PutReplicationConfiguration",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "ecr:*",
            "Resource": "${aws_instance.server.arn}"
        },
        {
          "Sid": "VisualEditor2",
          "Effect": "Allow",
          "Action": [
              "ec2:*"
          ],
          "Resource": "*"
        }
    ]
}
EOF
}
