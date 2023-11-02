#!/bin/bash
cat <<EOF > /etc/yum.repos.d/mongodb-org-7.0.repo 
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
EOF
sudo yum update -y
sudo yum install -y mongodb-org-${var.mongodb_version} mongodb-org-database-${var.mongodb_version} mongodb-org-server-${var.mongodb_version}

# Start MongoDB and enable it on system startup
sudo systemctl start mongod
sudo systemctl enable mongod