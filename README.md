# gclog-analyzer
Set of scripts to analyze gc logs (and construct plots!)

It supports OpenJDK's G1 GC.

Syntax: run.sh \<gc log name\> \<run1Folder\> ...\<runNFolder\>
Output: html file with pause time plosts (percentiles) and tables comparing pauses from each run.

Requirements: typical linux terminal programs (bash, grep, echo, cat, awk, sed, etc), gnuplot
