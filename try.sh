#!/bin/bash

# Define delay for better readability
delay=5

# Colors for styling
RED='\033[0;31m'
white='\033[0;37m'
blue='\033[1;34m'

echo -e "${white}THREE STEPS:
        */ Gathering subdomains
        **/ Put all subdomains together
        ***/ Resolving all subdomains to IP
        ****/ Organization"

read -p "Enter the Domain: " domain

# Check if the domain exists
if ping -c 1 "ayakalammayhm.$domain" &> /dev/null; then
    echo -e ">>>>>>>>>>>>>>>> ${RED}BAD: Domain exists. Mission canceled."
    while true; do echo -e "\a"; done
    exit 1
else
    echo -e ">>>>>>>>>>>>>>>> ${RED}GOOD: Domain doesn't exist. Continuing with the mission."
    sleep $delay

    mkdir $domain 2> /dev/null

    gathering_subs() {
        echo ""
        echo -e "${blue}GATHER SUBDOMAINS"
        echo "-------------------------------------------"
        subfinder -d $domain -nW > $domain/subfinder.txt
        python /$USER/Mutiple/tools/Sublist3r/sublist3r.py -d $domain -o /$domain/sublist3r.txt
        amass enum -active -d $domain -ipv4 -timeout 10 -o $domain/amass.txt
        cat $domain/amass.txt | awk '{print $1}' > $domain/result_amass.txt
    }

    put_subs_together() {
        echo ""
        echo -e "${blue}Put all subdomains together"
        echo "---------------------------------------------"
        cd $domain || exit
        cat * > result.txt
        cat result.txt | grep $domain | grep -v - | sort | uniq > final.txt
        cat result_amass.txt >> final.txt
        cat final.txt | awk '{print $1}' > final1.txt
        echo "Number of subdomains: $(cat /$USER/$domain/final1.txt | wc -l)" # Count number of subdomains
        cat final1.txt | grep "www" > www_file
    }

    extract_ips() {
        echo ""
        echo -e "${blue}Resolve all subdomains to IP"
        echo ""
        mkdir $domain/IP
        cat $domain/amass.txt | awk '{print $2}' | sed 's/,/\n/g' > $domain/IP/final_IP
        for i in $(cat $domain/final1.txt); do host $i; done > $domain/IP/result_IP
        cat $domain/IP/result_IP | grep $domain | grep "has" | cut -d " " -f 4 | grep -v address | sort
        cat $domain/IP/final_IP | sort | uniq > $domain/IP/final_IP1
    }

    organize() {
        echo -e "${blue}ORGANIZATION"
        mkdir $domain/tools
        mv subfinder.txt censys.txt crt.txt certspotter.txt sublist3r.txt amass.txt tools/
    }

    gathering_subs
    put_subs_together
    extract_ips
    organize
fi
