#!/bin/bash
# renames svg files in subdirectories after their fathers (the subdirectories they are in), then moves then up in the directory tree
for d in $1 ; do
	[ -d "$d" ] || break
	if [ -d $d ]; then
		(cd "$d" && for f in *.svg; do
				[ -f "$f" ] || break
				result=`echo "$f" | cut -d"." -f1 -s`
				cp "$f" $1/"$result-$d.svg"
			    done
		 )
	fi
done