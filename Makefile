.PHONY: default
default: local

.PHONY: local
local: introspect config compose install run

.PHONY: managed
managed: introspect publish install run-managed

.PHONY: introspect
introspect:
	.scripts/introspect.sh

.PHONY: config
config:
	.scripts/config.sh > supergraph.yaml

.PHONY: compose
compose:
	rover supergraph compose --config ./supergraph.yaml > supergraph.graphql

.PHONY: install
install:
	npm install

.PHONY: run
run:
	node index.js local

.PHONY: query
query:
	.scripts/query.sh

.PHONY: publish
publish:
	.scripts/publish.sh

.PHONY: run-managed
run-managed:
	.scripts/run-managed.sh

.PHONY: check-products
check-products:
	.scripts/check-products.sh
