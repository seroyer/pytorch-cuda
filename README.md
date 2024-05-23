# pytorch-cuda

This is a project for building pytorch with CUDA in Fedora based container
images.

## HOWTO

There are some optional ARGs.  You can override the defaults by adding
`--build-arg arg=value` to the `podman build` command.

ARGs with their defaults:
* CUDA_DISTRO=rhel9
* CUDA_VERSION=12-3

```bash
podman build -t pytorch-cuda:latest cuda12.3
```

## Other stuff

### cuda12.4

Nvidia released CUDA 12.4 support for Fedora 39.  Unfortunately, pytorch 2.3.0
only supports up to CUDA 12.1 at this time, so this is currently on hold until
pytorch updates to support CUDA 12.4

