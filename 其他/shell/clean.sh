#!/bin/bash

make_new_geth() {
    cd /home/ubuntu/go-ethereum
    make geth
}

check_state() {
    pid=$(ps -ef | grep geth | grep -v grep | awk '{print $2}')
    if [ ! -n "$pid" ];then
      clean_data
    else
      kill -9 $pid
      clean_data
    fi
}

clean_data() {
    cd /home/ubuntu/Data/data/
    rm -rf /home/ubuntu/Data/data/geth
    echo "Data geth is clearned up"
}

copy_file() {
    cd /home/ubuntu/go-ethereum/build/bin
    cp ./geth /home/ubuntu/Data
    
}

main() {
    check_state
    
    clean_data
    
    make_new_geth
    
    copy_file
    
    echo "geth has been replaced"
}

main
