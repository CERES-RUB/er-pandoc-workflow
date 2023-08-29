all: export import

export:
	docker build -t registry.git.noc.ruhr-uni-bochum.de/entangled-religions/pandoc-workflow/export:edge-mp .

import:
	docker build -t registry.git.noc.ruhr-uni-bochum.de/entangled-religions/pandoc-workflow/import:edge -f Dockerfile.import .

.PHONY: all export import
