# catfacts-textbelt
Send unlimited catfacts to your "friends" using TOR and textbelt

usage:
```
./meow.sh 1234567890
```
or
```
./meow.sh 1234567890,1234567890,1234567890
```
or 

Collect a list of phone numbers in numbers.txt and run ./meow.sh without input

Do not include a 1 country code at the beggining of numbers
Do include the 0 at the beginning of international numbers

Collecting numbers from twitter:
Fill in the config.ini file with your Twitter API credentials
```
python stream.py
```
Numbers will be saved to numbers.txt
