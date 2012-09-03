for file in $(ls -1)
	do
	sed -f accenti.sed < $file > _
	mv _ $file
	IFS="
"
	for link in $(grep '<a[^>\n]*href="[^"\n]*"[^>\n]*>.*</a>' $file)
		do
		atitle=`echo $link | grep -o '>[^<]*<' | grep -o '[^<>]*'`
		file2=`echo $link | grep -o 'href="[^"]*"' | grep -o '="[^"]*' | grep -o '[^="]*'`
		htitle=`grep -o '<title>.*</title>' $file2 | grep -o '>[^<]*<' | grep -o '[^<>]*'`
		ttitle=`grep -o '<h1>.*</h1>' $file2 | grep -o '>[^<]*<' | grep -o '[^<>]*'`
		
		if [ $atitle != $htitle -o $htitle != $ttitle ]; then
			echo "Titoli diversi. Inserisci il numero di uno di questi, oppure inserisci un altro titolo."
			echo "1) $atitle"
			echo "2) $ttitle"
			echo "3) $htitle"
			echo "4) (Lascia così)"
			read choice

			if [ $choice = "1" ]; then
				newtitle=$atitle
			elif [ $choice == "2" ]; then
				newtitle=$ttitle;
			elif [ $choice == "3" ]; then
				newtitle=$htitle;
			elif [ $choice == "4" ]; then
				newtitle=""
			else
				newtitle=$choice
			fi

			if [ -n $newtitle ]; then
				sed "s/$atitle/$newtitle/" < $file > _
				mv _ $file
				sed "s/$htitle/$newtitle/s/$ttitle/$newtitle" < $file2 > _
				mv _ $file2
			fi
		fi
		echo "========="
	done
done
