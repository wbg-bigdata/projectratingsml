#!/bin/sh

# Call the WBG projects API for each project_id in the first argument; store JSON results in folder of second argument
while IFS='' read -r project_id || [[ -n "$project_id" ]]; do
	if [ ! -f $2/$project_id.json ]
	then
    curl "http://search.worldbank.org/api/v2/projects?format=json&id=$project_id" > $2/$project_id.json
	else
		echo "JSON data already exists for $project_id; make clean then etc TODO to redownload."
	fi
done < "$1"