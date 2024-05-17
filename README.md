# pytorch-cuda

This is a project for building pytorch with CUDA in Fedora based container
images.

## HOWTO

There are some optional ARGs.  You can override the defaults by adding
`--build-arg arg=value` to the `podman build` command.

ARGs with their defaults:
* CUDA_DISTRO=fedora39
* CUDNN_VERSION=9.1.0.70_cuda12
* CUSPARSELT_VERSION=0.6.1.0

```bash
podman build -t pytorch-cuda:latest .
```

## Other stuff

There is an experiment in the `fedora41` directory for building pytorch on
Fedora 41 using the Fedora 39 version of gcc.
