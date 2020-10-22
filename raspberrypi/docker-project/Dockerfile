FROM debian:latest

LABEL maintainer="Elliot Schot <s3530160@student.rmit.edu.au>"

ARG LAST_4_DIGIT_STUDENT_NUMBER=0160
ARG FISH_SHELL_LINK="https://github.com/fish-shell/fish-shell/releases/download/2.7.1/fish-2.7.1.tar.gz"
ARG BERRYCONDA_LINK="https://github.com/jjhelmus/berryconda/releases/download/v2.0.0/Berryconda3-2.0.0-Linux-armv7l.sh"

############## build stage ##############
RUN \
	echo "**** update and upgrade ****" && \
	apt-get update && \
	apt-get upgrade -y
RUN \
	echo "**** installing base commands ****" && \
	apt-get install -y \
	openssh-server \
	nginx \
	curl \
	tar \
	bzip2 \
	sudo \
	nano
RUN \
	useradd -m -d /home/fishy -c "Fish Fish" mrfishy && \
	echo "mrfishy:docker" | chpasswd && \
	usermod -aG sudo mrfishy
RUN \
	sed -i 's/#\?\(PermitRootLogin\s*\).*$/\1 no/' /etc/ssh/sshd_config
RUN \
	apt-get install -y \
	vim \
	vim-gtk
RUN \
	apt-get install -y \
	gcc \
	g++ \
	build-essential \
	ncurses-dev \
	libncurses5-dev \
	gettext \
	mktemp \
	autoconf
RUN \
	apt-get install -y \
	man \
	python2.7
RUN \
	echo "**** compling fish from source ****" && \
	curl -o /tmp/fish.tar.gz -L "https://github.com/fish-shell/fish-shell/releases/download/2.7.1/fish-2.7.1.tar.gz" && \
	mkdir /tmp/fishbuild && \
	tar -xzf /tmp/fish.tar.gz --directory /tmp/fishbuild && \
	cd /tmp/fishbuild/fish-2.7.1 && \
	./configure && \
	make && \
	make install
RUN \
	echo "**** configure fish shells ****" && \
	echo '/usr/local/bin/fish' | tee -a /etc/shells > /dev/null && \
	chsh --shell /usr/local/bin/fish mrfishy && \
	su mrfishy && \
	touch /home/fishy/.config/fish/config.fish && \
	echo "set -x fish_user_paths /usr/bin/berryconda3/bin" >> /home/fishy/.config/fish/config.fish && \
	chown mrfishy:mrfishy /home/fishy/.config/fish/config.fish
RUN \
	echo "**** installing berryconda ****" && \
	curl -o /tmp/berryconda.sh -L "https://github.com/jjhelmus/berryconda/releases/download/v2.0.0/Berryconda3-2.0.0-Linux-armv7l.sh" && \
	chmod +x /tmp/berryconda.sh && \
	./tmp/berryconda.sh -b -p /usr/bin/berryconda3
	#echo "PATH=/usr/bin/berryconda3/bin:$PATH" > /etc/profile.d/berryconda.sh
RUN \
	echo "**** cleanup ****" && \
	apt-get clean && \
	rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

EXPOSE 80
EXPOSE 22

# Called on first run of docker - will run supervisor
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD /start.sh ; sleep infinity