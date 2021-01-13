#!/usr/bin/env sh

ROOT_DIR="~/"
SSH_FILE="six-cities.pem"

USER="ec2-user"
HOST="ec2-13-59-87-218.us-east-2.compute.amazonaws.com"

SSH_HOST="$USER@$HOST"
SERVER_PATH="$SSH_HOST:$ROOT_DIR"

displayHelpMessage()
{
  echo "--connect - connects to the server by an ssh file";
  echo "--deploys - deploy the current server";
  echo "--down - down all docker containers on the server";
  echo "--publish - creates and publish an image to Docker Hub";
  echo "--update - updates all docker containers";
}

if [ -z $1 ]
then
  displayHelpMessage;
elif [ $1 = "--help" -o $1 = "-h" ]
then
  displayHelpMessage;
elif [ $1 = "--publish" -o $1 = "-p" ]
then
    sudo docker build -t kvezal/cities-server:latest .
    sudo docker push kvezal/cities-server:latest
elif [ $1 = "--deploy" -o $1 = "-dp" ]
then
    scp -i "$SSH_FILE" docker-compose.fake.yaml $SERVER_PATH;
    scp -i $SSH_FILE -r ./environments $SERVER_PATH;
    ssh -i $SSH_FILE $SSH_HOST "\
      sudo amazon-linux-extras install docker;\
      sudo service docker start;\
      sudo usermod -a -G docker ec2-user
      sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose;\
      sudo chmod +x /usr/local/bin/docker-compose;\
      docker-compose -f docker-compose.fake.yaml up -d;\
    ";
elif [ $1 = "--connect" -o $1 = "-c" ]
then
    ssh -i "six-cities.pem" ec2-user@ec2-13-59-87-218.us-east-2.compute.amazonaws.com
elif [ $1 = "--up" -o $1 = "-u" ]
then
    ssh -i $SSH_FILE $SSH_HOST "docker-compose -f docker-compose.fake.yaml up -d";
elif [ $1 = "--down" -o $1 = "-d" ]
then
    ssh -i $SSH_FILE $SSH_HOST "docker-compose -f docker-compose.fake.yaml down";
elif [ $1 = "--update" -o $1 = "-ud" ]
then
    ssh -i $SSH_FILE $SSH_HOST "\
      docker-compose -f docker-compose.fake.yaml down;\
      docker images |grep -v REPOSITORY|awk '{print \$1}'|xargs -L1 docker pull;\
      docker-compose -f docker-compose.fake.yaml up -d;\
    ";
fi