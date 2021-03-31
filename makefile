.PHONY: default
default: config compose

.PHONY: config
config:
	./config.sh > supergraph.yaml

.PHONY: compose
compose:
	rover supergraph compose --config ./supergraph.yaml