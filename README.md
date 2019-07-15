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

There is no nginx-ingress bundled here to publically expose the TCP port through a 
Load Balancer. That exercise varies somewhat, and so is left for the reader for the moment.

