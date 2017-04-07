#!/bin/bash

# TODO - test if args == 0

output_dir=$1
copy=$output_dir/totalcopy.log
pauses=$output_dir/totalpauses.log
rs=$output_dir/totalrs.log

# Create temporary files
tmp_copy="$(mktemp)"
tmp_pauses="$(mktemp)"
tmp_rs="$(mktemp)"

# Add time collumn to copy, pauses, rs files.
paste -d' ' $output_dir/totaltimes.log $copy > $tmp_copy
paste -d' ' $output_dir/totaltimes.log $pauses > $tmp_pauses
paste -d' ' $output_dir/totaltimes.log $rs > $tmp_rs

gnuplot -e "copy='${tmp_copy}'; pauses='${tmp_pauses}'; rs='${tmp_rs}'; outputname='${output_dir}/gc-plot.png'" collections.gplot
