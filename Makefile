.PHONY: default
default: demo

.PHONY: ci
ci: supergraph docker-build-force docker-up smoke docker-down

.PHONY: ci-router
ci-router: supergraph docker-build-force docker-up-local-router smoke docker-down-router

.PHONY: demo
demo: supergraph docker-up smoke docker-down

.PHONY: demo-managed
demo-managed: publish take-five docker-up-managed smoke docker-down

.PHONY: demo-k8s
demo-k8s: k8s-up k8s-smoke k8s-down

.PHONY: demo-serverless
demo-serverless: supergraph-serverless docker-up-serverless smoke docker-down-serverless

.PHONY: docker-up
docker-up:
	docker-compose up -d
	@sleep 2
	@docker logs apollo-gateway

.PHONY: docker-build
docker-build:
	docker-compose build

.PHONY: docker-build-force
docker-build-force:
	docker-compose build --no-cache --pull --parallel --progress plain

.PHONY: docker-build-router
docker-build-router:
	@docker build -t supergraph-demo_apollo-router router/. --no-cache

.PHONY: docker-build-serverless
docker-build-serverless:
	docker-compose -f docker-compose.serverless.yml build --no-cache

.PHONY: docker-up-managed
docker-up-managed:
	docker-compose -f docker-compose.managed.yml up -d
	@sleep 2
	@docker logs apollo-gateway

.PHONY: demo-local-router
demo-local-router: supergraph docker-up-local-router smoke docker-down-router

.PHONY: docker-up-local-router
docker-up-local-router:
	docker-compose -f docker-compose.router.yml up -d
	@sleep 2
	@docker logs apollo-router

.PHONY: query
query:
	@.scripts/query.sh

.PHONY: smoke
smoke:
	@.scripts/smoke.sh

.PHONY: docker-down
docker-down:
	docker-compose down --remove-orphans

.PHONY: docker-down-router
docker-down-router:
	docker-compose -f docker-compose.router.yml down --remove-orphans

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

.PHONY: docker-up-local-router-otel
docker-up-local-router-otel:
	docker-compose -f docker-compose.router-otel.yml up -d
	@sleep 2
	docker-compose -f docker-compose.router-otel.yml logs


.PHONY: docker-down-otel-collector
docker-down-otel-collector:
	docker-compose -f docker-compose.otel-collector.yml down

.PHONY: supergraph-serverless
supergraph-serverless:
	rover supergraph compose --config serverless/supergraph.yaml > serverless/supergraph.graphql

.PHONY: docker-up-serverless
docker-up-serverless:
	docker-compose -f docker-compose.serverless.yml up -d
	@sleep 6
	docker-compose -f docker-compose.serverless.yml logs

.PHONY: docker-down-serverless
docker-down-serverless:
	docker-compose -f docker-compose.serverless.yml down

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
act: act-ci-local

.PHONY: act-ci-local
act-ci-local:
	act -P $(ubuntu-latest) -W .github/workflows/main.yml --detect-event

.PHONY: act-ci-local-router
act-ci-local-router:
	act -P $(ubuntu-latest) -W .github/workflows/main-router.yml --detect-event

.PHONY: act-ci-local-serverless
act-ci-local-serverless:
	act -P $(ubuntu-latest) -W .github/workflows/main-serverless.yml --detect-event

.PHONY: act-ci-managed
act-ci-managed:
	act -P $(ubuntu-latest) -W .github/workflows/managed.yml --secret-file graph-api.env --detect-event -j ci-docker-managed

.PHONY: act-rebase
act-rebase:
	act -P $(ubuntu-latest) -W .github/workflows/rebase.yml -s GITHUB_TOKEN --secret-file docker.secrets --detect-event

.PHONY: act-release
act-release:
	act -P $(ubuntu-latest) -W .github/workflows/release.yml --secret-file docker.secrets

.PHONY: act-subgraph-check
act-subgraph-check:
	act -P $(ubuntu-latest) -W .github/workflows/subgraph-check.yml --secret-file graph-api.env --detect-event

.PHONY: act-subgraph-deploy-publish
act-subgraph-deploy-publish:
	act -P $(ubuntu-latest) -W .github/workflows/subgraph-deploy-publish.yml --secret-file graph-api.env --detect-event

.PHONY: docker-prune
docker-prune:
	.scripts/docker-prune.sh

.PHONY: take-five
take-five:
	@echo waiting for robots to finish work ...
	@sleep 5

.PHONY: copy-local-otel-tar
copy-local-otel-tar:
	cp ../supergraph-demo-opentelemetry/dist/js/supergraph-demo-opentelemetry-v0.0.0.tgz ./gateway/
	cp ../supergraph-demo-opentelemetry/dist/js/supergraph-demo-opentelemetry-v0.0.0.tgz ./subgraphs/products
	cp ../supergraph-demo-opentelemetry/dist/js/supergraph-demo-opentelemetry-v0.0.0.tgz ./subgraphs/inventory
	cp ../supergraph-demo-opentelemetry/dist/js/supergraph-demo-opentelemetry-v0.0.0.tgz ./subgraphs/users
