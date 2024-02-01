FROM debian:12.4-slim

RUN apt update && apt upgrade

# build these images 
# cd src/
# docker buildx build --progress=plain --tag docker_debian_sddm_xvfb --file Dockerfile "."



# new user
ENV PUID='1000' \
    PGID='1000' \
    USER='user' 

RUN groupadd --gid "$PGID" "$USER" && \
    useradd --home-dir /home/$USER --shell /bin/bash --uid "$PUID" --gid "$PGID" "$USER" && \
    mkdir /home/$USER && \
    chown -R $USER:$USER /home/$USER && \
    usermod -aG sudo "$USER" && \
    usermod -aG adm "$USER" && \
    cp /etc/skel/.bashrc /home/user/

# add $USER to sudoers
RUN mkdir -p /etc/sudoers.d && \
    echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"$USER"  && \
    chmod 0440 /etc/sudoers.d/"$USER" 


# remove empty space
# :g/^ /norm dw
# sort
# cat /tmp/t.txt |sort
RUN apt-get update && \
    apt-get full-upgrade && \
    apt-get install --no-install-recommends --no-install-suggests -yqq  sddm \
    xserver-xorg \
    xinit \
    xvfb \
    xfce4 \
    xfce4-terminal \
    x11vnc \
    blackbird-gtk-theme \
    tango-icon-theme \
    dbus \                   
    dbus-user-session \
    dbus-x11 \
    libdbus-1-3 




# clean up
RUN apt-get autoremove -y --auto-remove  && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*  

COPY bootstrap.sh dbus/docker-dbus-entrypoint.sh  opt/



RUN chmod +x /opt/docker-dbus-entrypoint.sh
ENTRYPOINT ["/opt/docker-dbus-entrypoint.sh"] 


# run docker
# docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN --security-opt apparmor=unconfined --tmpfs /run --device /dev/snd --device /dev/dri -v /dev/shm:/dev/shm docker_debian_sddm_xvfb journalctl -f
