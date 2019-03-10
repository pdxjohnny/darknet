FROM debian:buster

RUN apt-get update && \
  apt-get -y install \
    make \
    bzip2 \
    tar \
    libc6-armel-cross \
    libc6-dev-armel-cross \
    binutils-arm-linux-gnueabi \
    libncurses5-dev \
    gcc-arm-linux-gnueabi \
    g++-arm-linux-gnueabi \
    curl && \
  rm -rf /var/lib/apt/lists/* && \
  for armgcc in $(ls /usr/bin/arm-linux-gnueabi-*); do newfile=/usr/bin/$(echo $armgcc | sed 's/.*arm-l inux-gnueabi-//g'); rm -fv $newfile; ln -sv $armgcc $newfile; done && \
  echo 'deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi' \
    > /etc/apt/sources.list && \
  dpkg --add-architecture armhf && \
  dpkg --remove-architecture amd64 && \
  apt-get update

COPY trusted.gpg /etc/apt/trusted.gpg.d/rpi.gpg

COPY . /usr/src/darknet
WORKDIR /usr/src/darknet

ENV CC arm-linux-gnueabi-gcc
ENV CPP arm-linux-gnueabi-g++
ENV AR arm-linux-gnueabi-ar

RUN make -e
