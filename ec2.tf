#Final task 
#create ec2 instance

data "aws_ami" "ubuntu" {
  # most_recent = true
  name_regex = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240927"
  owners     = ["099720109477"]

  # filter {
  #   name = "Name"
  #   values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240927"]
  # }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "NameofImage" {
  value = data.aws_ami.ubuntu.name
}

resource "aws_instance" "vm1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.mk-kp.key_name
  vpc_security_group_ids = [aws_security_group.mk-sg1.id]
  subnet_id              = aws_subnet.mksn1.id
  tags = {
    "Name" = "Natwest-Vm-MK-Trainer"
  }
  associate_public_ip_address = true

  provisioner "file" {
    source      = "docker.sh"
    destination = "/home/ubuntu/docker.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/ubuntu/php",
      "sudo mkdir -p /home/ubuntu/project",
      "sudo chmod -R 777 /home/ubuntu/php",
      "sudo chmod -R 777 /home/ubuntu/project"
    ]
  }

  provisioner "file" {
    source      = "dockerfiles/"
    destination = "/home/ubuntu/project"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod a+x /home/ubuntu/docker.sh",
      "sudo bash /home/ubuntu/docker.sh",
      "sudo cp /home/ubuntu/project/index.php /home/ubuntu/php/index.php",
      "sudo docker-compose -f /home/ubuntu/project/docker-compose.yaml up -d"
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    #private_key = file(pathexpand("~/.ssh/id_rsa"))
    private_key = var.private_key
    timeout     = "3m"
  }
}
output "PublicIpAddress" {
  value = aws_instance.vm1.public_ip
}

resource "aws_s3_bucket" "mkb1" {
  bucket = "natwest-mk29v1b1-02102024"
}