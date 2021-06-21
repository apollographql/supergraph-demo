.PHONY: default
default: demo

.PHONY: demo
demo: supergraph docker-up query docker-down

.PHONY: demo-managed
demo-managed: publish docker-up-managed query docker-down

.PHONY: demo-k8s
demo-k8s: k8s-up k8s-smoke k8s-down

.PHONY: docker-up
docker-up:
	docker-compose up -d
	@sleep 2
	@docker logs router

.PHONY: docker-up-managed
docker-up-managed:
	docker-compose -f docker-compose.managed.yml up -d
	@sleep 2
	@docker logs router

.PHONY: query
query:
	@.scripts/query.sh

.PHONY: smoke
smoke:
	@.scripts/smoke.sh

.PHONY: docker-down
docker-down:
	docker-compose down

.PHONY: supergraph
supergraph: config compose

.PHONY: config
config:
	.scripts/config.sh > ./supergraph.yaml

.PHONY: compose
compose:
	rover supergraph compose --config ./supergraph.yaml > ./supergraph.graphql
	cp supergraph.graphql k8s/router/base
	cp supergraph.graphql k8s/router/dev

.PHONY: publish
publish:
	.scripts/publish.sh

.PHONY: unpublish
unpublish:
	.scripts/unpublish.sh

.PHONY: graph-api-env
graph-api-env:
	@.scripts/graph-api-env.sh

.PHONY: check-products
check-products:
	.scripts/check-products.sh

.PHONY: check-all
check-all:
	.scripts/check-all.sh

.PHONY: k8s-up
k8s-up:
	.scripts/k8s-up.sh

.PHONY: k8s-query
k8s-query:
	.scripts/query.sh 80

.PHONY: k8s-smoke
k8s-smoke:
	.scripts/k8s-smoke.sh 80

.PHONY: k8s-nginx-dump
k8s-nginx-dump:
	.scripts/k8s-nginx-dump.sh "k8s-nginx-dump"

.PHONY: k8s-graph-dump
k8s-graph-dump:
	.scripts/k8s-graph-dump.sh "k8s-graph-dump"

.PHONY: k8s-down
k8s-down:
	.scripts/k8s-down.sh

.PHONY: ci-k8s
ci-k8s:
	@.scripts/ci-k8s.sh

.PHONY: dep-act
dep-act:
	curl https://raw.githubusercontent.com/nektos/act/master/install.sh | bash -s v0.2.23

.PHONY: act
act:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -W .github/workflows/main.yml

.PHONY: act-test
act-test:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -W .github/workflows/test.yml

.PHONY: act-rebase
act-rebase:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -W .github/workflows/rebase.yml -s GITHUB_TOKEN --secret-file docker.secrets --detect-event

.PHONY: act-release
act-release:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -P ubuntu-latest=catthehacker/ubuntu:act-latest -W .github/workflows/release.yml --secret-file docker.secrets

.PHONY: act-subgraph-check
act-subgraph-check:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -W .github/workflows/subgraph-check.yml --secret-file graph-api.env --detect-event

.PHONY: docker-build
docker-build: docker-build-router docker-build-products docker-build-inventory docker-build-users

.PHONY: docker-build-router
docker-build-router:
	docker build -t prasek/supergraph-router:latest router/.

.PHONY: docker-build-products
docker-build-products:
	docker build -t prasek/subgraph-products:latest subgraphs/products/.

.PHONY: docker-build-inventory
docker-build-inventory:
	docker build -t prasek/subgraph-inventory:latest subgraphs/inventory/.

.PHONY: docker-build-users
docker-build-users:
	docker build -t prasek/subgraph-users:latest subgraphs/users/.

.PHONY: docker-prune
docker-prune:
	.scripts/docker-prune.sh
