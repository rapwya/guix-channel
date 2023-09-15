all: gc gpull gsystem warthael

gc:
	guix gc

gpull:
	guix pull --channels=/home/warthael/guix-channel/rapwya/channels.scm

gsystem:
	sudo guix system reconfigure /home/warthael/guix-channel/rapwya/systems/tyfing.scm

warthael:
	guix home reconfigure /home/warthael/guix-channel/rapwya/home/warthael.scm

