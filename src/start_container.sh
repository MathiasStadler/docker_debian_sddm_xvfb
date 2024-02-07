#!/bin/nash

docker run -it -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
-v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
-v ~/.config/pulse/cookie:/root/.config/pulse/cookie \
--group-add $(getent group audio | cut -d: -f3) \
-v /tmp/.X11-unix:/tmp/.X11-unix  \
--cap-add SYS_ADMIN --cap-add  CAP_SYS_MODULE \
--security-opt apparmor=unconfined \
--tmpfs /run --device /dev/snd \
--device /dev/dri \
-v /dev/shm:/dev/shm \
-v /home/trapapa/docker_debian_12/workspace:/home/user/workspace:rw \
--cgroupns=host \
-v /sys/fs/cgroup:/sys/fs/cgroup \
docker_debian_xvfb_sound bash