#!/bin/bash

#set -x

# check args count
if test $# -lt 2; then
    echo -e "\nUsage: $0 < username > < password >\n"
    exit 1
fi

# check hosts file
hosts_file=/etc/ansible/hosts
if ! test -e $hosts_file; then
    echo "[ERROR]: Can't find hosts file"
    exit 1
fi

username=$1
password=$2
target_host=${3-all}


# check sshkey file 
sshkey_file=~/.ssh/id_rsa.pub
if ! test -e $sshkey_file; then
    ssh-keygen -t rsa
fi

# get hosts list
hosts=$(ansible -i $hosts_file ${target_host} --list-hosts | awk 'NR>1')
echo "======================================================================="
echo "hosts: "
echo "$hosts"
echo "======================================================================="

ssh_key_copy()
{
    # delete history
    sed "/$1/d" -i ~/.ssh/known_hosts

    # start copy 
    sshpass -p $password ssh-copy-id -o StrictHostKeyChecking=no $username@$1
}

# auto sshkey pair
for host in $hosts; do
    echo "======================================================================="

    # check network
    ping -i 0.2 -c 3 -W 1 $host >& /dev/null
    if test $? -ne 0; then
        echo "[ERROR]: Can't connect $host"
        exit 1
    fi

    cat /etc/hosts | grep -v '^#' | grep $host >& /dev/null
    if test $? -eq 0; then
        hostaddr=$(cat /etc/hosts | grep -v '^#' | grep $host | awk '{print $1}')
        hostname=$(cat /etc/hosts | grep -v '^#' | grep $host | awk '{print $2}')
        
        ssh_key_copy $hostaddr
        ssh_key_copy $hostname
    else
        ssh_key_copy $host
    fi

    echo ""
done