#!/bin/sh

while IFS='' read -r project_id || [[ -n "$project_id" ]]; do
	if [ ! -d $3/$project_id ]
	then
		echo $project_id
		mkdir $3/$project_id
    python src/extract-docs.py $project_id $2 $3
		for u in $3/$project_id/*.url; do
			entity_id=`basename $u .url`
			echo "\t$entity_id"
			curl -L `cat $u` > $3/$project_id/$entity_id.txt
		done
	else
		echo "txt data already exists for $project_id; make clean then etc TODO to redownload."
	fi
done < "$1"