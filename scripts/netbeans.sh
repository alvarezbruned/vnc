#!/bin/bash
apt-get update && apt-get upgrade -y && apt-get install -y wget
apt-get install software-properties-common -y
apt-get install -y openjdk-7-jre openjdk-7-jdk
add-apt-repository -y ppa:vajdics/netbeans-installer
apt-get update
apt-get install unzip -y
apt-get install netbeans-installer -y
mkdir /root/.netbeans /root/.netbeans/8.1 /root/.netbeans/8.1/var
touch /root/.netbeans/8.1/var/license_accepted
/opt/netbeans/bin/netbeans
