#!/bin/bash
IP=$1
sudo iptables -A INPUT -s $IP -j DROP
sudo iptables -A OUTPUT -s $IP -j DROP
echo "Blocked $1:"
