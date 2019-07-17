# kuberdp

This project spawns a new kubernetes pod container per RDP connection from a developer.

The spawner image is responsible for spawning the container and for plumbing the connection.

The desktop image is essentially a self-contained developer workstation image with:
- Xrdp + XFCE desktop
- Visual Studio Code
- Docker-in-Docker
- Google Chrome

The script `./apply-resources.sh` will deploy on any kubernetes cluster, and should present
a RDP NodePort accessible on TCP port 30389 on all of the cluster Nodes.

The `Makefile` runs a `kubectl port-forward` to proxy an RDP listener from localhost.

# Usage:

Run `make`:

    make

Then connect to `localhost:3389`
