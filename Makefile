.PHONY: default
default: local

.PHONY: local
local: introspect config compose install run

.PHONY: demo
demo: introspect config compose install smoke

.PHONY: managed
managed: introspect publish install run-managed

.PHONY: docker
docker: docker-build docker-run

.PHONY: docker-build
docker-build: introspect config compose
	docker build -t my/supergraph-demo .

.PHONY: docker-run
docker-run:
	docker run --rm -p 4000:4000 my/supergraph-demo

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

.PHONY: smoke
smoke:
	.scripts/smoke.sh

.PHONY: dep-act
dep-act:
	curl https://raw.githubusercontent.com/nektos/act/master/install.sh | bash -s v0.2.21

.PHONY: dep-act act
act:
	act

.PHONY: dep-act act-medium
act-medium:
	act -P ubuntu-18.04=catthehacker/ubuntu:act-18.04

.PHONY: dep-act act-large-gh-parity
act-large-gh-parity:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04

.PHONY: publish
publish:
	.scripts/publish.sh

.PHONY: run-managed
run-managed:
	.scripts/run-managed.sh

.PHONY: check-products
check-products:
	.scripts/check-products.sh
