#!/bin/bash

if [ -z "$1" ]
then
    echo "no argument"
    exit 1
fi

if [ ! -f "$1" ]
then
    echo "No such file: " $1
    exit 1
fi

title="$(sed '6q;d' $1)"

filename="$1"
filename=${filename/draft/$(date -I)}

entry='<li>\n'$(date -I)': <a href='"$filename"'>'$title"</a>"'\n</li>'

cur_year="$(date +%Y)"
cur_month="$(date +%m)"
file_year="$(sed '30q;d' index.html)"
file_month="$(sed '36q;d' index.html)"

if [ $cur_year != $file_year ]
then
    sed -i '38a\
<li>\
<p>\n'\
"$cur_year"'\
</p>\
\
<ul>\
<li>\
<p>\n'\
"$cur_month"'\
</p>\
\
<ul>\
</ul>\
</ul>\
</li>\n' index.html
fi

if [ $cur_month != $file_month ]
then
    sed -i '44a\
<li>\
<p>\n'\
"$cur_month"'\
</p>\
\
<ul>\
</ul>\
</li>\n' index.html
fi

sed -i '50a'"$entry" index.html 
mv "$1" "$filename"
git add "$filename"
git commit -am "$title"
echo "$title" "https://ezoeryou.github.io/blog/$filename" | xsel -b
