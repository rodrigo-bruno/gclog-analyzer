#!/bin/bash

# Syntax: plot.sh <folder>

home=$(dirname $0)
output_dir=$1
copy=$output_dir/totalcopy.log
pauses=$output_dir/totalpauses.log
rs=$output_dir/totalrs.log

# Create temporary files
timecopy=$output_dir/timecopy.log
timepauses=$output_dir/timepauses.log
timers=$output_dir/timers.log

# Add time collumn to copy, pauses, rs files.
paste -d' ' $output_dir/totaltimes.log $copy > $timecopy
paste -d' ' $output_dir/totaltimes.log $pauses > $timepauses
paste -d' ' $output_dir/totaltimes.log $rs > $timers

gnuplot -e "copy='${timecopy}'; pauses='${timepauses}'; rs='${timers}'; outputname='${output_dir}/gc-plot.png'" $home/collections.gplot
