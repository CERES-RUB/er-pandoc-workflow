all: docker

docker:
	docker build -t registry.git.noc.ruhr-uni-bochum.de/entangled-religions/pandoc-workflow/export:edge-lua .
	docker build -t registry.git.noc.ruhr-uni-bochum.de/entangled-religions/pandoc-workflow/import:edge -f Dockerfile.import .

.PHONY: all docker
