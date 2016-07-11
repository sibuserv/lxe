MAIN_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: default
default:
	@cd $(MAIN_DIR) && ./make.sh

%:
	@cd $(MAIN_DIR) && ./make.sh $@

