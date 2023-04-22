provider "aws" {
  region = "us-east-1"
  access_key = "AKIAZEM74KA4DWVKAUEI"
  secret_key = "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"
}

resource "aws_instance" "test-server" {
  ami           = "ami-007855ac798b5175e" 
  instance_type = "t2.medium" 
  key_name = "JenkinSerP1key"
  vpc_security_group_ids= ["sg-077ce7b1c53c11b8a"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("JenkinSerP1key.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} >> inventory.txt "
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
              "sudo microk8s kubectl create deployment test-server --image=udaydocker123/medicureproject",
              "sudo microk8s kubectl expose deployment test-server --port=8089 --type=NodePort",
              "sudo microk8s kubectl get svc",
              "sudo echo Public IP Address of the Instance",
              "sudo curl http://checkip.amazonaws.com",
    ]
  }
}

