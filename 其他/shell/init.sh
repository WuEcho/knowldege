#!/bin/bash
#
#######################################################################
#
# Copyright (C) 2016-2019 PDX Technologies, Inc. All Rights Reserved.
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#######################################################################
#
# PDX Utopia initialization, executed once per each blockchain to join
# or create.
#
#######################################################################

MAINNET_ID="739"

# address selected
MINER_ADDRESS=``

# reward address
REWARD_ADDRESS=""

# chainid to join or create
CHAIN_ID="739"

# create or join
ACTION="join"

# password choosen
PASSWORD=""

# bootnode info
BOOTNODEINFO=""

# first minner address
FIRST_MINNER_ADDRESS=""

# consortium or public
CHAIN_TYPE="public"

# encryption type
ENCRYPTION_TYPE="ECDSA"


UTOPIA_BIN=$(cd $(dirname $0); pwd -P)
UTOPIA_HOME=${UTOPIA_BIN%/bin}

CHAIN_HOME_DIR=""
CHAIN_CONF_DIR=""
CHAIN_TEMP_DIR=""
CHAIN_INFO_FILE=""

# initialize a utopia blockchain
init_utopia() {

    PS3="Please pick an option: "
    select opt in "create a new blockchain" "join an existing blockchain"; do
        case "$REPLY" in
            1 ) ACTION="create"; break;;
            2 ) ACTION="join"; break;;
            *) echo "Invalid option, please retry";;
        esac
    done

    select_chain_id
}

select_chain_type() {

    PS3="Please pick an option: "
    select opt in "public blockchain" "consortium blockchain"; do
        case "$REPLY" in
            1 ) CHAIN_TYPE="public"; break;;
            2 ) CHAIN_TYPE="consortium"; break;;
            *) echo "Invalid option, please retry";;
        esac
    done
}

# choose encryption type
select_encryption_type() {
    PS3="Please pick an option: "  	
    select opt in "encryption with ECDSA" "encryption with SM2"; do
	case "$REPLY" in
          1 ) ENCRYPTION_TYPE="ECDSA"; break;;
          2 ) ENCRYPTION_TYPE="SM2"; break;;
	 *) echo "Invalid option, please retry";;
       esac
    done
}


# choose the chain id to join
select_chain_id() {

    read -p "Enter the blockchain id to $ACTION [739]:"  CHAIN_ID
    CHAIN_ID=${CHAIN_ID:-$MAINNET_ID}
    expr $CHAIN_ID + 0 &>/dev/null
    if  [ $? -eq 0 ];then
        CHAIN_CONSORTIUM_DIR=$UTOPIA_HOME/chain/$CHAIN_ID/data/consortium
        CHAIN_HOME_DIR=$UTOPIA_HOME/chain/$CHAIN_ID
        CHAIN_CONF_DIR=$UTOPIA_HOME/conf/$CHAIN_ID
        CHAIN_TEMP_DIR=$UTOPIA_HOME/temp/$CHAIN_ID
        CHAIN_INFO_FILE=$CHAIN_CONF_DIR/chain-info.properties
        if [ $CHAIN_ID != 739 ] ;then
         select_chain_type
        fi
        init_datapath
    else
        echo "Invalid input, please decide the blockchain id to $ACTION"
        select_chain_id
    fi
}

# create datapath
init_datapath() {
    # remove existing one
    if [ -d "$CHAIN_HOME_DIR" ];then
	rm -rf $CHAIN_HOME_DIR
	rm -rf $CHAIN_CONF_DIR 
	rm -rf $CHAIN_TEMP_DIR 
    fi

    mkdir -p $CHAIN_HOME_DIR/data
    mkdir -p $CHAIN_CONF_DIR
    mkdir -p $CHAIN_TEMP_DIR

    touch $CHAIN_INFO_FILE

    if [ $ACTION = join ] && [ $CHAIN_ID != "739" ];then
        create_connect_bootnode_file
    fi
    
    select_encryption_type

    new_account

    set_reward_address

    touch $CHAIN_TEMP_DIR/log.out

    if [ ! -d $CHAIN_CONSORTIUM_DIR ] ;then
            if [ $CHAIN_ID != "739" ];then
               create_genesis
 	       $UTOPIA_BIN/utopia init $CHAIN_HOME_DIR/genesis.json --datadir $CHAIN_HOME_DIR/data 2>&1 > $CHAIN_TEMP_DIR/log.out
            fi
    else
            create_genesis
            $UTOPIA_BIN/utopia init $CHAIN_HOME_DIR/genesis.json --datadir $CHAIN_HOME_DIR/data 2>&1 > $CHAIN_TEMP_DIR/log.out
    fi
}

# create genesis file
create_genesis() {
    
    read -p "Enter the FirstMinnerAddress :[ default is miner address: $MINER_ADDRESS ]:" FIRST_MINNER_ADDRESS
    FIRST_MINNER_ADDRESS=${FIRST_MINNER_ADDRESS:-$MINER_ADDRESS}
    echo "first_minner_address=$FIRST_MINNER_ADDRESS" >> $CHAIN_INFO_FILE
 
    touch "$CHAIN_HOME_DIR/genesis.json"
    number=0
    while read line
    do
        if  [[ $line =~ "chainId" ]] && [ $number == 0 ] ;then
            line=`echo ${line/$line/\"chainId\":$CHAIN_ID,}`
            number=$((number=number+1))
        fi
        if  [[ $line =~ "hypothecation" ]] && [ $CHAIN_ID == "739" ]; then
            line=`echo ${line/$line/\"hypothecation\":true,}`
        fi
	
        if  [[ $line =~ "sm2Crypto" ]] && [ $ENCRYPTION_TYPE == "SM2" ]; then
	    line=`echo ${line/$line/\"sm2Crypto\":true}`	
        fi

	if  [[ $line =~ "consortium" ]] && [ $CHAIN_TYPE == "consortium" ];then
	    line=`echo ${line/$line/\"consortium\":true,}`	
	fi
        
        if  [[ $line =~ "extraData" ]];then
            line=`echo ${line/$line/\"extraData\":\"0x$FIRST_MINNER_ADDRESS\",}`
        fi
        
    echo  "$line" >> $CHAIN_HOME_DIR/genesis.json
    done  < $UTOPIA_HOME/chain/genesis.template
}

# create static and trust nodes
create_connect_bootnode_file() {
    if [ $ACTION = join ] && [ ! $CHAIN_ID = $MAINNET_ID ];then
       checking_bootnode_info
       echo  "bootnode=$BOOTNODEINFO" > $CHAIN_INFO_FILE
    fi
}

#checking enode info
checking_bootnode_info(){
    read -p "Enter an bootnode info:"  BOOTNODEINFO
    if [ ! -n "$BOOTNODEINFO" ];then
        echo "Please check bootnode info you want connected in the path $CHAIN_CONF_DIR/bootnode.txt"
        checking_bootnode_info
    fi
}

# create account
new_account() {

    SAVEDSTTY=`stty -g`
    stty -echo
    echo "Enter your password:"
    read PASSWORD
    stty $SAVEDSTTY

    if [ $ENCRYPTION_TYPE == "ECDSA" ];then
	$UTOPIA_BIN/utopia account new --datadir "$CHAIN_HOME_DIR/data"
    else
	$UTOPIA_BIN/utopia account newsm2 --datadir "$CHAIN_HOME_DIR/data"
    fi	
    
    touch $CHAIN_HOME_DIR/data/keystore/.password.txt

    echo "$PASSWORD" > $CHAIN_HOME_DIR/data/keystore/.password.txt

    get_account_address
}


# get account address
get_account_address() {

    ADDRESS_LIST=`$UTOPIA_BIN/utopia  account list --datadir "$CHAIN_HOME_DIR/data"`
    if  [ ! -n "$ADDRESS_LIST" ];then
        new_account
    else
        MINER_ADDRESS=`echo $ADDRESS_LIST | cut -d '{' -f 2 | cut -d '}' -f 1`
    fi

    echo "miner_address=0x$MINER_ADDRESS" >> $CHAIN_INFO_FILE
    echo "address=0x$MINER_ADDRESS" >> $CHAIN_INFO_FILE
}

# set reward address
set_reward_address() {

    read -p "Enter the reward address :[ default is miner address: $MINER_ADDRESS ]" REWARD_ADDRESS
    REWARD_ADDRESS=${REWARD_ADDRESS:-"0x$MINER_ADDRESS"}
    echo "reward_address=$REWARD_ADDRESS" >> $CHAIN_INFO_FILE
}

P2P_PORT=30303
JRPC_PORT=8545
WS_PORT=8546
GRPC_PORT=7390

select_chain_ep() {
   
    #TODO automatically choose one available on host

    echo "chainId=$CHAIN_ID" >> $CHAIN_INFO_FILE
    echo "chain_stack=utopia"  >> $CHAIN_INFO_FILE
    echo "chain_type=SERVICE_CHAIN" >> $CHAIN_INFO_FILE
    echo "type=utopia" >> $CHAIN_INFO_FILE
    echo "host=127.0.0.1" >> $CHAIN_INFO_FILE
    echo "p2p_port=$P2P_PORT" >> $CHAIN_INFO_FILE
    echo "jrpc_port=$JRPC_PORT" >> $CHAIN_INFO_FILE
    echo "ws_port=$WS_PORT" >> $CHAIN_INFO_FILE
    echo "grpc_port=$GRPC_PORT" >> $CHAIN_INFO_FILE
    echo "encryption_type=$ENCRYPTION_TYPE" >> $CHAIN_INFO_FILE

}

main() {

    init_utopia

    select_chain_ep

    if  [ "$CHAIN_TYPE" = consortium ];then
        mkdir $CHAIN_HOME_DIR/data/consortium
        touch $CHAIN_HOME_DIR/data/consortium/consortium.conf
    echo "Before start make sure copy cert into $CHAIN_HOME_DIR/data/consortium"
    echo "!!! Consortium blockchain $CHAIN_ID: configure permissions before start !!!"
    else
    echo ""
    echo ""
    echo "!!! Public blockchain $CHAIN_ID: ready to start now !!!"
    fi
}

main
