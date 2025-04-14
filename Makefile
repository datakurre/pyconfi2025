TEXFILE ?= public-announcement

.PHONY: all
all: build

help:
	@grep -Eh '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | uniq

%.nav: %.tex
	@latexmk -shell-escape -quiet $<

%.pdf: %.tex images
	@latexmk -pdf -recorder -interaction=nonstopmode -shell-escape -use-make -quiet $<

build: $(TEXFILE).pdf  ## Build the final PDF
	mkdir -p build
	mv *.pdf build
	echo '<meta http-equiv="refresh" content= "0;url=public-announcement.pdf" />' > build/index.html
	touch build/.nojekyll

.PHONY: watch
watch:  ## Develop PDF and watch for changes
	@latexmk -pvc -pdf -recorder -interaction=nonstopmode -shell-escape -use-make $(TEXFILE)

.PHONY: clean
clean:
	@latexmk -C -quiet
	@rm -f *.nav *.snm *.fls *.vrb _minted-$(TEXFILE)/*
	@if [ -d _minted-$(TEXFILE) ]; then rmdir _minted-$(TEXFILE); fi

.PHONY: shell
shell:
	devenv shell
