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
    curl \
    wget \
    libssl-dev \
    sudo \
    vim \
    fonts-liberation \
    upower \
    eterm \
    gnupg \
    libasound2 \          
    libatk1.0-0 \           
    libatk-bridge2.0-0 \
    libatspi2.0-0 \
    libc6-dev \     
    libcanberra-gtk-module  \
    libcups2 \       
    libdrm2 \                    
    libgbm1 \     
    libgl1-mesa-dri \
    libgtk-3-0 \ 
    libnspr4 \   
    libnss3 \            
    libpango1.0-0 \ 
    libpulse0 \   
    libu2f-udev \
    libv4l-0 \         
    libvulkan1 \   
    libwayland-client0 \
    libxcomposite1 \
    libxdamage-dev \
    unzip \
    pulseaudio \
    pulseaudio-utils \
    pulsemixer \
    pkg-config\
    libssl-dev\
    x11-utils




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
    rm -rf ls   

RUN rustup update stable

# install google-chrome-stable latest version
# FROM HERE
# https://gist.github.com/varyonic/dea40abcf3dd891d204ef235c6e8dd79?permalink_comment_id=3976763
# Set up the Chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Update the package list and install chrome
RUN apt-get update -y
RUN apt-get install --no-install-recommends --no-install-suggests -yqq google-chrome-stable


ENV CHROMEDRIVER_DIR /chromedriver
RUN CHROME_VERSION=$(google-chrome --product-version | cut -d '.' -f 1-3) && \
DRIVER_VERSION=$(curl -s "https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_$CHROME_VERSION") && \
wget -q --continue -P $CHROMEDRIVER_DIR "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$DRIVER_VERSION/linux64/chromedriver-linux64.zip"

RUN unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR

# Put Chromedriver into the PATH
ENV PATH $CHROMEDRIVER_DIR:$PATH

# clean up
RUN apt-get autoremove -y --auto-remove  && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*  

COPY bootstrap.sh dbus/docker-dbus-entrypoint.sh  opt/

# copy start-chrome.sh
COPY start-chrome.sh /home/${USER}

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