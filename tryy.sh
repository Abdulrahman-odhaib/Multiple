#!/bin/bash

# Define delay for better readability
delay=5

# Colors for styling
RED='\033[0;31m'
white='\033[0;37m'
blue='\033[1;34m'

echo -e "${white}THREE STEPS:	
	1/ See live domains
	2/ Open live domains in Chromium
	3/ Take screenshots 
"

read -p "Enter the Domain: " domain

mkdir $domain/online
for i in $(cat $domain/finall1.txt); do ping -4 -c 1 $i ; done > $domain/live_host
cat $domain/live_host | grep $domain | cut -d " " -f 2 | grep -v bytes | sort | uniq > $domain/lastlive_host

echo ""
echo "See live domains"
echo "-----------------------------------------------------"
cat $domain/lastlive_host | httprobe > $domain/http_site
cat $domain/http_site | sort | uniq > $domain/finall_site

echo ""
echo "Open live domains in Chromium"
for i in $(cat $domain/finall_site); do chromium $i; done 

echo ""
echo "Take screenshots "
echo "----------------------------------------------------"

cd /$USER/Multiple/tools/EyeWitness/
./EyeWitness.py -f $domain/finall_site -d $domain/screenshots

echo "RECOGNIZE"
cd $domain/online ; mv live_host lastlive_host http_site http_site online/

