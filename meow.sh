#/bin/bash

if [[ -z "$(ps -e | grep tor)" ]]
then
    echo 'TOR not running, Requires torsocks too'
    exit 0
fi
valid_number="^[0-9]{10}$"
#Might not work outside US?
if [[ ! $1 =~ $valid_number ]]
then
    echo Invalid phone number
    exit 0
else
    while read fact
    do
        echo -e "sending fact: '$fact' to $1"
        torsocks curl -X POST http://textbelt.com/text -d number=$1 -d "message=$fact"
        pidof tor | xargs sudo kill -HUP
        sleep $(( ( RANDOM % 500 )  + 100 ))
    done <<< "$(shuf catfacts.txt)"
fi
