#!/usr/bin/bash

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
