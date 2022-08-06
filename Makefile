export MAKEFLAGS='-j8'

SHELL = /bin/bash -o pipefail
SCRIPTS := $(wildcard toolchain/*.sh)
LOGS    := $(SCRIPTS:.sh=.log)

.PHONY: toolchain

%.log: %.sh
	$< | sudo tee $@

tc: $(LOGS)

clean:
	sudo umount build; sudo rm -rf build; sudo rm -f toolchain/*.log

deps:
	sudo apt-get install -y build-essential findutils wget bison texinfo gawk bison

toolchain:
	docker run --rm -v '$(shell pwd):/mnt/lfs' onmetal/lfs-builder make tc

docker:
	docker build -t onmetal/lfs-builder .
