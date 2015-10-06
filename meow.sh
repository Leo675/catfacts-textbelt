#/bin/bash

if [[ -z "$(ps -e | grep tor)" ]]
then
    echo 'TOR not running, Requires torsocks too'
    exit 0
fi

#Might not work outside US?
valid_number="^[0-9]{10}$"
while read fact
do
    while read number
    do
        if [[ ! $number =~ $valid_number ]]
        then
            echo Invalid phone number $number
            continue
        fi
        echo -e "sending fact: '$fact' to $number"
        torsocks curl -X POST http://textbelt.com/text -d number=$number -d "message=$fact"
    done <<< "$(echo $1 | sed 's/,/\n/g')"
    pidof tor | xargs sudo kill -HUP
    sleep $(( ( RANDOM % 500 )  + 100 ))
done <<< "$(shuf catfacts.txt)"
