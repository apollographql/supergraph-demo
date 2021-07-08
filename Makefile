.PHONY: default
default: demo

.PHONY: ci
ci: supergraph docker-build-force docker-up smoke docker-down

.PHONY: demo
demo: supergraph docker-up query docker-down

.PHONY: demo-managed
demo-managed: ensure-graph-api-env publish-default docker-up-managed query docker-down

.PHONY: demo-k8s
demo-k8s: k8s-up k8s-smoke k8s-down

.PHONY: docker-up
docker-up:
	docker-compose up -d
	@sleep 2
	@docker logs router

.PHONY: docker-build
docker-build:
	docker-compose build

.PHONY: docker-build-force
docker-build-force:
	docker-compose build --no-cache --pull --parallel --progress plain

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
	.scripts/compose.sh

.PHONY: publish
publish:
	.scripts/publish.sh

.PHONY: publish-default
publish-default:
	.scripts/publish.sh default

.PHONY: unpublish
unpublish:
	.scripts/unpublish.sh

.PHONY: graph-api-env
graph-api-env:
	@.scripts/graph-api-env.sh

.PHONY: ensure-graph-api-env
ensure-graph-api-env:
	@.scripts/get-env.sh

.PHONY: check-products
check-products:
	.scripts/check-products.sh

.PHONY: check-all
check-all:
	.scripts/check-all.sh

.PHONY: docker-up-zipkin
docker-up-zipkin:
	docker-compose -f docker-compose.otel-zipkin.yml up -d
	@sleep 2
	docker-compose -f docker-compose.otel-zipkin.yml logs

.PHONY: docker-down-zipkin
docker-down-zipkin:
	docker-compose -f docker-compose.otel-zipkin.yml down

.PHONY: docker-up-otel-collector
docker-up-otel-collector:
	docker-compose -f docker-compose.otel-collector.yml up -d
	@sleep 2
	docker-compose -f docker-compose.otel-collector.yml logs

.PHONY: docker-down-otel-collector
docker-down-otel-collector:
	docker-compose -f docker-compose.otel-collector.yml down

.PHONY: k8s-up
k8s-up:
	.scripts/k8s-up.sh

.PHONY: k8s-up-dev
k8s-up-dev:
	.scripts/k8s-up.sh dev

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

.PHONY: k8s-ci
k8s-ci:
	@.scripts/k8s-ci.sh

.PHONY: k8s-ci-dev
k8s-ci-dev:
	@.scripts/k8s-ci.sh dev

.PHONY: dep-act
dep-act:
	curl https://raw.githubusercontent.com/nektos/act/master/install.sh | bash -s v0.2.23

ubuntu-latest=ubuntu-latest=catthehacker/ubuntu:act-latest

.PHONY: act
act:
	act -P $(ubuntu-latest) -W .github/workflows/main.yml --detect-event

.PHONY: act-rebase
act-rebase:
	act -P $(ubuntu-latest) -W .github/workflows/rebase.yml -s GITHUB_TOKEN --secret-file docker.secrets --detect-event

.PHONY: act-release
act-release:
	act -P $(ubuntu-latest) -P ubuntu-latest=catthehacker/ubuntu:act-latest -W .github/workflows/release.yml --secret-file docker.secrets

.PHONY: act-subgraph-check
act-subgraph-check:
	act -P $(ubuntu-latest) -W .github/workflows/subgraph-check.yml --secret-file graph-api.env --detect-event

.PHONY: act-subgraph-deploy-publish
act-subgraph-deploy-publish:
	act -P $(ubuntu-latest) -W .github/workflows/subgraph-deploy-publish.yml --secret-file graph-api.env --detect-event

.PHONY: act-config-pr
act-config-pr:
	act -P $(ubuntu-latest) -W .github/workflows/config-pr.yml --secret-file docker.secrets --detect-event -s PAT

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
