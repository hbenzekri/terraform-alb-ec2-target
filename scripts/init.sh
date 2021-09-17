#! /bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo service httpd start  
sudo mkdir /var/www/html/
private_ip=$(hostname -i)
sudo echo "<h1>Welcome to terraform assignment</p> </h1>  <p>Application instance name: ${ec2_name}, address: $${private_ip}</p>" | sudo tee /var/www/html/index.html
sudo service httpd restart  
