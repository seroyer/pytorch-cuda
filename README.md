# pytorch-cuda

This is a project for building pytorch with CUDA in Fedora based container
images.  CUDA has hard requirements on gcc versions, so this includes building
gcc as well.

## HOWTO

I have already built the gcc container and published it in quay.io, so it can
be used directly.  However, this is built on Fedora Rawhide, and it moves fast
so it may be desirable to update.

Build gcc image.  NOTE it will take a long time!

```bash
export GCC_IMAGE=<your image name>
podman build -f Containerfile.gcc -t $GCC_IMAGE .
```

Next build the pytorch image using your previously built gcc.

```bash
podman build -f Containerfile -t pytorch-cuda:latest \
       --build-arg GCC_IMAGE=$GCC_IMAGE .
```
