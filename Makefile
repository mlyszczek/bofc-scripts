all:
	@echo done

install:
	install -m755 md-elinks            $(DESTDIR)/usr/bofc/bin/md-elinks
	install -m755 open                 $(DESTDIR)/usr/bofc/bin/open
	install -m755 open-in-background   $(DESTDIR)/usr/bofc/bin/open-in-background
	install -m755 print                $(DESTDIR)/usr/bofc/bin/print
	install -m755 zfs-show-compress.sh $(DESTDIR)/usr/bofc/bin/zfs-show-compress.sh
	install -m755 start-program        $(DESTDIR)/usr/bofc/bin/start-program
	install -m755 wake-pc.sh           $(DESTDIR)/usr/bofc/bin/wake-pc.sh
	install -m755 utils.sh             $(DESTDIR)/usr/bofc/lib/utils.sh
