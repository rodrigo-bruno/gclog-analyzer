#!/bin/bash

# Syntax: run.sh <gc log name> <folder1> ...<folderN>

home=$(dirname $0)
gc_log="$1"
shift

for input_dir in "$@"
do
    echo "Processing $input_dir..."
    echo "Stats for $input_dir" > $input_dir/stats
    $home/process.sh $input_dir/$gc_log >> $input_dir/stats
    $home/plot.sh $input_dir
    echo "Processing $input_dir... Done"
done
$home/plot-shared.sh "$@"
$home/genhtml.sh "$@"

exit $?
