#!/bin/bash
cd /home/ubuntu/GitOps-HelmCharts/
git pull
aws s3 cp s3://gitcommittagbucket/old_value.txt .
aws s3 cp s3://gitcommittagbucket/new_value.txt .
old_value=$(cat old_value.txt)
new_value=$(cat new_value.txt)
sed -i "s/${old_value}/${new_value}/g" values.yaml
git add .
git commit -m "${new_value} is updated"
git push https://$GIT_TOKEN@github.com/sagarkakkalasworld/GitOps-HelmCharts
#git token must be update in server using following commands
#echo 'export GIT_TOKEN=Your_generated_token' >> ~/.bashrc
#source ~/.bashrc
aws s3 rm s3://gitcommittagbucket/old_value.txt
echo $new_value > old_value.txt
aws s3 cp old_value.txt s3://gitcommittagbucket/
rm old_value.txt new_value.txt