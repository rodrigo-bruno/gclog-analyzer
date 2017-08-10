#!/bin/bash

if [ "$#" -lt 4 ]; then
    echo "Illegal number of parameters"
    echo "Syntax: run.sh <start time> <end time> <gc log name> <folder1> ...<folderN>"
    exit
fi

home=$(dirname $0)
start=$1
finish=$2
gc_log="$3"
shift
shift
shift

for input_dir in "$@"
do
    echo "Processing $input_dir..."
    echo "Stats for $input_dir" > $input_dir/stats

    # Create a jvm log wich starts at second $start and finished at second $finish.
    tmplog="$input_dir/jvm.log-stripped"
    first_line=$(cat $input_dir/$gc_log | awk -v start=$start '/Total time for which application threads were stopped/{gsub(":","",$2);  if (($2 + 0) > start) {print NR; exit;}}')
    last_line=$(cat $input_dir/$gc_log | awk -v finish=$finish '/Total time for which application threads were stopped/{gsub(":","",$2);  if (($2 + 0) > finish) {print NR; exit;}}')
    echo "First line=$first_line; Last line=$last_line"
    cat $input_dir/$gc_log | awk -v last_line=$last_line 'NR <= (last_line + 0) { print }' | awk -v first_line=$first_line 'NR >= (first_line + 0) { print }' > $tmplog

     echo "TMP file = $tmplog"
    $home/process.sh $tmplog >> $input_dir/stats
#    $home/process.sh $input_dir/$gc_log >> $input_dir/stats
    $home/plot.sh $input_dir
    echo "Processing $input_dir... Done"
done
$home/plot-shared.sh "$@"
$home/genhtml.sh "$@"

exit $?
