.DEFAULT_GOAL = help
.ONESHELL:

HELP_FUNC = \
	%help; \
	while(<>) { \
		if(/^([a-z0-9_-]+):.*\#\#(?:@(\w+))?\s(.*)$$/) { \
			push(@{$$help{$$2}}, [$$1, $$3]); \
		} \
	}; \
	print "usage: make [target]\n\n"; \
	for ( sort keys %help ) { \
		print "$$_:\n"; \
		printf("  %-20s %s\n", $$_->[0], $$_->[1]) for @{$$help{$$_}}; \
		print "\n"; \
	}

.PHONY: help destroy init provision ping configure all

help: ##@targets Show this help.
	@perl -e '$(HELP_FUNC)' $(MAKEFILE_LIST)

destroy: ##@targets Destroys provisioned infrastructure.
	cd provision; \
	terraform apply -destroy -auto-approve

init: ##@targets Initializes provision scripts.
	cd provision; \
	terraform init

provision: init ##@targets Provisions infrastructure for Kafka cluster.
	cd provision; \
	terraform apply -auto-approve

ping: ##@targets Verifies connection to provisioned EC2 instances.
	cd configure; \
	ansible all -m ping

configure:  ##@targets Installs and configures Kafka cluster.
	cd configure; \
	ansible-playbook confluent.platform.all --tags=zookeeper,kafka_broker

all: init provision ping configure ##@targets Provisions infrastructure, installs and configures Kafka cluster.
