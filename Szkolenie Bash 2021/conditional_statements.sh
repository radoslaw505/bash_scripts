#!/usr/bin/bash

# If statement:
	
	#1 - tylko jesli warunek zostanie spelniony
	count=10
	if [ $count -eq 10 ]
	then
		echo "PRAWDA"
	fi
		
	#2 - jesli warunek zostanie spelniony - PRAWDA, jesli nie - FAŁSZ
	count=11
	if [ $count -eq 10 ]
	then
		echo "PRAWDA"
	else
		echo "FAŁSZ"
	fi
		
	#3 - inny zapis
	count=10
	if (( $count > 9 ))
	then
		echo "PRAWDA"
	 else
		echo "FAŁSZ"
	fi

	
# If-else if statements:

	#1 - dwa warunki
	count=10
	if (( $count > 9 ))
	then
		echo "Pierwszy warunek został spełniony"
	elif (( $count <= 9 ))
	then
		echo "Drugi warunek został spełniony"
	else
		echo "Warunek jest błędny"
	fi
	
	
# AND operator:

	# Operator AND -> &&

	#1 - [] && []
	wiek=10
	if [ "$wiek" -gt 18 ] && [ "$wiek" -lt 40 ]
	then
		echo "Wiek jest prawidłowy"
	else
		echo "Wiek jest NIEPRAWIDŁOWY"
	fi

	#2 - [[ && ]]
	wiek=30
	if [[ "$wiek" -gt 18 && "$wiek" -lt 40 ]]
	then
		echo "Wiek jest prawidłowy"
	else
		echo "Wiek jest NIEPRAWIDŁOWY"
	fi
	
	#3 - opcja '-a' działa tak samo jak operator &&
	wiek=30
	if [ "$wiek" -gt 18 -a "$wiek" -lt 40 ]
	then
		echo "Wiek jest prawidłowy"
	else
		echo "Wiek jest NIEPRAWIDŁOWY"
	fi

# OR operator:

	# Operator OR -> ||
	
	#1 - [] || []
	wiek=30
	if [ "$wiek" -lt 18 ] || [ "$wiek" -gt 40 ]
	then
		echo "Wiek jest prawidłowy"
	else
		echo "Wiek jest NIEPRAWIDŁOWY"
	fi
	
	#2 - [[ || ]]
	wiek=30
	if [[ "$wiek" -lt 18 || "$wiek" -gt 40 ]]
	then
		echo "Wiek jest prawidłowy"
	else
		echo "Wiek jest NIEPRAWIDŁOWY"
	fi
	
	#3 - opcja '-o' działa tak samo jak operator ||
	wiek=30
	if [ "$wiek" -lt 18 -o "$wiek" -lt 40 ]
	then
		echo "Wiek jest prawidłowy"
	else
		echo "Wiek jest NIEPRAWIDŁOWY"
	fi
	
: '	
SKRÓCONE ZAPISY:
Znając operatory AND i OR istnieje możliwość zapisania warunków w skróconej formie, tzw. w jednej linii:
	- Jeśli warunek zostanie sprałniony to wykonaj komendę po operatorze AND
	- Jeśli warunek nie zostanie spełniony to wykonaj wszystko po operatorze OR
	- Istnieje możliwość łączenia tych operatorów (ale nie przesadzajmy - najlepsze rozwiązanie to rozwiązanie typu if/else)
	
Przykłady:
	#1 Warunek został spełniony i została wykonana komenda następująca po operatorze AND
	$ [ 10 -eq 10 ] && echo "Warunek został spełniony"
		# można to przeczytać jako: jeśli warunek 10 == 10 zostanie spełniony to wykonaj komendę echo
		# w przypadku kiedy warunek nie zostanie spełniony nic się nie wykona, np. $ [ 1 -eq 10 ] && echo "Warunek został spełniony"
		
	#2 Warunek nie został spełniony i została wykonana komenda następująca po operatorze OR
	$ [ 1 -eq 10 ] || echo "Warunek NIE został spełniony"
		# można to przeczytać jako: jeśli warunek 1 == 10 nie zostanie spełniony to wykonaj komendę echo
		# w przypadku kiedy warunek zostanie spełniony nic się nie wykona, np. $ [ 10 -eq 10 ] || echo "Warunek został spełniony"
		
	# Jeśli warunek został spełniony wykonaj komendę następującą po operatorze AND, jeśli nie został wykonaj komendę po operatorze OR
	$ [ 10 -eq 10 ] && echo "Warunek został spełniony" || echo "Warunek NIE został spełniony"
	> Warunek został spełniony
		# Warunek został spełniony, dlatego wykonała się jedynie komenda po operatorze &&, jeśli ona nie została by wykonana, wykonała by się komenda po operatorze ||
	
	$ [ 11 -eq 10 ] && echo "Warunek został spełniony" || echo "Warunek NIE został spełniony"
	> Warunek NIE został spełniony
		# Warunek nie został spełniony przez co nie wykonała się komenda po operatorze &&, a co za tym idzie wykonała się operacja po operatorze ||
'

[ 10 -eq 10 ] && echo "Warunek został spełniony"
[ 1 -eq 10 ] || echo "Warunek NIE został spełniony"
[ 10 -eq 10 ] && echo "Warunek został spełniony" || echo "Warunek NIE został spełniony"
[ 11 -eq 10 ] && echo "Warunek został spełniony" || echo "Warunek NIE został spełniony"


