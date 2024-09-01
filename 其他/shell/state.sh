#!/bin/bash

check_state() {
    PID=$(ps -ef | grep geth | grep -v grep | awk '{print $2}')
    echo $PID
    
    if [ ! -n "$PID" ];then
      echo "geth is no running"
    else
      echo "geth is running"
    fi
}

check_state
