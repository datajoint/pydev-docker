FROM eywalker/nvidia-cuda:8.0-cudnn5-devel-ubuntu16.04
MAINTAINER Edgar Y. Walker <edgar.walker@gmail.com>


# Make it pydev
RUN apt-get update &&\
    apt-get install -y software-properties-common \
                       build-essential \
                       git \
                       wget \
                       vim \
                       curl \
                       zip \
                       zlib1g-dev \
                       unzip \
                       pkg-config \
                       gfortran \
                       libfreetype6-dev \
                       pkg-config \
                       libblas-dev \
                       liblapack-dev \
                       python3-dev \
                       python3-pip \
                       python3-tk \
                       cython \
                       python3-wheel \
                       swig &&\
    rm /usr/bin/python &&\
    ln -s /usr/bin/python3 /usr/bin/python &&\
    ln -s /usr/bin/pip3 /usr/bin/pip &&\
    pip install --upgrade pip &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Need this to fix issue with Python 3 read
ENV LANG C.UTF-8

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt \
    && rm /requirements.txt

# Handle packages with improper dependency statements (i.e. pymc)
ADD requirements_post.txt /requirements_post.txt
RUN pip3 install -r /requirements_post.txt \
    && rm /requirements_post.txt

# Install and setup Theano
ENV CUDA_ROOT /usr/local/cuda/bin


# Install bleeding-edge Theano
RUN pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git

# Copy over theanorc for CUDA
ADD theanorc /root/.theanorc
