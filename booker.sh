#!/bin/bash

# Requiere de pdftk y djvu2pdf

book=$1
numofpages=$(pdftk "$book" dump_data | grep NumberOfPages | cut -d ' ' -f 2)
numofminibooks=$(($numofpages / 20))
reminderofminibooks=$(($numofpages % 20))
mitofreminder=$reminderofminibooks/2
isremindereven=$reminderofminibooks%2

echo $numofpages
echo $reminderofminibooks

for((i = 0 ; i < $numofminibooks ; i++)); do
	if [[ i -eq 0 ]]; then
		pdftk "$book" cat $((i*20+1)) $((i*20+20)) $((i*20+2)) $((i*20+19)) $((i*20+3)) $((i*20+18)) $((i*20+4)) $((i*20+17)) $((i*20+5)) $((i*20+16)) $((i*20+6)) $((i*20+15)) $((i*20+7)) $((i*20+14)) $((i*20+8)) $((i*20+13)) $((i*20+9)) $((i*20+12)) $((i*20+10)) $((i*20+11)) output /tmp/set.pdf
	else 
		pdftk "$book" cat $((i*20+1)) $((i*20+20)) $((i*20+2)) $((i*20+19)) $((i*20+3)) $((i*20+18)) $((i*20+4)) $((i*20+17)) $((i*20+5)) $((i*20+16)) $((i*20+6)) $((i*20+15)) $((i*20+7)) $((i*20+14)) $((i*20+8)) $((i*20+13)) $((i*20+9)) $((i*20+12)) $((i*20+10)) $((i*20+11)) output /tmp/reset.pdf
		pdftk /tmp/set.pdf /tmp/reset.pdf cat output /tmp/set1.pdf
		rm /tmp/set.pdf
		mv /tmp/set1.pdf /tmp/set.pdf
	fi
done

for((i = $(($numofpages-$reminderofminibooks)); i < $numofpages; i++)); do
	pdftk "$book" cat $i output /tmp/$(($i-$numofpages+$reminderofminibooks)).pdf
done

echo "test"
for((i = 0; i < $mitofreminder; i++)); do
	echo $i
	pdftk /tmp/$i.pdf /tmp/$((2*$mitofreminder-1-$i)).pdf cat output /tmp/sal$(($i)).pdf
done

echo "here"
pdftk /tmp/sal0.pdf /tmp/sal1.pdf cat output /tmp/set2.pdf
for((i = 2; i < $mitofreminder; i++)); do
	pdftk /tmp/set$((i)).pdf /tmp/sal$((i)).pdf cat output /tmp/set$((i+1)).pdf
done


if [[ -e /tmp/set.pdf ]]; then
	pdftk /tmp/set.pdf /tmp/set$(($mitofreminder)).pdf cat output /tmp/done.pdf
else
	mv /tmp/set$(($mitofreminder-1)).pdf /tmp/done.pdf
fi

