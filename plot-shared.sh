#!/bin/bash

# Syntax: plot-shared.sh <folder1> ... <folderN>

home=$(dirname $0)

pauses_output="'pauses.png'"
pauses_title="'Pause times (ms)'"
for input_dir in "$@"
do
    if [ -z "$pauses_file" ]
    then
        pauses_file="'$input_dir/timepauses.log' title '$input_dir' with linespoints"
    else
        pauses_file="$pauses_file, '$input_dir/timepauses.log' title '$input_dir' with linespoints"
    fi
done

pauses_gplot="\n\
set terminal pngcairo enhanced color solid font 'Verdana,11' size 1000,300\n\
set title $pauses_title\n\
set output $pauses_output\n\
\n\
plot $pauses_file"

echo -en $pauses_gplot | gnuplot

copies_output="'copies.png'"
copies_title="'Copy times (ms)'"
for input_dir in "$@"
do
    if [ -z "$copies_file" ]
    then
        copies_file="'$input_dir/timecopy.log' title '$input_dir' with linespoints"
    else
        copies_file="$copies_file, '$input_dir/timecopy.log' title '$input_dir' with linespoints"
    fi
done

copies_gplot="\n\
set terminal pngcairo enhanced color solid font 'Verdana,11' size 1000,300\n\
set title $copies_title\n\
set output $copies_output\n\
\n\
plot $copies_file"

echo -en $copies_gplot | gnuplot

rs_output="'rs.png'"
rs_title="'RS times (ms)'"
for input_dir in "$@"
do
    if [ -z "$rs_file" ]
    then
        rs_file="'$input_dir/timers.log' title '$input_dir' with linespoints"
    else
        rs_file="$rs_file, '$input_dir/timers.log' title '$input_dir' with linespoints"
    fi
done

rs_gplot="\n\
set terminal pngcairo enhanced color solid font 'Verdana,11' size 1000,300\n\
set title $rs_title\n\
set output $rs_output\n\
\n\
plot $rs_file"

echo -en $rs_gplot | gnuplot
