all:
	@echo done

install:
	install -D -m755 md-elinks            $(DESTDIR)/usr/bofc/bin/md-elinks
	install -D -m755 open                 $(DESTDIR)/usr/bofc/bin/open
	install -D -m755 open-in-background   $(DESTDIR)/usr/bofc/bin/open-in-background
	install -D -m755 print                $(DESTDIR)/usr/bofc/bin/print
	install -D -m755 zfs-show-compress.sh $(DESTDIR)/usr/bofc/bin/zfs-show-compress.sh
	install -D -m755 start-program        $(DESTDIR)/usr/bofc/bin/start-program
	install -D -m755 wake-pc.sh           $(DESTDIR)/usr/bofc/bin/wake-pc.sh
	install -D -m755 screen-powermode-monitord.sh  $(DESTDIR)/usr/bofc/bin/screen-powermode-monitord.sh
	install -D -m755 utils.sh             $(DESTDIR)/usr/bofc/lib/utils.sh
