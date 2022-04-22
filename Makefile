all:
	@echo done

install:
	install -m755 md-elinks            /usr/bofc/bin/md-elinks
	install -m755 open                 /usr/bofc/bin/open
	install -m755 open-in-background   /usr/bofc/bin/open-in-background
	install -m755 print                /usr/bofc/bin/print
	install -m755 zfs-show-compress.sh /usr/bofc/bin/zfs-show-compress.sh
	install -m755 start-program        /usr/bofc/bin/start-program
	install -m755 wake-pc.sh           /usr/bofc/bin/wake-pc.sh
	install -m755 utils.sh             /usr/bofc/lib/utils.sh
