#!/usr/bin/bash
	
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
	
	until false; do echo "czekam 1s" && sleep 1; done
