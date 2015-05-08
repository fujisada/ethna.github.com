#!/bin/zsh
htmlDir="."
storeDir="markdown"
mkdir $storeDir
#ls *.html | html2markdown markdown/*.md
for f in $htmlDir/*.html
do
	reverse_markdown $f > ./$storeDir/$f
	mv ./$storeDir/$f ./$storeDir/${f/html/md}
done
