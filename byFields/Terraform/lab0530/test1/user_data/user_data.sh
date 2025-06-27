#!bin/bash
HOST="www.google.com"
while true; do
    if ping -c 1 $HOST &> /dev/null; then
        echo "Internet is up"
        sudo apt-get update && sudo apt update
        sudo install -y nginx
    else
        echo "Internet is down"
    fi
    sleep 5  # Wait 5 seconds before next check
done


