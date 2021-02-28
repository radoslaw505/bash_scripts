#!/usr/bin/bash

while read line; do
	echo "$line"
done < peptides.txt

: '
while IFS="" read -r line || [ -n "$line" ]
do
	printf '%s\n' "$line"
done < peptides.txt


cat peptides.txt | while read line 
do
   echo ${line}
done


cat peptides.txt | while read line; do echo ${line}; done


cat peptides.txt | while read line || [[ -n $line ]];
do
   echo ${line}
done
'
