#!/bin/bash

# Requiere de pdftk y djvu2pdf

book=$1
numofpages=$(pdftk $book dump_data | grep NumberOfPages | cut -d ' ' -f 2)
numofminibooks=$(($numofpages / 20))
reminderofminibooks=$(($numofpages % 20))
mitofreminder=$reminderofminibooks/2
isremindereven=$reminderofminibooks%2

for((i = 0 ; i < $numofminibooks ; i++)); do
	if [[ i -eq 0 ]]; then
		pdftk $book cat $((i*20+1)) $((i*20+20)) $((i*20+2)) $((i*20+19)) $((i*20+3)) $((i*20+18)) $((i*20+4)) $((i*20+17)) $((i*20+5)) $((i*20+16)) $((i*20+5)) $((i*20+15)) $((i*20+6)) $((i*20+14)) $((i*20+7)) $((i*20+13)) $((i*20+8)) $((i*20+12)) $((i*20+9)) $((i*20+11)) output /tmp/set.pdf
	else 
		pdftk $book cat $((i*20+1)) $((i*20+20)) $((i*20+2)) $((i*20+19)) $((i*20+3)) $((i*20+18)) $((i*20+4)) $((i*20+17)) $((i*20+5)) $((i*20+16)) $((i*20+5)) $((i*20+15)) $((i*20+6)) $((i*20+14)) $((i*20+7)) $((i*20+13)) $((i*20+8)) $((i*20+12)) $((i*20+9)) $((i*20+11)) output /tmp/reset.pdf
		pdftk /tmp/set.pdf /tmp/reset.pdf cat output /tmp/set1.pdf
		rm /tmp/set.pdf
		mv /tmp/set1.pdf /tmp/set.pdf
	fi
done

for((i = $(($numofpages-$reminderofminibooks)); i < $numofpages; i++)); do
	pdftk $book cat $i output /tmp/$i.pdf
done
for((i = $(($numofpages-$reminderofminibooks)); i <= $(($numofpages-$reminderofminibooks+$mitofreminder)); i++)); do
	pdftk /tmp/$i.pdf /tmp/$(($numofpages-$reminderofminibooks + $numofpages-$reminderofminibooks+2*$mitofreminder-$i-1)).pdf cat output /tmp/sal$((i)).pdf
done

echo "here"
pdftk /tmp/sal1.pdf /tmp/sal2.pdf cat output /tmp/set2.pdf
for((i = $(($numofpages-$reminderofminibooks+2)); i < $(($numofpages-$reminderofminibooks+$mitofreminder)); i++)); do
	pdftk /tmp/set$((i)).pdf /tmp/sal$((i+1)).pdf cat output /tmp/set$((i+1)).pdf
done


if [[ -e /tmp/set.pdf ]]; then
	pdftk /tmp/set.pdf /tmp/set$(($numofpages-$reminderofminibooks+2*$mitofreminder)).pdf cat output /tmp/done.pdf
else
	mv /tmp/set$(($numofpages-$reminderofminibooks+$mitofreminder-1)).pdf /tmp/done.pdf
fi

