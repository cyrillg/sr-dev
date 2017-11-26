FROM cyrillg/vnc-ros-gnome
MAINTAINER Cyrill Guillemot "https://github.com/cyrillg"

RUN apt-get install -y ros-kinetic-gazebo-ros-pkgs
COPY files/.gazebo /home/serial/.gazebo

CMD    ["/usr/bin/supervisord"]

