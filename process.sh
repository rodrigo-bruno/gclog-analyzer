#!/bin/bash

# TODO - test if args == 0

log=$1
output_dir=$(dirname $log)
LOCALE=C
export LC_ALL=$LOCALE;

# helper function for arithmetics
f2i() { read data; printf "%.0f" $data; }

echo "Using log $log"
# Extract collection stats
cat $log | awk '/GC pause/ {print $(NF-1)}' | sed 's/,/./g' | awk '{ print $1 * 1000; }' > $output_dir/totalpauses.log
cat $log | awk '/Object Copy/ {print $(NF)}' | sed 's/]//' > $output_dir/totalcopy.log
cat $log | awk '/Scan RS/ {print $(NF)}' | sed 's/]//' > $output_dir/totalrs.log
cat $log | awk '/GC pause/ {print $2}' | sed 's/://' > $output_dir/totaltimes.log
cat $log | grep -v "Metaspace" | awk '/Heap:/ {print $6}' | sed 's/[\(\)\>]/ /g' | awk '{print $4}' > $output_dir/totalheap.log

# Total pause time and total copy time
cat $output_dir/totalpauses.log | awk '\
	{ counter+=1; sum+=$1} END \
	{ print "Number of pauses: " counter "\n" "Sum of pauses (ms): " sum }'
cat $output_dir/totalcopy.log | awk '\
	{ sum+=$1} END \
	{ print "Sum of copies (ms): " sum }'

echo ""

# Distribution of pausetimes and copytimes
echo "Pause time distribution (ms)"
for pause in 0 25 50 100 250 500 750 1000
do
	echo -ne ">$pause\t"
done
echo ""

for pause in 0 25 50 100 250 500 750 1000
do
	cat $output_dir/totalpauses.log | awk -v pause=$pause '\
		BEGIN { sum=0} \
		{ if ($1 > pause) sum+=1;} \
		 END { printf "%d\t", sum }'
done
echo -e "\n"

echo "Copy time distribution (ms)"
for pause in 0 25 50 100 250 500 750 1000
do
	echo -ne ">$pause\t"
done
echo ""

for pause in 0 25 50 100 250 500 750 1000
do
	cat $output_dir/totalcopy.log | awk -v pause=$pause '\
		BEGIN { sum=0} \
		{ if ($1 > pause) sum+=1;} \
		 END { printf "%d\t", sum }'
done

# Percentiles for pausetimes and copytimes
for file in totalpauses.log totalcopy.log
do
	echo -e "\n\nPercentiles for $file"
	for percentile in 50 75 90 95 99 "99.9" "99.99" "99.999" 100
	do
		echo -ne "$percentile\t"
	done

	echo ""

	for percentile in 50 75 90 95 99 "99.9" "99.99" "99.999" 100
	do
		tmp="$(mktemp)"
		total=$(cat $output_dir/$file | sort -n | tee "$tmp" | wc -l)
		# Note 1: we use percentile * 1000 because bash arithmetics do not support floats
                count=`echo "(($total * $percentile) / 100)" | { cat; echo;} | bc -l | f2i`
		res="$(head -n $count "$tmp" | tail -n 1)"
	        echo -ne "$res\t"
	done
done
echo ""
