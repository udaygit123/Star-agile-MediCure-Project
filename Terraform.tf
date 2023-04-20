provider "aws" {
  region = "us-east-1"
  access_key = "AKIAWYYXEWHSWUPVABME"
  secret_key = "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"
}

resource "aws_instance" "Medicure-Deploy" {
  ami           = "ami-007855ac798b5175e" 
  instance_type = "t2.medium" 
  key_name = "Kushal-US-East-1"
  vpc_security_group_ids= ["sg-0b23fc55ea213e3a1"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("Kushal-US-East-1.pem")
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
   provisioner "remote-exec" {
    inline = [
              "sudo apt update -y",
              "sudo apt install docker.io -y",
              "sudo snap install microk8s --classic",
              "sudo sleep 30",
              #"sudo usermod -aG microk8s $USER",
             #"sudo chown -f -R $USER ~/.kube",
             # "sudo microk8s status --wait-ready",
             # "sudo microk8s enable dns ingress",
              "sudo microk8s status",
              "sudo microk8s kubectl create deployment medicure-deploy --image=minimalkushal/medicure",
              "sudo microk8s kubectl expose deployment medicure-deploy --port=8082 --type=NodePort",
              "sudo microk8s kubectl get svc",
              "sudo echo Public IP Address of the Instance",
              "sudo curl http://checkip.amazonaws.com",
    ]
  }
}

