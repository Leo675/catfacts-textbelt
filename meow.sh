#/bin/bash

if [[ -z "$(ps -e | grep tor)" ]]
then
    echo 'TOR not running, Requires torsocks too'
    exit 0
fi

#checks if numbers were given with stdin
if [[ -z "$1" ]]
then
    number_list="$(tac numbers.txt | sed -r 's/^1//g')"
else
    number_list="$(echo $1 | sed 's/,/\n/g')"
    sdtin_numbers=1
fi

valid_number="^[0-9]{10,13}$"
international_number="^0"
canadian_number='^(204|226|236|249|250|289|306|343|365|403|416|418|431|437|438|450|506|514|519|579|581|587|604|613|639|647|705|709|778|780|807|819|867|873|902|905)'

unsubscribe_message=' To unsubscribe, tweet "Meow, I did not mean to tweet my phone number" to @IDSninja'

#increment to count messages
i=0

while read fact
do
    while read number
    do
        #does a regex check for number of digits. Will skip anything not 10-13 numbers
        if [[ ! $number =~ $valid_number ]]
        then
            echo Invalid phone number $number
            continue
        #checks if number starts with 0 to use international bridge
        elif [[ $number =~ $international_number ]]
        then
            post_url=http://textbelt.com/intl
        #checks if number is a Canadian area code to use the Canadian bridge
        elif [[ $number =~ canadian_number ]]
        then
            post_url=http://textbelt.com/canada
        #otherwise, send to U.S. bridge
        else
            post_url=http://textbelt.com/text
        fi
        
        #sends fact via curl POST
        echo -e "sending fact: '$fact$unsubscribe_message' to $number using $post_url"
        torsocks curl -X POST $post_url -d number=$number -d "message=$fact$unsubscribe_message"
        #auto increment
        ((i++))
        
        #gets new TOR IP if 60 messages have been sent this round (docs say limit is 75/day/ip)
        if [[ i -gt 60 ]]
        then
            echo '60 messages sent, getting new tor IP'
            pidof tor | xargs sudo kill -HUP
            i=0
            sleep 30
        fi
        
    done <<< "$number_list"
    #if stdin was used for number list, get a new ip and sleep for a randomish amount of time.
    if [[ sdtin_numbers -eq 1 ]]
    then
        pidof tor | xargs sudo kill -HUP
        i=0
        #sleeps for a randomish amount of time
        sleep $(( ( RANDOM % 500 )  + 100 ))
    fi
#shuffles the cat facts file so the fact order varies
done <<< "$(shuf catfacts.txt)"
