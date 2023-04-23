provider "aws" {
  region = "us-east-1"
  access_key = "AKIAZEM74KA4DWVKAUEI"
  secret_key = "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"
}

resource "aws_instance" "test-server" {
  ami           = "ami-007855ac798b5175e" 
  instance_type = "t2.medium" 
  key_name = "test-serverkey"
  vpc_security_group_ids= ["sg-077ce7b1c53c11b8a"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("test-serverkey.pem")
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
      "sudo wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
      "sudo chmod +x /home/ubuntu/minikube-linux-amd64",
      "sudo cp minikube-linux-amd64 /usr/local/bin/minikube",
      "curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl",
      "sudo chmod +x /home/ubuntu/kubectl",
      "sudo cp kubectl /usr/local/bin/kubectl",
      "sudo usermod -aG docker ubuntu",
      "sudo kubectl create deployment test-server --image=udaydocker123/medicureproject",
      "sudo kubectl expose deployment test-server --port=8089 --type=NodePort",
    ]
  }
}

