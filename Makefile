.PHONY: default
default: demo

.PHONY: demo
demo: supergraph docker-up query docker-down

.PHONY: demo-managed
demo-managed: introspect publish docker-up-managed query docker-down

.PHONY: demo-k8s
demo-k8s: k8s-up k8s-smoke k8s-down

.PHONY: docker-up
docker-up:
	docker-compose up -d
	@sleep 2
	@docker logs graph-router

.PHONY: query
query:
	@.scripts/query.sh

.PHONY: docker-down
docker-down:
	docker-compose down

.PHONY: supergraph
supergraph: introspect config compose

.PHONY: introspect
introspect:
	.scripts/introspect.sh

.PHONY: config
config:
	.scripts/config.sh > supergraph.yaml

.PHONY: compose
compose:
	rover supergraph compose --config ./supergraph.yaml > supergraph.graphql

.PHONY: graph-api-env
graph-api-env:
	@.scripts/graph-api-env.sh

.PHONY: docker-up-managed
docker-up-managed:
	docker-compose -f docker-compose.managed.yml up -d
	@sleep 2
	@docker logs graph-router

.PHONY: publish
publish:
	.scripts/publish.sh

.PHONY: check-products
check-products:
	.scripts/check-products.sh

.PHONY: check-all
check-all:
	.scripts/check-all.sh

.PHONY: local
local: supergraph install run

.PHONY: managed
managed: introspect publish install run-managed

.PHONY: run
run: export GATEWAY_ENV=Prod
run: export GATEWAY_SUPERGRAPH_SDL=supergraph.graphql
run:
	node index.js

.PHONY: run-managed
run-managed: export GATEWAY_ENV=Prod
run-managed:
	.scripts/run-managed.sh

.PHONY: install
install:
	npm install

.PHONY: docker
docker: docker-build docker-run

.PHONY: docker-build
docker-build: supergraph
	docker build -t my/supergraph-demo .

.PHONY: docker-run
docker-run: export GATEWAY_ENV=Prod
docker-run: export GATEWAY_SUPERGRAPH_SDL=supergraph.graphql
docker-run:
	docker run --rm -d --name=gateway -p 4000:4000 --env GATEWAY_ENV --env GATEWAY_SUPERGRAPH_SDL my/supergraph-demo
	@sleep 2
	docker logs gateway

.PHONY: docker-stop
docker-stop:
	docker kill gateway

.PHONY: k8s-up
k8s-up:
	.scripts/k8s-up.sh

.PHONY: k8s-query
k8s-query:
	.scripts/query.sh 80

.PHONY: k8s-smoke
k8s-smoke:
	.scripts/k8s-smoke.sh 80

.PHONY: k8s-down
k8s-down:
	.scripts/k8s-down.sh

.PHONY: ci-k8s
ci-k8s:
	@.scripts/ci-k8s.sh

.PHONY: ci-local
ci-local:
	.scripts/ci-local.sh

.PHONY: ci-docker
ci-docker:
	.scripts/ci-docker.sh

.PHONY: smoke
smoke:
	@.scripts/smoke.sh

.PHONY: dep-act
dep-act:
	curl https://raw.githubusercontent.com/nektos/act/master/install.sh | bash -s v0.2.21

.PHONY: act
act:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -W .github/workflows/main.yml

.PHONY: act-subgraph-check
act-subgraph-check:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -W .github/workflows/subgraph-check.yml --secret-file graph-api.env --detect-event

.PHONY: act-subgraph-publish
act-subgraph-publish:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -W .github/workflows/subgraph-publish.yml --secret-file graph-api.env

.PHONY: act-supergraph-build-webhook
act-supergraph-build-webhook:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -W .github/workflows/supergraph-build-webhook.yml -s GITHUB_TOKEN --secret-file graph-api.env --detect-event

.PHONY: act-supergraph-gateway-docker-push
act-supergraph-gateway-docker-push:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -W .github/workflows/supergraph-gateway-docker-push.yml --secret-file docker.secrets 

.PHONY: act-k8s
act-k8s:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -W .github/workflows/supergraph-gateway-docker-push.yml -j k8s --secret-file docker.secrets

.PHONY: act-rebase
act-rebase:
	act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -W .github/workflows/rebase.yml -s GITHUB_TOKEN --secret-file docker.secrets --detect-event
