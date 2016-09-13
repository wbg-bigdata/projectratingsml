#!/bin/sh

for f in data/project-api/*.json
do
	python src/extract-docs-meta.py $f data/project-docs/meta
done

find data/project-docs/meta -type f -name '*.url' -exec cat {} + >data/project-docs/meta/urls.txt