FROM randomdude/gcc-cross-x86_64-elf

RUN apt-get update 
RUN apt-get upgrade -y

RUN apt-get install -y nasm
RUN apt-get install -y xorriso
RUN apt-get install -ygrub-pc-bin
RUN apt-get install -ygrub-common
RUN apt-get install nasm -y
RUN apt-get install grub-common -y

VOLUME /root/env
WORKDIR /root/env


