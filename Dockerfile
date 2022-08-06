FROM debian:bookworm

RUN apt-get update && apt-get install -y build-essential findutils wget bison texinfo gawk bison sudo python3

RUN groupadd lfs && useradd -s /bin/bash -g lfs -m -k /dev/null -d /lfs lfs
RUN echo "lfs ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/wheel

RUN mkdir /lfs/toolchain
COPY toolchain/*sh /lfs/toolchain/
COPY Makefile /lfs/
COPY bashrc /lfs/.bashrc
RUN chown -R lfs /lfs

USER lfs
WORKDIR /mnt/lfs
