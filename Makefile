.DEFAULT_GOAL := help
.PHONY: help
help: ## Print this help message
	@echo "List of available make commands";
	@echo "";
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}';
	@echo "";

.PHONY: setup-ocaml setup-ocaml-local-switch
setup-ocaml: ## Setup OCaml development environment using the current global OPAM switch
	opam install . -y --deps-only --with-test || echo "FAILED!! you may want to run opam update"

setup-ocaml-local-switch: ## (Recommended) Setup OCaml development environment with a local OPAM switch
	opam switch create . 4.14.1 -y --deps-only
	$(MAKE) setup-ocaml

.PHONY: setup-nodepkg
setup-nodepkg: ## Fetch necessary Node.js packages
	yarn install

.PHONY: build
build: ## build everything
	dune build

.PHONY: build-watch
build-watch: ## build everything (watch file changes)
	dune build -w

.PHONY: chakra-simple-serve
chakra-simple-serve: build ## Serve the chakra-simple example
	(cd example/chakra-simple && npm run serve)
