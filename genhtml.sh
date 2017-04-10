#!/bin/bash

for graphdir in "$@"
do
    stats=""
    while read ln
    do
      stats="$stats\n<p>$ln</p>"
    done < $graphdir/stats

    stats="<div data-role="main" class="ui-content">
	   <div data-role="collapsible">
	     <h1>Stats</h1>$stats</div></div>"

    for png in $graphdir/*.png
    do
	graphs="$graphs
		<div data-role="main" class="ui-content">
		<div data-role="collapsible">
			<h1>$(basename $graphdir)</h1>
			\n$stats\n <img src=\"$(realpath $png)\" style=\"max-width:100%;height:auto\">
		</div></div>"
    done
done

shared="<img src=\"pauses.png\" style=\"max-width:100%;height:auto\">\n"
shared="$shared <img src=\"copies.png\" style=\"max-width:100%;height:auto\">\n"
shared="$shared <img src=\"rs.png\" style=\"max-width:100%;height:auto\">\n"

echo -e "
<!DOCTYPE html>\n
<html>\n
 <head>\n\
  <meta charset=\"utf-8\">\n\
  <meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">\n\
  <link rel=\"stylesheet\" href=\"https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css\">\n\
  <script src=\"https://code.jquery.com/jquery-1.11.3.min.js\"></script>\n\
  <script src=\"https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js\"></script>\n\
 </head>\n\
 <body>\n\
  <div>\n\
   <h3 style=\"text-align:center;letter-spacing:2px;\">Generated Plots</h3>\n
   $shared
   $graphs
  </div>\n\
 </body>\n\
</html>" > index.html
