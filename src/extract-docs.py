#!/usr/local/bin/python

import json
import os
import sys

project_id, in_dir, out_dir = sys.argv[1:4]
json_filename = os.path.join(in_dir, project_id + ".json")

with open(json_filename) as f_json:
	response = json.load(f_json)
	for doc_id in response['documents']:
		if doc_id == 'facets': # why does it return output like this, sigh
			continue
		doc = response['documents'][doc_id]
		entity_id = doc['entityids']['entityid']
		try:
			txturl = doc['txturl']
	
			with open(os.path.join(out_dir, project_id, "{}.json".format(entity_id)), "w") as f_entity_json:
				json.dump(doc, f_entity_json)
	
			with open(os.path.join(out_dir, project_id, "{}.url".format(entity_id)), "w") as f_url :
				f_url.write(txturl + "\n")
		except KeyError:
			print "Document with had no txturl:", entity_id