.PHONY: default
default: introspect config compose install run

.PHONY: introspect
introspect:
	.scripts/introspect.sh

.PHONY: config
config:
	.scripts/config.sh > supergraph.yaml

.PHONY: compose
compose:
	rover supergraph compose --config ./supergraph.yaml > supergraph.graphql

.PHONY: publish
publish:
	.scripts/publish.sh

.PHONY: install
install:
	npm install

.PHONY: run
run:
	node index.js

.PHONY: query
query:
	.scripts/query.sh