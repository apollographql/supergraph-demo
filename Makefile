.PHONY: default
default: local

.PHONY: supergraph
supergraph: introspect config compose

.PHONY: local
local: supergraph install run

.PHONY: demo
demo: docker-up smoke docker-down

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

.PHONY: ci-local
ci-local:
	.scripts/ci-local.sh

.PHONY: docker-up
docker-up: supergraph
	docker compose up -d
	@sleep 2
	@docker logs graph-router

.PHONY: query
query:
	@.scripts/query.sh

.PHONY: smoke
smoke:
	@.scripts/smoke.sh

.PHONY: docker-down
docker-down:
	docker compose down

.PHONY: docker
docker: docker-build docker-run

.PHONY: docker-build
docker-build: supergraph
	docker build -t my/supergraph-demo .

.PHONY: docker-run
docker-run:
	docker run --rm -d --name=gateway -p 4000:4000 my/supergraph-demo
	@sleep 2
	docker logs gateway

.PHONY: docker-stop
docker-stop:
	docker kill gateway

.PHONY: ci-docker
ci-docker:
	.scripts/ci-docker.sh

.PHONY: dep-act
dep-act:
	curl https://raw.githubusercontent.com/nektos/act/master/install.sh | bash -s v0.2.21

.PHONY: act
act:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04

.PHONY: act-main
act-medium:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -W .github/workflows/main.yml

.PHONY: act-docker
act-docker:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -W .github/workflows/docker.yml

.PHONY: publish
publish:
	.scripts/publish.sh

.PHONY: run-managed
run-managed:
	.scripts/run-managed.sh

.PHONY: check-products
check-products:
	.scripts/check-products.sh
