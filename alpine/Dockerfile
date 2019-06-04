ARG  PY_VER=3.7
ARG  ALPINE_VER=3.9
FROM python:${PY_VER}-alpine${ALPINE_VER}
LABEL maintainerName="Raphael Guzman" \
      maintainerEmail="raphael.h.guzman@gmail.com" \
      maintainerCompany="DataJoint"
# min datajoint
RUN \
  apk update && \
  apk --no-cache --update-cache add --virtual build-min-dependencies \
    musl-dev g++

# diagram support
RUN \
  apk --no-cache --update-cache add --virtual build-erd-dependencies \
    pkgconfig && \
  apk --no-cache --update-cache add --virtual run-erd-dependencies \
    gcc freetype-dev graphviz ghostscript-fonts python3-tkinter

# mysql8 support
RUN \
  apk --no-cache --update-cache add --virtual build-mysql8-dependencies \
    openssl-dev libffi-dev

# jupyter support
RUN \
  apk --no-cache --update-cache add --virtual build-jnb-dependencies \
    curl make && \
  mkdir -p min-package && \
  cd min-package && \
  curl -L https://archive.org/download/zeromq_4.0.4/zeromq-4.0.4.tar.gz > package.tar.gz && \
  tar -xzf package.tar.gz && \
  rm package.tar.gz && \
  cd $(ls) && \
  ./configure && make && make install && \
  cd ../../ && \
  rm -rf min-package && \
  strip --strip-unneeded --strip-debug /usr/local/lib/*.a || true && \
  strip --strip-unneeded --strip-debug /usr/local/lib/*.so* || true && \
  pip install jupyter

# Prep git for source
RUN \
  apk --no-cache --update-cache add git

# datajoint admin (dja) mapped to docker host user
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/dja && \
    mkdir /src && \
    echo "dja:x:${uid}:${gid}:Developer,,,:/home/dja:/bin/bash" >> /etc/passwd && \
    echo "dja:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/dja && \
    chown ${uid}:${gid} -R /src
  
USER dja
ENV HOME /home/dja

# min datajoint
RUN pip install --user pandas numpy networkx backcall
# diagram support
RUN pip install --user matplotlib
# mysql8 support
RUN pip install --user cryptography

COPY ./jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

USER root

# remove build dependencies
RUN \
  apk del build-min-dependencies && \
  apk del build-erd-dependencies && \
  apk del build-mysql8-dependencies && \
  apk del build-jnb-dependencies

USER dja

WORKDIR /src
VOLUME /src
VOLUME /tmp/.X11-unix
EXPOSE 8888
CMD ["pip freeze | grep datajoint"]
