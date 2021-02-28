#!/usr/bin/bash

# For loop:

	echo "For loop"
	words="A B C D E"
	for word in $words; do
		echo ${word}
	done
	
	: '
	echo "For loop 2"
	for i in 1 2 3 4 5; do echo $i; done
	
	echo "For loop 3"
	for i in {1..5}; do echo $i; done
	
	echo "For loop 4"
	for i in {1..10..2}; do echo $i; done
	
	echo "For loop 5"
	for i in $(seq 1 2 10); do echo $i; done
	
	echo "For loop 6"
	for (( i=1; i<=20; i++ )); do echo $i; done
	'
	
	# Break and continue statement:
		
		echo "Break example"
		# break -> breaks (leaves) loop
		for (( i=0; i<=10; i++ ))
		do
			if [ $i -gt 5 ]
				then
				break
			fi
			echo $i
		done
		 
		 : '
		 * Double parentheses are used for arithmetic operations:
			# $ ((a++))
			# $ ((meaning = 42))
			# $ for ((i=0; i<10; i++))
			# $ echo $((a + b + (14 * c)))
		'

		echo "Continue example"
		# continue -> ignoresloop iteration and start another
		for (( i=0; i<=10; i++ ))
		do
			if [ $i -eq 3 ] || [  $i -eq 7 ]
			then
				continue
			fi
			echo $i
		done
		
		
# While loop:

		count=1
		while [ $count -le 20 ]; do
			echo $count
			((count++))
		done

		# while true; do echo "czekam 1s" && sleep 1; done
		# while :; do echo "czekam 1s" && sleep 1; done
		

# Until loop:

		count=1
		until [ $count -gt 20 ]; do
			echo $count
			((count++))
		done
		
		# until false; do echo "czekam 1s" && sleep 1; done
		
		
# Select loop:

		options="Version Users Groups Exit"
		PS3="Choose option: "
		select option in $options; do
			if [ $option == 'Exit' ]; then
				echo 'Bye!'
				break
			fi
			echo "You choose option: ${option}."
		done
		
		
# While loop on file:
	
	while read line; do
		echo "$line"
	done < <file.txt>
		
	while IFS="" read -r line || [ -n "$line" ]
	do
		printf '%s\n' "$line"
	done < <file.txt>
	
	
	cat peptides.txt | while read line 
	do
	   echo ${line}
	done
	
	cat peptides.txt | while read line; do something_with_$line_here; done
	
	cat peptides.txt | while read line || [[ -n $line ]];
	do
	   echo ${line}
	done
		 