# kuberdp-kalidesktop

The premise of this docker image is to expose an RDP TCP socket on 3389 to
provide a Xrdp desktop with the full Kali linux tool suite, along with
Docker-in-Docker, for security pen-tests.

This image is meant to allow for mounting a shared /home volume for user file
persistence between container respawns.

Note: This directory is self-standing. Running `docker-compose up` does start
a local desktop that you can RDP into.

