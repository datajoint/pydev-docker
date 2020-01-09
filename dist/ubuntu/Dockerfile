ARG  UBUNTU_VER=16.04

#Temp Image to create exec to allow UID/GID to be updated on boot
FROM golang:alpine3.9 as go_tmp
COPY ./utility/startup.go /startup.go
RUN cd / && go build startup.go

#Base
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

ADD ./dist/ubuntu/requirements.txt /requirements.txt
RUN pip install -r /requirements.txt \
    && rm /requirements.txt

# Handle packages with improper dependency statements (i.e. pymc)
ADD ./dist/ubuntu/requirements_post.txt /requirements_post.txt
RUN pip install -r /requirements_post.txt \
    && rm /requirements_post.txt

# Initialize Jupyter Notebook config
COPY ./config/jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

# datajoint admin (dja) mapped to docker host user
RUN export uid=3000 gid=3000 && \
    mkdir -p /home/dja && \
    mkdir /src && \
    echo "dja:x:${uid}:${gid}:Developer,,,:/home/dja:/bin/sh" >> /etc/passwd && \
    echo "dja:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/dja && \
    chown ${uid}:${gid} -R /src

# entrypoint + startup
COPY ./dist/ubuntu/entrypoint.sh /entrypoint.sh
COPY --from=go_tmp /startup /startup
ENV PYTHON_USER dja
RUN \
  chmod +x /entrypoint.sh && \
  chmod 4755 /startup && \
  /startup 3000 3000

LABEL maintainerName="Raphael Guzman" \
      maintainerEmail="raphael@vathes.com" \
      maintainerCompany="DataJoint"
USER dja
ENV HOME /home/dja
ENV LANG C.UTF-8
ENV PATH "/usr/local/bin:$PATH:/home/dja/.local/bin"
ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /src
VOLUME /src
VOLUME /tmp/.X11-unix
EXPOSE 8888
CMD ["pip freeze | grep datajoint"]
