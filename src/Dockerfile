# syntax=docker/dockerfile:1
FROM debian:12.4-slim

# RUN apt update && apt upgrade
RUN apt update 

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
    echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"${USER}"  && \
    chmod 0440 /etc/sudoers.d/"$USER" && \
    cp /etc/skel/.bashrc /home/${USER}


# remove empty space
# :g/^ /norm dw
# sort
# cat /tmp/t.txt |sort

# insert in final version
# apt-get full-upgrade && \
RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -yqq apt-transport-https \
    apt-utils \
    ca-certificates \
    xserver-xorg \
    xinit \
    xvfb \
    xfce4 \
    xfce4-terminal \
    x11vnc \
    x11-utils \
    blackbird-gtk-theme \
    tango-icon-theme \
    dbus \                   
    dbus-user-session \
    dbus-x11 \
    libdbus-1-3 \
    fluxbox \
    wget \
    libssl-dev \
    sudo \
    vim \
    fonts-liberation \
    upower \
    eterm




# install rust
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.75.0

RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
    amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='0b2f6c8f85a3d02fde2efc0ced4657869d73fccfce59defb4e8d29233116e6db' ;; \
    armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='f21c44b01678c645d8fbba1e55e4180a01ac5af2d38bcbd14aa665e0d96ed69a' ;; \
    arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='673e336c81c65e6b16dcdede33f4cc9ed0f08bde1dbe7a935f113605292dc800' ;; \
    i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='e7b0f47557c1afcd86939b118cbcf7fb95a5d1d917bdd355157b63ca00fc4333' ;; \
    *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.26.0/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
    apt-get remove -y --auto-remove \
    wget \
    ; \
    rm -rf ls   

RUN rustup update stable

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


#ps wwwwaux

# open a x-windows
# x-terminal-emulator -T Bash -e /bin/bash --login

# apt install xdg-desktop-portal-kde

# DEBIAN_FRONTEND=nointeractive

# debconf: (Can't locate Debconf/FrontEnd/Nointeractive.pm in @INC (you may need to install the Debconf::FrontEnd::Nointeractive module)

#hier weiter sddm
# docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN --security-opt apparmor=unconfined --tmpfs /run --device /dev/snd --device /dev/dri  -v /dev/shm:/dev/shm docker_debian_sddm_xvfb bash