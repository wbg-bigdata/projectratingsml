#!/bin/sh

while IFS='' read -r project_id || [[ -n "$project_id" ]]; do
	echo $project_id
	mongoimport --collection projects < $2/$project_id.json
	for j in $3/$project_id/*.json; do
		entity_id=`basename $j .json`
		echo "\t$entity_id"
		mongoimport --collection documents < $j
	done
done < "$1"