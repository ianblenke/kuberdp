# kuberdp-spawner

The premise of this project is to run:
1. An xinetd container pod in kubernetes (kuberdp-spawner)
2. This will spawn an Xrdp kubernetes pod container (kuberdp-desktop)

For each TCP connection through xinetd, the spawner container runs a
shell script that will use kubectl to:

1. Start a kuberdp-desktop container 
2. netcat forward the TCP stream through to the container
3. Destroy the container to clean up after

This allows Xrdp desktops to be spawned on a per-connection basis for a
dedicated container per developer connection.

## run.sh

This script is the default entrypoint of this container, and will setup
a xinetd and supervisord config and then spawn supervisord.

## spawn.sh

This script will be spawned for each connection to the port exposed by
xinetd. It will spawn a new kubernetes deployment, then use netcat to
join the stdin/stdout to the spawned container port.

This script is responsible for cleaning up any spawned deployments.
