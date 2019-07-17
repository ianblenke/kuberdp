FROM ubuntu:18.04

RUN apt-get update \
 && apt-get install -y apt-transport-https ca-certificates curl gnupg gnupg-agent software-properties-common \
 && apt-get install -y supervisor

ADD xorgxrdp /etc/apt/preferences.d/xorgxrdp
RUN add-apt-repository ppa:martinx/xrdp-next
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y xrdp xfce4 xfce4-terminal xorgxrdp

RUN sed -i.bak '/fi/a #xrdp multiple users configuration \n xfce-session \n' /etc/xrdp/startwm.sh

EXPOSE 3389

#ADD logo.bmp /usr/local/share/xrdp/logo.bmp
ADD run.sh /run.sh
CMD /run.sh

