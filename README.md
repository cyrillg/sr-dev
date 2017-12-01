# Docker image for Serial Robotics

This repository defines a docker image based on Ubuntu 16.04, packed with ROS Kinetic and a Gnome GUI through VNC.
It gives a ready-to-use environment to run the material presented on [Serial Robotics](https://serial-robotics.org) and available at [ros-playground](https://github.com/cyrillg/ros-playground).

It builds on top of the [vnc-ros-gnome](https://github.com/cyrillg/vnc-ros-gnome.git) base image.

## How to use

### With CLI

For convenience, a Command-Line Interface (CLI) dedicated to this image is available in the [sr-cli](https://github.com/cyrillg/sr-cli.git) repo. Check it out for instructions and demos.

### Without CLI

If you do not wish to use the CLI, you can pull the image and run a container using:

```bash
docker run -p 5900:5900 \
           --volume=<absolute-path-to-ros-playground>:/home/serial/ros_ws:rw \
           --name <container-name> \
           cyrillg/sr-dev
```

Once your container is running, you can connect to the desktop with RealVNC, VNC client available as a Chrome extension (other VNC clients might do, but this one has been proven to work). The address is `localhost:5900`.

Note that, at the time I write this, the shell is not functional through the GUI. You can however access it through:

```bash
docker exec -it -u serial <container-name> "/bin/bash"
```

## How to manage in the long run

There are three main ways to use this image for long-term development:

* Building up the container (in the style of VMs)
* Building up the image \#1 (better)
* Building up the image \#2 (even better)

### Building up the container

Changes can be done to the container at runtime, much like what's done with Virtual Machines (VMs).  
It is however not the safest way, since all these changes would be lost if the container gets deleted or corrupted.

One way to mitigate this issue would be to build up the image instead of just the container.

### Building up the image \#1 (better) 

The first and least recommended way to do this is to always [commit](https://docs.docker.com/engine/reference/commandline/commit/) the changes to an updated image. It would prevent any significant loss from container deletion or corruption.

However this solution hits it limits if you are interested in repeatability of the setup, for instance if you want to be able to build a similar image with some key changes, in the future (different user name, updated Ubuntu version etc).

### Building up the image \#2 (even better)

Safety for your environment _and_ repeatability can be achieved if, instead of commiting the changes to the image, you simply maintain a Dockerfile by adding the instructions corresponding to the changes.

This is the way the _sr-dev_ image is designed, using [vnc-ros-gnome](https://github.com/cyrillg/vnc-ros-gnome.git) as its base, and adding its own ingredients to the mix (in this case installing the Gazebo simulator and a Gazebo model database).

