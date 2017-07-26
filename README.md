# Encapsulate Xilinx PetaLinux tools 14.04 into docker image

## Versions
- PetaLinux version: 2014.4
- Base image: Ubuntu:16.04

## Features
- Environment variables are set, so no need to source settings.sh on launch.
- The default working directory is `/workspace`, you can mount a volume to there to save your data.

## Build image
You can use `build-image.sh` to build the image, which set up a HTTP server using python on where PetaLinux tools installer is, and do `docker build` to build image. The first parameter of this script is the directory of PetaLinux installer. There are two `build-arg` in the Dockerfile, one is `installer_url`, which is set by `build-image.sh` using IP of docker network bridge, another is `install_dir`, which is `/opt` by default.

## Run test

To run a container:

```shell
docker run -ti -v /path/to/projects:/workspace xaljer/petalinux:2014.4
```

in the container:

```shell
petalinux-create -t project -s <path-to-bsp> -n <project-name>
cd <project-name>
petalinux-build  # this will take a long time
```

## TODOs

- alias can also be added to simplify some frequently-used commands, however, do the alias on host like `docker exec bash -c '<commands>'` may more convenient. 

## More help

- I uploaded this image to docker hub, you can download via:

  `docker pull xaljer/petalinux:2014.4`

- More details for the Dockerfile and build process are recorded in [my blog](blog.csdn.net/elegant__), which is written in Chinese.

## PetaLinux reference

[ug1144-petalinux-tools-reference-guide](https://www.xilinx.com/support/documentation/sw_manuals/petalinux2014_4/ug1144-petalinux-tools-reference-guide.pdf)

