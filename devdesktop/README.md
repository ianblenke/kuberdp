# kuberdp-devdesktop

The premise of this docker image is to expose an RDP TCP socket on 3389 to
provide a Xrdp desktop with Microsoft Visual Studio Code and Docker-in-Docker
for developer local full-stack iteration.

This image is meant to allow for mounting a shared /home volume for user file
persistence between container respawns.

For scaling reasons, something like docker-xinetd-kubernetes-spawn-and-relay
should allow these containers to be spawned on demand.

Note: This directory is self-standing. Running `docker-compose up` does start
a local desktop that you can RDP into.

