#!/bin/bash
sudo docker rmi -f $(sudo docker images -q) ##this is not recommned step, i am deleting existing images to save space
sudo rm -r gold ## these steps are not recommened instead you can modify script as shown below
sudo mkdir gold
cd gold/
sudo git clone https://github.com/sagarkakkalasworld/Day17.git
cd Day17/Code
##the below lines of script are to store build files in s3 bucket
sudo npm install react-scripts
sudo npm run build
sudo chmod 777 build
current_date=$(date +%d%m%Y)
aws s3api put-object --bucket buildartifactoryreactmicrok8s --key "${current_date}/"
aws s3 cp --recursive build "s3://buildartifactoryreactmicrok8s/${current_date}/$(basename build)"
##the below lines of script are to have docker images with git commit id tags
git_commit=$(sudo git rev-parse HEAD)
sudo docker build -t react-microk8s:$git_commit -f golddockerfile .
sudo docker tag react-microk8s:$git_commit sagarkakkalasworld/react-microk8s:$git_commit
sudo touch image_vulnerability.txt
sudo chmod 777 image_vulnerability.txt
sudo trivy image react-microk8s:$git_commit > image_vulnerability.txt
#echo "Please find the attached Trivy file file." | mutt -s "Image Vulnerability" -a image_vulnerability.txt -- sagar.kakkala@gmail.com
sudo docker push sagarkakkalasworld/react-microk8s:$git_commit
##the below lines of script are to store our git commit id tags in s3 bucket
aws s3 rm s3://gitcommittagbucket/new_value.txt
sudo touch new_value.txt
sudo chmod 777 new_value.txt
sudo echo $git_commit > new_value.txt
aws s3 cp new_value.txt s3://gitcommittagbucket/
sudo rm new_value.txt
