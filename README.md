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

The _sr-dev_ image will be updated from time to time to follow the progress of Serial Robotics, and even the _vnv-ros-gnome_ base image is likely to change (added features, bug fixes).

If you wish to use this in the long run it is then important to figure out how to keep the environment up-to-date without losing any of your own work.

There are three main ways to use this image for long-term development:

* Building up the image \#1 (recommended)
* Building up the image \#2
* Building up the container (in the style of VMs)

Let's illustrate each of these with an example. Let's say for instance that your favourite editor is Emacs, which is not included in the _vnc-ros-gnome_ or _sr-dev_ images. You want to install it. A few fays after you do, the sr-dev image is updated with changes like:

* the user name is changed
* a new service is installed
* several textfiles are modified
* ROS is updated from Kinetic to Lunar

### Building up the image \#1 (recommended)

The best way to go would be to:

1. branch out from the latest sr-dev master branch to maintain your own Dockerfile
2. add the changes to the Dockerfile of your personal branch: in this case add the `RUN apt-get install emacs` instruction
3. build the updated image

When the sr-dev image gets updated later on, you would then:

1. pull the latest master branch
2. merge it into your own branch
3. build the updated image  

_**Warning**: Every new build would require you to delete the current container and create a new one from the newly built image, so be careful to have fully updated your Dockerfile before proceeding with the container deletion._

This is the way the _sr-dev_ image is designed, using [vnc-ros-gnome](https://github.com/cyrillg/vnc-ros-gnome.git) as its base, and adding its own ingredients to the mix (e.g. installing the Gazebo simulator, adding a Gazebo model database).

It is the best solution in that it allows a consistent worflow across updates, and provides you with a maintainable and transparent image. It is also the most in line with the docker philosophy (even though this philosophy is not applied for other aspects)

A demonstration of the workflow described above it available in the README of the [sr-cli repo](https://github.com/cyrillg/sr-cli.git).

### Building up the image \#2 

Another way to do this would be to:

1. install emacs inside your running container
2. [commit] (https://docs.docker.com/engine/reference/commandline/commit/) your personal changes to an updated image. 

When the sr-dev image gets updated later on, you would then:

1. go and check what is new in the sr-dev master branch Dockerfile
2. apply each of the changes in your running container manually
3. commit these changes to an updated image

This solution does not require you to recreate the container, but at the price of having to manually perform every single update. Any change would have to be done at runtime, making the maintenance difficult after a while.

### Building up the container (advised against)

_**Warning**: This way is only given as information, because it might seem like a good idea before the first issue occurs. It is advised against._

Changes could be done to the container at runtime, same as in the previous option but without commiting the changes to a new image. It would be akin to using a virtual machine without making snapshots/backups, and would expose you to losing your whole work in case of container deletion or corruption.

