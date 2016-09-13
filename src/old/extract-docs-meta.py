#!/usr/local/bin/python

import json
import httplib
import os
import sys

json_filename, out_dir = sys.argv[1:3]

with open(json_filename) as f_json:
	response = json.load(f_json)
	for project_id in response['projects']:
		project = response['projects'][project_id]
		try:
			for doc in project['projectdocs']:
				# WORKAROUND API bug, shifted fields, eg. for P000040
				if doc['EntityID'].startswith("http:"):
					doc['DocDate'] = doc['DocURL']
					doc['DocURL'] = doc['EntityID']
					doc['EntityID'] = doc['DocType']
					doc['DocType'] = ""
				# END WORKAROUND
			
				entity_id = doc['EntityID']
				url = doc['DocURL']
			
				#print project_id, ":", entity_id
				with open(os.path.join(out_dir, "{}.json".format(entity_id)), "w") as f_entity_json:
					json.dump(doc, f_entity_json)
			
				with open(os.path.join(out_dir, "{}.url".format(entity_id)), "w") as f_url :
					f_url.write(url + "\n")
		except KeyError:
			print project_id, "had no documents associated."