data/ieg-ratings.csv:
	curl -o data/ieg-ratings.csv "https://finances.worldbank.org/api/views/rq9d-pctf/rows.csv?accessType"
    
data/project-ids.txt: data/ieg-ratings.csv
	cut -f1 -d, data/ieg-ratings.csv | tail -n +2 > data/project-ids.txt
	
data/project-api: data/project-ids.txt
	mkdir data/project-api
	src/project-api.sh data/project-ids.txt data/project-api

data/docs-api: data/project-ids.txt
	mkdir data/docs-api
	src/docs-api.sh data/project-ids.txt data/docs-api
	
data/txt: data/project-ids.txt data/docs-api
	mkdir data/txt
	src/download-docs.sh data/project-ids.txt data/docs-api data/txt
	
data/projectsdb: data/txt data/project-api
	mkdir data/projectsdb
	mongod --dbpath data/projectsdb &
	until [ -f data/projectsdb/mongod.lock ]; do \
	     sleep 1; \
	done
	src/build-mongo.sh data/project-ids.txt data/project-api data/txt
	kill $!

#data/project-docs/meta: data/project-api
#	mkdir data/project-docs/meta
#	src/extract-docs.sh
	
#data/project-docs/docs: data/project-docs/meta/urls.txt
#	mkdir data/project-docs/docs
#	src/download-docs.sh

# pretty prettyjson='python -m json.tool'