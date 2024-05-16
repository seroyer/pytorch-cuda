# Default to existing gcc build
ARG GCC_IMAGE=quay.io/sroyer/gcc13:fedora41
FROM $GCC_IMAGE

ENV HOME=/

# 'dnf-command(builddep)' does not work correctly with dnf5 right now
# dnf download --source changed to --srpm in dnf5
RUN dnf install -y rpmdevtools dnf5-plugins && \
    dnf download --srpm python-torch

RUN rpmdev-setuptree && \
    rpm -i python-torch*.src.rpm

WORKDIR /rpmbuild

RUN dnf builddep -y SPECS/python-torch.spec --exclude gcc && \
    rpm -qa | grep gcc || true

ENV CUDA_DISTRO=fedora39

# 'dnf-command(config-manager)' does not work correctly with dnf5 right now
# dnf5 config-manager changed from --add-repo to addrepo --from-repofile
RUN dnf config-manager addrepo --from-repofile https://developer.download.nvidia.com/compute/cuda/repos/$CUDA_DISTRO/$(arch)/cuda-$CUDA_DISTRO.repo && \
    dnf install -y cuda-toolkit

# There is no Fedora version of cudnn published by Nvidia, so use the agnostic version
RUN dnf install -y wget xz && \
    wget https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-9.1.0.70_cuda12-archive.tar.xz && \
    tar xf cudnn-linux*.tar.xz && \
    mv cudnn-linux-*-archive /usr/local/cudnn && \
    rm -f cudnn-linux*.tar.xz

ENV CUDAToolkit_ROOT=/usr/local/cuda
ENV CUDNN_PATH=/usr/local/cudnn

# TODO --undefine=_disable_source_fetch is unsafe
RUN sed -i 's/\(export USE_CUDA=ON\)/\1\nexport TORCH_CUDA_ARCH_LIST="8.0 8.6 8.9 9.0"/g' SPECS/python-torch.spec && \
    rpmbuild --undefine=_disable_source_fetch --without rocm --with cuda -ba SPECS/python-torch.spec

# TODO testing, should be in new stage
RUN dnf install -y /rpmbuild/RPMS/*/python3-torch-*.rpm

ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_VISIBLE_DEVICES=all


