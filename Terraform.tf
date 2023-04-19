provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAWYYXEWHSWUPVABME"
  secret_key = "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"
}

resource "aws_instance" "Medicure-Deploy" {
  ami           = "ami-02eb7a4783e7e9317" 
  instance_type = "t2.small" 
  key_name = "Kushal"
  vpc_security_group_ids= ["sg-0906b8b9eb805dc82"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("Kushal.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "Medicure Deploy"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.Medicure-Deploy.public_ip} >> inventory.txt "
  }
   provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/Medicure/Playbook.yml "
  } 
}
