#! /bin/bash
  sudo amazon-linux-extras install -y nginx1
  sudo service nginx start
  aws s3 cp s3://${s3_bucket_id}/website/index1.html /home/ec2-user/index.html
  aws s3 cp s3://${s3_bucket_id}/website/image1.png /home/ec2-user/image.png
  sudo rm /usr/share/nginx/html/index.html
  sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
  sudo cp /home/ec2-user/image.png /usr/share/nginx/html/image.png