#!/bin/bash

target=$(dirname $0)/index.html
graphs=""

for graphdir in "$@"
do
    while read ln
    do
      stats="$stats <p>$ln</p>"
    done < $graphdir/stats
    for png in $graphdir/*.png
    do
        graphs="$graphs <h3 style=\"text-align:center;margin:1px 0px;letter-spacing:2px;\">$graphdir</h3>\n$stats\n<img src=\"$(realpath $png)\" style=\"max-width:100%;height:auto\">\n"
    done
done
echo -e "
<!DOCTYPE html>\n
<html>\n
 <head>\n\
  <meta charset=\"utf-8\">\n\
  <meta name=\"viewport\" content=\"width=device-width,
                                    initial-scale=1\">\n\

 </head>\n\
 <body>\n\
  <div>\n\
   <h3 style=\"text-align:center;letter-spacing:2px;\">Generated Plots</h3>\n
   $graphs
  </div>\n\
 </body>\n\
</html>" > $target
