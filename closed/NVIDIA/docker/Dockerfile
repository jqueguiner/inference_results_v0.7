FROM nvidia/cuda:11.0-cudnn8-devel-ubuntu18.04
# Explicitly use bash instead of sh ('echo' behaves differently on some shells)
SHELL ["/bin/bash", "-c"]

COPY passwd /etc/passwd
COPY group /etc/group

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential autoconf libtool git \
        ccache curl wget pkg-config sudo ca-certificates vim-tiny automake libssl-dev \
        bc python3-dev python3-pip python2.7-dev google-perftools gdb libglib2.0-dev clang python-pip sshfs libre2-dev \
        libboost-dev libnuma-dev numactl \
 && apt-get remove -y cmake \
 && apt-get remove -y libgflags-dev \
 && apt-get remove -y libprotobuf-dev \
 && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /tmp

# Needed by LoadGen
RUN python2 -m pip install --upgrade setuptools \
 && python2 -m pip install absl-py==0.7.1

RUN python3 -m pip install --upgrade pip \
 && python3 -m pip install --upgrade setuptools wheel virtualenv \
 && python3 -m pip install cmake==3.17.3 \
 && python3 -m pip install pillow==6.0.0 \
 && python3 -m pip install opencv-python-headless \
 && python3 -m pip install openpyxl==3.0.4 \
 && python3 -m pip install pyyaml==5.1.2

# Needed for power measurements
RUN python3 -m pip install pyvisa pyvisa-py

# install gflags
# -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=ON -DBUILD_gflags_LIB=ON .. \
RUN git clone -b v2.2.1 https://github.com/gflags/gflags.git \
 && cd gflags \
 && mkdir build && cd build \
 && cmake -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=ON -DBUILD_gflags_LIB=ON .. \
 && make -j \
 && make install \
 && cd /tmp && rm -rf gflags

# install glog
RUN git clone -b v0.3.5 https://github.com/google/glog.git \
 && cd glog \
 && cmake -H. -Bbuild -G "Unix Makefiles" -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=ON \
 && cmake --build build \
 && cmake --build build --target install \
 && cd /tmp && rm -rf glog

RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config zip g++ zlib1g-dev unzip python \
 && rm -rf /var/lib/apt/lists/*

# Install TensorFlow, needed by SSDMobileNet benchmark
# Install CPU version since we don't actually need to run TensorFlow.
RUN python3 -m pip install tensorflow==1.13.1

# Install pytorch and torchvision CPU version since the GPU version causes cudnn linking issue
RUN python3 -m pip install torch==1.4.0+cpu torchvision==0.5.0+cpu -f https://download.pytorch.org/whl/torch_stable.html \
 && python3 -m pip install onnx==1.6.0 \
 && python3 -m pip install pycuda==2019.1.2 \
 && python3 -m pip install Cython==0.29.10 \
 && python3 -m pip install pycocotools==2.0.0 \
 && python3 -m pip install scikit-learn==0.22.2 \
 && python3 -m pip install numpy==1.16.0 \
 && python3 -m pip install pytest==4.6.2 \
 && python3 -m pip install matplotlib==3.0.2

# Install CUB, needed by NMS OPT plugin
RUN wget https://github.com/NVlabs/cub/archive/1.8.0.zip -O cub-1.8.0.zip \
 && unzip cub-1.8.0.zip \
 && mv cub-1.8.0/cub /usr/include/x86_64-linux-gnu/ \
 && rm -rf cub-1.8.0.zip cub-1.8.0

# Install libjemalloc2
RUN echo 'deb http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse' | tee -a /etc/apt/sources.list.d/focal.list \
  && echo 'Package: *\nPin: release a=focal\nPin-Priority: -10\n' | tee -a /etc/apt/preferences.d/focal.pref \
  && apt-get update \
  && apt-get install --no-install-recommends -t focal -y libjemalloc2 libtcmalloc-minimal4

# Install HuggingFace Transformers
RUN python3 -m pip install transformers==2.4.0

# Install nnUnet, needed by 3D-Unet.
RUN cd /tmp \
 && git clone https://github.com/MIC-DKFZ/nnUNet.git \
 && cd nnUNet \
 && git checkout cf28f1f223208db0df91e1b4354ad26145d97a73 \
 && python3 -m pip install . \
 && cd /tmp \
 && rm -rf nnUNet

# Install dependencies needed for RNN-T preprocessing
RUN apt-get install -y sox \
 && python3 -m pip install sox==1.4.0 toml==0.10.1 unidecode==1.1.1 inflect==4.1.0 librosa==0.8.0 \
 && cd /tmp \
 && git clone https://www.github.com/nvidia/apex \
 && cd apex \
 && python3 setup.py install \
 && cd /tmp \
 && rm -rf apex

# Needed by official RNNT accuracy script
RUN apt-get install -y --no-install-recommends libsndfile1-dev

# Install rapidJSON, needed by Triton
RUN apt-get update && apt-get install rapidjson-dev

# Install DALI 0.25.0
RUN python3 -m pip install --extra-index-url https://developer.download.nvidia.com/compute/redist nvidia-dali-cuda110==0.25

# Install TRT 7.2
ARG NV_DEB_URL=https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64
RUN cd /tmp \
    && install_deb_pkg() { wget $NV_DEB_URL/$1 -O $1 && dpkg -i $1 && rm $1; } \
    && install_deb_pkg libnvinfer7_7.2.0-1+cuda11.0_amd64.deb \
    && install_deb_pkg libnvinfer-plugin7_7.2.0-1+cuda11.0_amd64.deb \
    && install_deb_pkg libnvparsers7_7.2.0-1+cuda11.0_amd64.deb \
    && install_deb_pkg libnvonnxparsers7_7.2.0-1+cuda11.0_amd64.deb \
    && install_deb_pkg libnvinfer-dev_7.2.0-1+cuda11.0_amd64.deb \
    && install_deb_pkg libnvinfer-plugin-dev_7.2.0-1+cuda11.0_amd64.deb \
    && install_deb_pkg libnvparsers-dev_7.2.0-1+cuda11.0_amd64.deb \
    && install_deb_pkg libnvonnxparsers-dev_7.2.0-1+cuda11.0_amd64.deb \
    && install_deb_pkg python3-libnvinfer_7.2.0-1+cuda11.0_amd64.deb \
    && install_deb_pkg python3-libnvinfer-dev_7.2.0-1+cuda11.0_amd64.deb \
    && unset -f install_deb_pkg
# With latest Ubuntu:18.04 container, there will be no 'python' or 'pip' even if we have installed 'python3' and
# 'python3-pip'. So add softlink to avoid wheel installation failure.
RUN ln -sf /usr/bin/python3 /usr/bin/python
RUN ln -sf /usr/bin/pip3 /usr/bin/pip
RUN python3 -m pip install nvidia-pyindex \
    && python3 -m pip install uff graphsurgeon onnx-graphsurgeon

# Explicitly downgrade numpy since cocoeval requires numpy 1.16.x.
RUN python3 -m pip install numpy==1.16.0

RUN apt-get update && apt-get install -y \
    man \
    vim \
    nano \
    htop \
    curl \
    wget \
    rsync \
    ca-certificates \
    git \
    zip \
    procps \
    ssh \
    supervisor \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

ENV NVM_DIR /root/.nvm
ENV NODE_VERSION v12.20.1

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/bin
ENV PATH $NODE_PATH:$PATH

# Install VSCode Server
RUN wget --quiet https://github.com/cdr/code-server/releases/download/v3.5.0/code-server_3.5.0_amd64.deb && \
    dpkg -i code-server_3.5.0_amd64.deb && rm -rf code-server_3.5.0_amd64.deb && \
    rm -f code-server_3.5.0_amd64.deb && \
    /usr/bin/code-server --install-extension ms-python.python --force

COPY vscode.sh /usr/bin/vscode.sh
EXPOSE 8081

# Install Jupyter
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3 get-pip.py --force-reinstall
RUN pip install pip==20.3.4
RUN pip install jupyterlab==2.2.9 ipywidgets==7.6.3
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter nbextension enable --py widgetsnbextension #enable ipywidgets
COPY jupyter.sh /usr/bin/jupyter.sh
EXPOSE 8082

# Home server
COPY home-server.sh /usr/bin/home-server.sh
RUN mkdir -p /usr/opt/
RUN chown 42420:42420 /usr/opt/
COPY home-server.html /usr/bin/home-server.html
EXPOSE 8080

# MOTD
COPY motd.sh /usr/bin/motd.sh

WORKDIR /workspace
RUN git clone https://github.com/jqueguiner/inference_results_v0.7.git

RUN chown -R 42420:42420 /workspace

COPY supervisor.conf /etc/supervisor/supervisor.conf

ENV MLPERF_SCRATCH_PATH /workspace/mlperfv07_data

WORKDIR /workspace/inference_results_v0/closed/NVIDIA/

RUN make build

ENTRYPOINT []
CMD ["supervisord", "-n", "-u", "42420", "-c", "/etc/supervisor/supervisor.conf"]

