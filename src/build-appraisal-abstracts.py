#!/usr/local/bin/python

import json
import os
import sys

in_dir, out_json_filename = sys.argv[1:3]

abstracts = {}
for subdir, _, files in os.walk(in_dir):
	project_id = os.path.split(subdir)[1]
	print project_id
	for filename in files:
		if filename.endswith(".json"):
			with open(os.path.join(subdir, filename)) as f_doc:
				doc = json.load(f_doc)
				if 'docty' in doc and doc['docty'] == "Staff Appraisal Report":
					if 'abstracts' in doc:
						abstract = doc['abstracts']['cdata!']
						abstracts[project_id] = abstract.decode('string_escape')

with open(out_json_filename, "w") as f_json:
	json.dump(abstracts, f_json)