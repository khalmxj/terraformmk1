#task 3:
#  create keys
#------------------------------------
resource "aws_key_pair" "mk-kp" {
  key_name   = "mk-natwest-key-pair-${terraform.workspace}"
  #public_key = file("~/.ssh/id_rsa.pub")
  public_key = var.publick_key
}
#------------------------------------