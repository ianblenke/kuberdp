# kuberdp-tinydesktop

The premise of this docker image is to expose an RDP TCP socket on 3389 to
provide a lean Xrdp desktop.

This image is meant to allow for mounting a shared /home volume for user file
persistence between container respawns.

Note: This directory is self-standing. Running `docker-compose up` does start
a local desktop that you can RDP into.

