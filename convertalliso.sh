for file in *.iso
do
	sh ./isotomkv.sh "$file" >> results.out
done
