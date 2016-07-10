MAIN_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: default
default:
	@cd $(MAIN_DIR) && ./make.sh

.PHONY: help
help:
	@cd $(MAIN_DIR) && ./make.sh --help

.PHONY: version
version:
	@cd $(MAIN_DIR) && ./make.sh --version

%:
	@cd $(MAIN_DIR) && ./make.sh $@

