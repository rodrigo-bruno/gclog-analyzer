#!/bin/bash

home=$(dirname $0)
gc_log=cassandra-gc.log

for input_dir in "$@"
do
	echo "Processing $input_dir..."
	echo "Stats for $input_dir" > $input_dir/stats
	$home/process.sh $input_dir/$gc_log >> $input_dir/stats
	$home/plot.sh $input_dir
	echo "Processing $input_dir... Done"
done
$home/genhtml.sh $@
