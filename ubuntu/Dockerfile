ARG  UBUNTU_VER=16.04
FROM ubuntu:${UBUNTU_VER}
MAINTAINER Edgar Y. Walker <edgar.walker@gmail.com>

RUN apt-get update &&\
    apt-get install -y build-essential \
                       gfortran \
                       vim \
                       curl \
                       wget \
                       git \
                       zip \
                       zlib1g-dev \
                       unzip \
                       libfreetype6-dev \
                       pkg-config \
                       libblas-dev \
                       liblapack-dev \
                       python3-dev \
                       python3-pip \
                       python3-tk \
                       python3-wheel \
                       swig \
		       graphviz \
                       graphviz-dev \
                       cython &&\
    ln -s /usr/bin/python3 /usr/local/bin/python &&\
    ln -s /usr/bin/pip3 /usr/local/bin/pip &&\
    pip install --upgrade pip &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG C.UTF-8

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt \
    && rm /requirements.txt

# Handle packages with improper dependency statements (i.e. pymc)
ADD requirements_post.txt /requirements_post.txt
RUN pip install -r /requirements_post.txt \
    && rm /requirements_post.txt

CMD ["/bin/sh", "-c", "ipython"]
