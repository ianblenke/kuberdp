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

# Install Kali linux and all the trimmings

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python git

# The below borrowed from https://github.com/LionSec/katoolin/blob/master/katoolin.py

RUN curl -sL https://archive.kali.org/archive-key.asc | apt-key add
#RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-keys ED444FF07D8D0BF6
RUN echo 'deb http://http.kali.org/kali kali-rolling main contrib non-free' >> /etc/apt/sources.list
# ClassicMenu Indicator is a notification area applet (application indicator) for the top panel of Ubuntu's Unity desktop environment.
# It provides a simple way to get a classic GNOME-style application menu for those who prefer this over the Unity dash menu.
# Like the classic GNOME menu, it includes Wine games and applications if you have those installed.
# For more information , please visit : http://www.florian-diesch.de/software/classicmenu-indicator/
RUN add-apt-repository ppa:diesch/testing && apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y classicmenu-indicator
# Kali menu
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y kali-menu 
# All categories
#RUN DEBIAN_FRONTEND=noninteractive apt-get -f install acccheck ace-voip amap automater braa casefile cdpsnarf cisco-torch cookie-cadger copy-router-config dmitry dnmap dnsenum dnsmap dnsrecon dnstracer dnswalk dotdotpwn enum4linux enumiax exploitdb fierce firewalk fragroute fragrouter ghost-phisher golismero goofile lbd maltego-teeth masscan metagoofil miranda nmap p0f parsero recon-ng set smtp-user-enum snmpcheck sslcaudit sslsplit sslstrip sslyze thc-ipv6 theharvester tlssled twofi urlcrazy wireshark wol-e xplico ismtp intrace hping3 bbqsql bed cisco-auditing-tool cisco-global-exploiter cisco-ocs cisco-torch copy-router-config doona dotdotpwn greenbone-security-assistant hexorbase jsql lynis nmap ohrwurm openvas-cli openvas-manager openvas-scanner oscanner powerfuzzer sfuzz sidguesser siparmyknife sqlmap sqlninja sqlsus thc-ipv6 tnscmd10g unix-privesc-check yersinia aircrack-ng asleap bluelog blueranger bluesnarfer bully cowpatty crackle eapmd5pass fern-wifi-cracker ghost-phisher giskismet gqrx kalibrate-rtl killerbee kismet mdk3 mfcuk mfoc mfterm multimon-ng pixiewps reaver redfang spooftooph wifi-honey wifitap wifite apache-users arachni bbqsql blindelephant burpsuite cutycapt davtest deblaze dirb dirbuster fimap funkload grabber jboss-autopwn joomscan jsql maltego-teeth padbuster paros parsero plecost powerfuzzer proxystrike recon-ng skipfish sqlmap sqlninja sqlsus ua-tester uniscan vega w3af webscarab websploit wfuzz wpscan xsser zaproxy burpsuite dnschef fiked hamster-sidejack hexinject iaxflood inviteflood ismtp mitmproxy ohrwurm protos-sip rebind responder rtpbreak rtpinsertsound rtpmixsound sctpscan siparmyknife sipp sipvicious sniffjoke sslsplit sslstrip thc-ipv6 voiphopper webscarab wifi-honey wireshark xspy yersinia zaproxy cryptcat cymothoa dbd dns2tcp http-tunnel httptunnel intersect nishang polenum powersploit pwnat ridenum sbd u3-pwn webshells weevely casefile cutycapt dos2unix dradis keepnote magictree metagoofil nipper-ng pipal armitage backdoor-factory cisco-auditing-tool cisco-global-exploiter cisco-ocs cisco-torch crackle jboss-autopwn linux-exploit-suggester maltego-teeth set shellnoob sqlmap thc-ipv6 yersinia beef-xss binwalk bulk-extractor chntpw cuckoo dc3dd ddrescue dumpzilla extundelete foremost galleta guymager iphone-backup-analyzer p0f pdf-parser pdfid pdgmail peepdf volatility xplico dhcpig funkload iaxflood inviteflood ipv6-toolkit mdk3 reaver rtpflood slowhttptest t50 termineter thc-ipv6 thc-ssl-dos acccheck burpsuite cewl chntpw cisco-auditing-tool cmospwd creddump crunch findmyhash gpp-decrypt hash-identifier hexorbase john johnny keimpx maltego-teeth maskprocessor multiforcer ncrack oclgausscrack pack patator polenum rainbowcrack rcracki-mt rsmangler statsprocessor thc-pptp-bruter truecrack webscarab wordlists zaproxy apktool dex2jar python-distorm3 edb-debugger jad javasnoop jd ollydbg smali valgrind yara android-sdk apktool arduino dex2jar sakis3g smali \
# && wget http://www.morningstarsecurity.com/downloads/bing-ip2hosts-0.4.tar.gz \
# && tar -xzvf bing-ip2hosts-0.4.tar.gz \
# && cp bing-ip2hosts-0.4/bing-ip2hosts /usr/local/bin/
# Information Gathering
## copy-router-config
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y acccheck ace-voip amap automater braa casefile cdpsnarf cisco-torch cookie-cadger dmitry dnmap dnsenum dnsmap dnsrecon dnstracer dnswalk dotdotpwn enum4linux enumiax exploitdb fierce firewalk fragroute fragrouter ghost-phisher golismero goofile lbd maltego-teeth masscan metagoofil miranda nmap p0f parsero recon-ng set smtp-user-enum snmpcheck sslcaudit sslsplit sslstrip sslyze thc-ipv6 theharvester tlssled twofi urlcrazy wireshark wol-e xplico ismtp intrace hping3 && wget http://www.morningstarsecurity.com/downloads/bing-ip2hosts-0.4.tar.gz && tar -xzvf bing-ip2hosts-0.4.tar.gz && cp bing-ip2hosts-0.4/bing-ip2hosts /usr/local/bin/
# Vulnerability Analysis
## copy-router-config openvas-cli openvas-manager openvas-scanner greenbone-security-assistant
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y bbqsql bed cisco-auditing-tool cisco-global-exploiter cisco-ocs cisco-torch doona dotdotpwn hexorbase jsql lynis nmap ohrwurm oscanner powerfuzzer sfuzz sidguesser siparmyknife sqlmap sqlninja sqlsus thc-ipv6 tnscmd10g unix-privesc-check yersinia
# Wireless Attacks
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y aircrack-ng asleap bluelog blueranger bluesnarfer bully cowpatty crackle eapmd5pass fern-wifi-cracker ghost-phisher giskismet gqrx kalibrate-rtl killerbee kismet mdk3 mfcuk mfoc mfterm multimon-ng pixiewps reaver redfang spooftooph wifi-honey wifitap wifite
# Web Applications tools
## w3af vega
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache-users arachni bbqsql blindelephant burpsuite cutycapt davtest deblaze dirb dirbuster fimap funkload grabber jboss-autopwn joomscan jsql maltego-teeth padbuster paros parsero plecost powerfuzzer proxystrike recon-ng skipfish sqlmap sqlninja sqlsus ua-tester uniscan webscarab websploit wfuzz wpscan xsser zaproxy
# Sniffing & Spoofing
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y burpsuite dnschef fiked hamster-sidejack hexinject iaxflood inviteflood ismtp mitmproxy ohrwurm protos-sip rebind responder rtpbreak rtpinsertsound rtpmixsound sctpscan siparmyknife sipp sipvicious sniffjoke sslsplit sslstrip thc-ipv6 voiphopper webscarab wifi-honey wireshark xspy yersinia zaproxy
# Maintaining Access
## http-tunnel
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y cryptcat cymothoa dbd dns2tcp httptunnel intersect nishang polenum powersploit pwnat ridenum sbd u3-pwn webshells weevely
# Reporting Tools
## magictree
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y casefile cutycapt dos2unix dradis keepnote metagoofil nipper-ng pipal
# Exploitation Tools
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y armitage backdoor-factory cisco-auditing-tool cisco-global-exploiter cisco-ocs cisco-torch crackle jboss-autopwn linux-exploit-suggester maltego-teeth set shellnoob sqlmap thc-ipv6 yersinia beef-xss
# Forensics Tools
# iphone-backup-analyzer
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y binwalk bulk-extractor chntpw cuckoo dc3dd ddrescue dumpzilla extundelete foremost galleta guymager p0f pdf-parser pdfid pdgmail peepdf volatility xplico
# Stress Testing
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y dhcpig funkload iaxflood inviteflood ipv6-toolkit mdk3 reaver rtpflood slowhttptest t50 termineter thc-ipv6 thc-ssl-dos
# Password Attacks
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y acccheck burpsuite cewl chntpw cisco-auditing-tool cmospwd creddump crunch findmyhash gpp-decrypt hash-identifier hexorbase john johnny keimpx maltego-teeth maskprocessor multiforcer ncrack oclgausscrack pack patator polenum rainbowcrack rcracki-mt rsmangler statsprocessor thc-pptp-bruter truecrack webscarab wordlists zaproxy
# Reverse Engineering
# python-diStorm3 JD OllyDbg Valgrind YARA
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apktool dex2jar edb-debugger jad javasnoop smali
# Hardware Hacking
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y android-sdk apktool arduino dex2jar sakis3g smali
# Extra
#RUN git clone https://github.com/LionSec/wifresti.git && cp wifresti/wifresti.py /usr/bin/wifresti && chmod +x /usr/bin/wifresti && wifresti
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y squid3

## Alternatively, comment out the above and use katoolin
#RUN git clone https://github.com/LionSec/katoolin.git && cp katoolin/katoolin.py /usr/bin/katoolin \
# && chmod +x /usr/bin/katoolin

#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y lxde-core lxde kali-defaults kali-root-login desktop-base

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y firefox

RUN curl -sL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y google-chrome-stable sudo

# git config --global core.autocrlf input

#ADD logo.bmp /usr/local/share/xrdp/logo.bmp
ADD run.sh /run.sh
CMD /run.sh

