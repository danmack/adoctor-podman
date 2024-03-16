# GNU Make Makefile

# the name of your source asciidoctor files
SRC=example.adoc

# the output files
DOCS=example.html example.pdf example.xml

# name of your container image with ascii doctor installed
DCON=alpdoc
DIAG=-r asciidoctor-diagram

# the shared directory path between the host and the docker image
# this should match WORKDIR and VOLUME in Dockerfile
DOCDIR=/docs

DIR := ${CURDIR}

all: $(DOCS)

example.html: $(SRC) *.adoc
	podman run -it -v $(DIR):$(DOCDIR)/:z $(DCON)     asciidoctor $(DIAG) $(SRC)

example.pdf: $(SRC) *.adoc
	podman run -it -v $(DIR):$(DOCDIR)/:z $(DCON) asciidoctor-pdf $(DIAG) $(SRC)

example.xml: $(SRC) *.adoc
	podman run -it -v $(DIR):$(DOCDIR)/:z $(DCON) asciidoctor $(DIAG) --backend docbook $(SRC)

image:
	podman build -t alpdoc .

.PHONY: clean cleanall

clean: 
	rm -f *.pdf *.html *.xml diag-a2s*

cleanall:
	-podman container prune -f
	-podman rmi $$(podman images -a | grep alpdoc | awk '{print $$3}')

