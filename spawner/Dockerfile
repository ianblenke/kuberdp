FROM bitnami/kubectl:1.13

USER root

RUN mkdir -p /var/lib/apt/lists/partial

# Install xinetd
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
   	bash \
   	xinetd \
	netcat \
 && rm -rf /var/lib/apt/lists/* 

# Install supervisord
RUN apt-get update \
 && apt-get install -y supervisor \
 && rm -rf /var/lib/apt/lists/* 

ADD run.sh /
ADD spawn.sh /

ENTRYPOINT /run.sh
