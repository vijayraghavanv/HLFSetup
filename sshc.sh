#!/bin/bash
# Add, replace or remove host keys from known_hosts file
# https://blog.sleeplessbeastie.eu/2017/11/13/how-to-manage-known_hosts-file-using-shell-script/

## parameters
# host
param_host=""

# known hosts file location
param_known_hosts="~/.ssh/known_hosts"

# action
param_action=""

# port
param_port="-P 22"

# hash a known host file
param_hash=""

## functions
known_hosts_check() {
  ssh-keygen -F $host -f $known_hosts &>/dev/null 
}

known_hosts_remove() {
  ssh-keygen -R $host -f $known_hosts &>/dev/null
}

known_hosts_add() {
  ssh-keyscan $param_hash $host 2>/dev/null | tee -a $known_hosts &>/dev/null
}

usage(){
  echo "Usage:"
  echo "  $0 -h hostname -p 22 -H -k ~/.ssh/known_hosts [-a|-r|-p]"
  echo ""
  echo "Parameters:"
  echo "  -h hostname    : set SSH hostname (required)"
  echo "  -k known_hosts : set SSH known hosts file location (default is \"~/.ssh/known_hosts\")"
  echo "  -P port        : set SSH port (default is  \"22\")"
  echo "  -H             : hash SSH known hosts file when adding an entry (default is to not hash)"
  echo
  echo "Actions:"
  echo "  -a             : add or replace host entries for the provided hostname"
  echo "  -r             : remove host entries for the provided hostname"
  echo "  -p             : print host entries related to the provided hostname"
  echo ""
}


# parse parameters
while getopts ":h:k:P:Harp" option; do
  case $option in
    "h") 
      param_host="${OPTARG}"
      ;;
    "k") 
      param_known_hosts="${OPTARG}"
      ;;
    "P") 
      param_port=""
      ;;
    "H") 
      param_hash="-H"
      ;;
    "a")
      param_action="add_or_replace"
      ;;
    "r")
      param_action="remove"
      ;;
    "p")
      param_action="print"
      ;;
    \?|:|*)
      usage
      exit
      ;;
  esac
done

# evaluate path for know hosts file
known_hosts="$(eval echo $param_known_hosts)"
if [ ! -f "$known_hosts" ]; then
  echo "Known hosts file (${known_hosts}) does not exists"
  exit 10
fi

# hostname and action is required 
if [ -n "$param_host" ] && [ -n "$param_action" ]; then
  # get addional IP address for given hostname
  additional_addresses=$(dig +short $param_host)
  possible_entries="$param_host $additional_addresses"

  # action: print
  if [ "$param_action" = "print" ]; then
    echo "Possibe entries to search for:"
    for host in $possible_entries; do
      echo " * $host"
    done
    echo
  
    found_in_known_hosts=0
    echo "Entries located in $known_hosts file"
    for host in $possible_entries; do
      known_hosts_check
      if [ "$?" -eq "0" ]; then
        echo " * $host"; 
        found_in_known_hosts=1
      fi
    done
    if [ "$found_in_known_hosts" -eq "0" ]; then echo " * none"; fi
  fi

  # action: remove
  if [ "$param_action" = "remove" ]; then
    counter=0
    for host in $possible_entries; do
      known_hosts_check
      if [ "$?" -eq "0" ]; then
        known_hosts_remove
        counter=$(expr $counter \+ 1)
      fi
    done
    echo "Entries removed: $counter" 
  fi


  counter=0
  if [ "$param_action" = "add_or_replace" ]; then
    for host in $possible_entries; do
      known_hosts_check
      if [ "$?" -eq "0" ]; then
        known_hosts_remove
        known_hosts_add
      else
        known_hosts_add
      fi
      counter=$(expr $counter \+ 1)
    done
    echo "Entries processed: $counter" 
  fi
else
  usage
fi