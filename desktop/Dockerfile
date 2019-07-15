FROM ubuntu:18.04

# Prepare Docker-CE
RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates curl gnupg gnupg-agent software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io

# Prepare Docker-In-Docker

# set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
RUN set -x \
	&& groupadd -g 2000 dockremap \
	&& useradd -g 2000 -u 2000 dockremap \
	&& echo 'dockremap:165536:65536' >> /etc/subuid \
	&& echo 'dockremap:165536:65536' >> /etc/subgid

# https://github.com/docker/docker/tree/master/hack/dind
ENV DIND_COMMIT 37498f009d8bf25fbb6199e8ccd34bed84f2874b

RUN set -eux; \
	curl -sLo /usr/local/bin/dind "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind"; \
	chmod +x /usr/local/bin/dind

COPY dockerd-entrypoint.sh /usr/local/bin/

VOLUME /var/lib/docker
#EXPOSE 2375

RUN apt-get install -y supervisor

ADD xorgxrdp /etc/apt/preferences.d/xorgxrdp
RUN add-apt-repository ppa:martinx/xrdp-next
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y xrdp xfce4 xfce4-terminal xorgxrdp

RUN sed -i.bak '/fi/a #xrdp multiple users configuration \n xfce-session \n' /etc/xrdp/startwm.sh

EXPOSE 3389

# Install Microsoft Visual Studio Code
 
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y code

RUN curl -sL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y google-chrome-stable sudo

# git config --global core.autocrlf input

#ADD logo.bmp /usr/local/share/xrdp/logo.bmp
ADD run.sh /run.sh
CMD /run.sh

