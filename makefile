.PHONY: default
default: config compose

.PHONY: introspect
introspect:
	.scripts/introspect.sh

.PHONY: config
config:
	.scripts/config.sh > supergraph.yaml

.PHONY: compose
compose:
	rover supergraph compose --config ./supergraph.yaml

.PHONY: publish
publish:
	.scripts/publish.sh
