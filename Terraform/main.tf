resource "aws_instance" "ec2" {
  count         = var.inst_count
  ami           = "ami-00ca32bbc84273381"
  instance_type = "t2.micro"

tags = {
  Name = "${var.ec2_name[0]}-${count.index}"
}


}
