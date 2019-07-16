#!/bin/bash
set -eo pipefail
env > /.env

mkdir -p etc/xinetd.d

cat <<EOF > /etc/xinetd.d/rdp
service rdp
{
	disable		= no
	flags		= IPv4
	socket_type     = stream
	wait            = no
	user            = root
	server          = /spawn.sh
	server_args     = --foreground
	log_on_failure  += USERID
}
EOF

cat <<EOF > /etc/xinetd.d/rdpnodeport
service rdpnodeport
{
	disable		= no
	flags		= IPv4
	socket_type     = stream
	wait            = no
	user            = root
	server          = /spawn.sh
	server_args     = --foreground
	log_on_failure  += USERID
}
EOF

cat <<EOF > /etc/xinetd.d/echo
# default: on
# description: An xinetd internal service which echo's characters back to
# clients.
# This is the tcp version.
service echo
{
	disable		= no
	type		= INTERNAL
	id		= echo-stream
	socket_type	= stream
	protocol	= tcp
	user		= root
	wait		= no
}

# This is the udp version.
service echo
{
	disable		= no
	type		= INTERNAL
	id		= echo-dgram
	socket_type	= dgram
	protocol	= udp
	user		= root
	wait		= yes
}
EOF

cat <<EOF > /etc/xinetd.d/echonodeport
# default: on
# description: An xinetd internal service which echo's characters back to
# clients.
# This is the tcp version.
service echonodeport
{
	disable		= no
	type		= INTERNAL
	id		= echo-stream
	socket_type	= stream
	protocol	= tcp
	user		= root
	wait		= no
}

# This is the udp version.
service echonodeport
{
	disable		= no
	type		= INTERNAL
	id		= echo-dgram
	socket_type	= dgram
	protocol	= udp
	user		= root
	wait		= yes
}
EOF

mkdir -p /etc/supervisor/conf.d/

cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[unix_http_server]
file=/var/run/supervisor.sock   ; (the path to the socket file)
chmod=0700                  ; sockef file mode (default 0700)

[supervisord]
logfile=/var/log/supervisor/supervisord.log ; (main log file;default $CWD/supervisord.log)
pidfile=/var/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
childlogdir=/var/log/supervisor            ; ('AUTO' child log dir, default $TEMP)
nodaemon = true
autostart = true
autorestart = true
user = root
; the below section must remain in the config file for RPC
; (supervisorctl/web interface) to work, additional interfaces may be
; added by defining them in separate rpcinterface: sections

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock ; use a unix:// URL  for a unix socket

[program:xinetd]
command = /usr/bin/script -c "xinetd -d -dontfork -stayalive -filelog /dev/stdout"
priority=10
directory=/etc/xinetd.d
autostart=true
autorestart=true
stdout_events_enabled=true
stderr_events_enabled=true
stopsignal=TERM
stopwaitsecs=1
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
EOF

echo "echonodeport	30007/tcp" >> /etc/services
echo "rdp		3389/tcp" >> /etc/services
echo "rdpnodeport	30389/tcp" >> /etc/services

exec /usr/bin/supervisord --nodaemon -c /etc/supervisor/conf.d/supervisord.conf
