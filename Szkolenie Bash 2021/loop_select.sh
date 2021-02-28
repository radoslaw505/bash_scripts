#!/usr/bin/bash

options="Version Users Groups Exit"
PS3="Choose option: "

select option in $options; do
	if [ $option == 'Exit' ]; then
		echo 'Bye!'
		break
	fi
	echo "You choose option: ${option}."
done
