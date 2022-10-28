PROGS=$(notdir $(shell find . -maxdepth 1 -type f -executable -and -not -path "./.git*"))
PREFIX=/usr/bofc
Q=@

all:
	@echo done

install:
	@echo =====[ Installing programs ]======
	$Q for f in $(PROGS); do \
	    if [ $$f = utils.sh ]; then continue; fi; \
	    echo install $$f; \
	    install -D -m755 $$f $(DESTDIR)/$(PREFIX)/bin/$$f; \
	done
	$Q install -D -m755 utils.sh $(DESTDIR)/$(PREFIX)/lib/utils.sh
	@echo install utils.sh
	@echo =====[ Installing init.d ]=====
	$Q for f in init.d/*; do \
	    echo install $$f; \
	    if [ -L $$f ]; then cp -a $$f $(DESTDIR)/etc/$$f; \
	    else install -D -m755 $$f $(DESTDIR)/etc/$$f; fi \
	done
	@echo =====[ Installing conf.d ]=====
	$Q for f in conf.d/*; do \
	    echo install $$f; \
	    install -D -m644 $$f $(DESTDIR)/etc/$$f; \
	done
