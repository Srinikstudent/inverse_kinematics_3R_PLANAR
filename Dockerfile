FROM osrf/ros:noetic-desktop-full

RUN apt-get update && apt-get install -q -y nano && \
    apt-get update && apt-get install -q -y sudo git && \
    apt-get update && apt-get install -q -y usbutils && \
    apt-get update && apt-get install -q -y python3-wstool python3-rosdep ninja-build stow && \
    apt-get update && apt-get install -q -y ros-noetic-position-controllers && \
    apt-get update && apt-get install -q -y ros-noetic-effort-controllers && \
    apt-get update && apt-get install -q -y ros-noetic-joint-state-controller && \
    apt-get update && apt-get install -q -y ros-noetic-rosbridge-server && \
    apt-get update && apt-get install -q -y ros-noetic-sick-tim && \
    apt-get update && apt-get install -q -y python3-pip

RUN bash -c "source /opt/ros/noetic/setup.bash && \
             cd ~ && \
             mkdir -p /catkin_ws/src && \
             cd /catkin_ws/src && \
             catkin_init_workspace && \
             mkdir my_package"

COPY . /container_entrypoint.sh /catkin_ws/src/my_package/container_entrypoint.sh
WORKDIR ~

RUN bash -c "source /opt/ros/noetic/setup.bash && \
             cd /catkin_ws/ && \
             catkin_make"

RUN bash -c "chmod +x /catkin_ws/src/my_package/container_entrypoint.sh"

RUN bash -c "source /opt/ros/noetic/setup.bash && \
                       source /catkin_ws/devel/setup.bash && \
                       cd && \
                       sudo rm /etc/ros/rosdep/sources.list.d/20-default.list && \
                       cd /catkin_ws && \
                       rosdep init && \
                       rosdep update && \
                       rosdep install --from-paths src --ignore-src --rosdistro=noetic -y"

