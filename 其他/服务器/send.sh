#!/bin/bash

zip_local_file() {
    cd /Users/wuxinyang/Desktop/MyGo/src/github.com
    tar -zcf go-ethereum.tar ./go-ethereum
}

sendToJump() {
    echo 'starting transfer to 1.15.85.191'
    scp ./go-ethereum.tar jump@1.15.85.191:/home/jump
    OUT=$?
    if [ $OUT = 0 ]; then
      echo 'transfer successful to 1.15.85.191'
      touch successful
      scp successful jump@1.15.85.191:/home/jump
    else
      echo 'transfer faild to 1.15.85.191'
    fi
}

sendFile() {
    ssh jump@1.15.85.191
    
    echo 'starting transfer to 54.72.101.87'
    scp -i VERTEX-PRESS-CLIENT.pem ./go-ethereum.tar ubuntu@54.72.101.87:/home/ubuntu
    OUT=$?
    if [ $OUT = 0 ]; then
      echo 'transfer successful to 54.72.101.87'
      touch successful
      scp -i VERTEX-PRESS-CLIENT.pem successful jump@54.72.101.87:/home/jump
    else
      echo 'transfer faild to 54.72.101.87'
    fi
}

unzip_file() {
    ssh -i VERTEX-PRESS-CLIENT.pem ubuntu@54.72.101.87
    
    tar -zxf go-ethereum.tar
}

main() {
  zip_local_file
  sendToJump
  sendFile
  unzip_file
  echo 'finished'
}

main
