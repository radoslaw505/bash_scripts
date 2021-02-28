#!/usr/bin/bash

# overwrite
echo "666" > sample.log

# append
echo "666" >> sample.log

# clearing file:
:> sample.log

: '
	0 - stdin  -> standard in -> user input
	1 - stdout -> standard out -> command output, default to terminal
	2 - stderr -> standard error -> error, standard error is redirected by default to terminal
	
	Streams can be redirected using 'n>' operator, where 'n' is file descriptor(1,2) number.
	When n is ommited, it defaults to 1.
'

ls -ltrH > sample.log
ls +ltrH 1> sample.log
ls +ltrH 2> sample.log

ls -ltrH 2> log.err 1> sample.log
ls +ltrH 2> log.err 1> sample.log
ls +ltrH 2> /dev/null

ls +ltrH > log.err 2>&1
ls +ltrH &> log.err

echo "456" 2>&1 | tee log.err
echo "456" 2>&1 | tee -a log.err
echo "456" |& tee -a log.err
