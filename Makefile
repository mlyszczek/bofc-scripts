PROGS=$(notdir $(shell find . -type f -executable -and -not -path "./.git*"))
PREFIX=/usr/bofc
Q=@

all:
	@echo done

install:
	$Q for f in $(PROGS); do \
	    if [ $$f = utils.sh ]; then continue; fi; \
	    echo install $$f; \
	    install -D -m755 $$f $(DESTDIR)/$(PREFIX)/bin/$$f; \
	done
	$Q install -D -m755 utils.sh $(DESTDIR)/$(PREFIX)/lib/utils.sh
	@echo install utils.sh
