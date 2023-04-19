provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAWYYXEWHSWUPVABME"
  secret_key = "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"
}

resource "aws_instance" "Medicure-Deploy" {
  ami           = "ami-07d3a50bd29811cd1" 
  instance_type = "t2.medium" 
  key_name = "Kushal"
  vpc_security_group_ids= ["sg-0906b8b9eb805dc82"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
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
   provisioner "remote-exec" {
    inline = [
             "sudo yum update -y",
             "sudo yum install docker -y",
             "sudo systemctl start docker",
             "sudo wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
             "sudo chmod +x /home/ec2-user/minikube-linux-amd64",
             "sudo cp minikube-linux-amd64 /usr/local/bin/minikube",
             "curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl",
             "sudo chmod +x /home/ec2-user/kubectl",
             "sudo cp kubectl /usr/local/bin/kubectl",
             "sudo groupadd docker",
             "sudo usermod -aG docker ec2-user",
             "sudo minikube start --force",
             #"sudo kubectl apply -f /var/lib/jenkins/workspace/Medicure/deployment.yml",
             #"sudo kubectl apply -f /var/lib/jenkins/workspace/Medicure/svc.yml",
             "sudo kubectl create deployment medicure --image=minimalkushal/medicure",
             "sudo kubectl expose deployment medicure --type=NodePort --port=8082 --name=medicure-svc",
             "sudo kubectl port-forward service/medicure-svc 8082:8082",
             #"sudo kubectl get svc",
    ]
  }
  #provisioner "local-exec" {
   #    command = "ansible-playbook /var/lib/jenkins/workspace/Medicure/Playbook.yml "
      #command = "sudo kubectl apply -f /var/lib/jenkins/workspace/Medicure/deployment.yml"
   #} 
}
