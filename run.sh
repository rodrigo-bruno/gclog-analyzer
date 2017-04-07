#!/bin/bash

home=$(dirname $0)
gc_log=cassandra-gc.log

for input_dir in "$@"
do
	$home/process.sh $input_dir/$gc_log
	$home/plot.sh $input_dir
done
