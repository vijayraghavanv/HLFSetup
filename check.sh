#!/bin/bash
  dpkg-query -l iptables-persistent
  if [ $? -eq 0 ]; then
    echo "#################################################iptables-persistent exists############################################"
  else
    sudo apt-get install iptables-persistent
  fi
  sudo iptables -C INPUT -p tcp --dport 7050 -m state --state NEW -j ACCEPT
  if [ $? -eq 0 ]; then
    echo "Port 7050 is open in iptables"
  else
    sudo iptables -I INPUT -p tcp --dport 7050 -m state --state NEW -j ACCEPT
  fi

  sudo iptables -C INPUT -p tcp --dport 7051 -m state --state NEW -j ACCEPT
  if [ $? -eq 0 ]; then
    echo "Port 7051 is open in iptables"
  else
    sudo iptables - INPUT -p tcp --dport 7051 -m state --state NEW -j ACCEPT
  fi
  sudo iptables -I INPUT -p tcp --dport 7052 -m state --state NEW -j ACCEPT
  if [ $? -eq 0 ]; then
    echo "Port 7052 is open in iptables"
  else
    sudo iptables -C INPUT -p tcp --dport 7052 -m state --state NEW -j ACCEPT
  fi
      sudo iptables -I INPUT -p tcp --dport 7053 -m state --state NEW -j ACCEPT
  if [ $? -eq 0 ]; then
    echo "Port 7053 is open in iptables"
  else
    sudo iptables -C INPUT -p tcp --dport 7053 -m state --state NEW -j ACCEPT
fi
  sudo iptables -I INPUT -p tcp --dport 6060 -m state --state NEW -j ACCEPT
  if [ $? -eq 0 ]; then
    echo "Port 6060 is open in iptables"
  else
    sudo iptables -C INPUT -p tcp --dport 6060 -m state --state NEW -j ACCEPT
  fi
    sudo iptables -I INPUT -p tcp --dport 5984 -m state --state NEW -j ACCEPT
  if [ $? -eq 0 ]; then
    echo "Port 5984 is open in iptables"
  else
    sudo iptables -C INPUT -p tcp --dport 8080 -m state --state NEW -j ACCEPT
  fi
      sudo iptables -I INPUT -p tcp --dport 8080 -m state --state NEW -j ACCEPT
  if [ $? -eq 0 ]; then
    echo "Port 8080 is open in iptables"
  else
    sudo iptables -I INPUT -p tcp --dport 8080 -m state --state NEW -j ACCEPT
  fi
  sudo su -c 'iptables-save > /etc/iptables/rules.v4'