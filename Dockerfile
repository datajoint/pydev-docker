FROM nvidia/cuda:cudnn-devel

MAINTAINER Edgar Y. Walker <edgar.walker@gmail.com>

# The rest is Python installation procedure copied from official
# Python image, installed on Debian base image

# remove several traces of debian python
RUN apt-get -y update \ 
    && apt-get install -y build-essential \
    && apt-get install -y dpkg-dev \
    && apt-get install -y curl \
    && apt-get install -y wget \
## WTF...needed this...
    && apt-get install -y libssl-dev \ 
    && apt-get purge -y python.* 

ENV LANG C.UTF-8

# gpg: key F73C700D: public key "Larry Hastings <larry@hasting.org>" imported
ENV GPG_KEY 97FC712E4C024BBEA48A61ED3A5CA953F73C700D

ENV PYTHON_VERSION 3.5.1

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 8.1.1


RUN set -ex \
        && curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz \
        && curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" -o python.tar.xz.asc \
        && export GNUPGHOME="$(mktemp -d)" \
        && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
        && gpg --batch --verify python.tar.xz.asc python.tar.xz \
        && rm -r "$GNUPGHOME" python.tar.xz.asc \
        && mkdir -p /usr/src/python \
        && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
        && rm python.tar.xz \
        \
        && cd /usr/src/python \
        && ./configure --enable-shared --enable-unicode=ucs4 \
        && make -j$(nproc) \
        && make install \
        && ldconfig 


RUN pip3 install --no-cache-dir --upgrade --ignore-installed pip==$PYTHON_PIP_VERSION \
        && find /usr/local \
                \( -type d -a -name test -o -name tests \) \
                -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
                -exec rm -rf '{}' + \
        && rm -rf /usr/src/python

# make some usefule symlinks that are expected to exist
RUN cd /usr/local/bin \
        && ln -s easy_install-3.5 easy_install \
        && ln -s idle3 idle \
        && ln -s pydoc3 pydoc \
        && ln -s python3 python \
        && ln -s python-config3 python-config

# Make it pydev

RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get install -y gfortran \
    && apt-get install -y libblas-dev \
    && apt-get install -y liblapack-dev \
    && apt-get install -y pkg-config \
    && apt-get install -y libfreetype6-dev \
    && apt-get install -y cython \
    && echo 'deb http://www.deb-multimedia.org jessie main non-free' >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --force-yes deb-multimedia-keyring \
    && apt-get update \
#    && apt-get install -y ffmpeg \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt \
    && rm /requirements.txt

# Handle packages with improper dependency statements (i.e. pymc)
ADD requirements_post.txt /requirements_post.txt
RUN pip install -r /requirements_post.txt \
    && rm /requirements_post.txt

# Install and setup Theano
ENV CUDA_ROOT /usr/local/cuda/bin

# Install git
RUN apt-get update && apt-get install -y git

# Install bleeding-edge Theano
RUN pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git

# Set up .theanorc for CUDA
RUN echo "[global]\ndevice=gpu\nfloatX=float32\noptimizer_including=cudnn\n[lib]\ncnmem=1\n[nvcc]\nfastmath=True" > /root/.theanorc
