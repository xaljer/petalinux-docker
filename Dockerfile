# Encapsulate Xilinx Petalinux tools 14.04 into docker image

FROM  ubuntu:16.04
LABEL maintainer="xaljer@outlook.com"

ARG install_dir=/opt
ARG installer_url=172.17.0.1:8000

ENV PETALINUX_VER=2014.4 \
    PETALINUX=${install_dir}/petalinux-v2014.4-final
ENV PATH="${PETALINUX}/tools/linux-i386/arm-xilinx-gnueabi/bin:\
${PETALINUX}/tools/linux-i386/arm-xilinx-linux-gnueabi/bin:\
${PETALINUX}/tools/linux-i386/microblaze-xilinx-elf/bin:\
${PETALINUX}/tools/linux-i386/microblazeel-xilinx-linux-gnu/bin:\
${PETALINUX}/tools/linux-i386/petalinux/bin:\
${PETALINUX}/tools/common/petalinux/bin:\
${PATH}"

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
# Required tools and libraries of Petalinux.
# See in: ug1144-petalinux-tools-reference-guide, v2014.4.
    tofrodos            \
    iproute             \
    gawk                \
    gcc-4.7             \
    git-core            \
    make                \
    net-tools           \
    rsync               \
    wget                \
    tftpd-hpa           \
    zlib1g-dev          \
    flex                \
    bison               \
    bc                  \
    lib32z1             \
    lib32gcc1           \
    libncurses5-dev     \
    libncursesw5-dev    \
    libncursesw5:i386   \
    libncurses5:i386    \
    libbz2-1.0:i386     \
    libc6:i386          \
    libstdc++6:i386     \
    libselinux1         \
    libselinux1:i386    \
# Using expect to install Petalinux automatically.
    expect              \
&& rm -rf /var/lib/apt/lists/* /tmp/* \
&& ln -fs gcc-4.7 /usr/bin/gcc        \
&& ln -fs gcc-ar-4.7 /usr/bin/gcc-ar  \
&& ln -fs gcc-nm-4.7 /usr/bin/gcc-nm  \
&& ln -fs gcc-ranlib-4.7 /usr/bin/gcc-ranlib

# Install Petalinux tools
WORKDIR $install_dir
COPY ./auto-install.sh .

# There are two methods to get petalinux installer in:
# 1. Using COPY instruction, but it will significantly increase the size of image.
#    In this way, you should place installer to context which is sent to docker daemon.
# 2. Getting installer via network, but it need a server exit. If there is not a web
#    address to host it, a simple http server can be set up locally using python.
# You should choose one of them.
# = 1. =============================================================================
# COPY ./petalinux-v2014.4-final-installer.run .
# RUN  chmod a+x petalinux-v2014.4-final-installer.run \
#      && ./auto-install.sh $install_dir
# = 2. =============================================================================
RUN wget -q $installer_url/petalinux-v2014.4-final-installer.run && \
    chmod a+x petalinux-v2014.4-final-installer.run              && \
    ./auto-install.sh $install_dir                               && \
    rm -rf petalinux-v2014.4-final-installer.run
# ==================================================================================

# RUN echo 'alias plbuild="petaliux-build"' >> ~/.bashrc      && \
#     echo 'alias plcreate="petaliux-create"' >> ~/.bashrc    && \
#     echo 'alias plconfig="petalinx-config"' >> ~/.bashrc    && \

RUN ln -fs /bin/bash /bin/sh    # bash is PetaLinux recommended shell
WORKDIR /workspace

