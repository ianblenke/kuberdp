# kuberdp

This project spawns a new kubernetes pod container per RDP connection.

The spawner image is responsible for spawning the container and for plumbing the connection.

The desktop image is essentially a self-contained developer workstation image with Xrdp.

There are 3 desktop container images built by this repo:

- ianblenke/kuberdp-tinydesktop
- ianblenke/kuberdp-devdesktop
- ianblenke/kuberdp-kalidesktop

The script `./apply-resources.sh` will deploy on any kubernetes cluster, and should present
a RDP NodePort accessible on TCP port 30389 on all of the cluster Nodes.

# Usage:

## kubernetes:

Edit the `.env` file to select the `DESKTOP_NAME` and `DESKTOP_IMAGE` of your choosing.

Run `make`:

    make

Then connect to `localhost:3389`

The `Makefile` runs a `kubectl port-forward` to proxy an RDP listener from localhost.

## docker-compose

Change directory to your desired desktop image and run `make`:

    cd tinydesktop/
    make

