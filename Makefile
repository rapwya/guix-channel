all: gc gpull gsystem warthael

gc:
	guix gc

gpull:
	guix pull --channels=/home/guix-channel/rapwya/channels.scm

gystem:
	sudo guix system reconfigure /home/guix-channel/rapwya/systems/tyfing.scm

warthael:
	guix home reconfigure /home/guix-channel/rapwya/home/warthael.scm

