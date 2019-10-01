ARG  PY_VER=3.7
ARG  ALPINE_VER=3.9

#Temp Image to create exec to allow UID/GID to be updated on boot
FROM golang:alpine${ALPINE_VER} as go_tmp
COPY ../utility/startup.go /startup.go
RUN cd / && go build startup.go

#Base
FROM python:${PY_VER}-alpine${ALPINE_VER} as py_build
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
# jupyter dependencies
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
  strip --strip-unneeded --strip-debug /usr/local/lib/*.so* || true 
# Prep git for source
RUN \
  apk --no-cache --update-cache add git
# datajoint admin (dja) mapped to docker host user
RUN export uid=3000 gid=3000 && \
    mkdir -p /home/dja && \
    mkdir /src && \
    echo "dja:x:${uid}:${gid}:Developer,,,:/home/dja:/bin/sh" >> /etc/passwd && \
    echo "dja:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/dja && \
    chown ${uid}:${gid} -R /src
# entrypoint + startup
COPY ./entrypoint.sh /entrypoint.sh
COPY --from=go_tmp /startup /startup
RUN \
  chmod +x /entrypoint.sh && \
  chmod 4755 /startup
  
USER dja
ENV HOME /home/dja
# min datajoint
RUN pip install --user pandas numpy networkx backcall
# diagram support
RUN pip install --user matplotlib
# mysql8 support
RUN pip install --user cryptography
# jupyter support
RUN \
  pip install --user jupyter && \
  chmod -R o+rwx /home/dja/.local/lib && \
  chmod -R o+wx /home/dja/.local/share && \
  chmod -R o+w /home/dja/.cache
COPY ../config/jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

USER root
# remove build dependencies
RUN \
  apk del build-min-dependencies && \
  apk del build-erd-dependencies && \
  apk del build-mysql8-dependencies && \
  apk del build-jnb-dependencies

#Squashed Final Image
FROM scratch
COPY --from=py_build / /
RUN chmod 4755 /startup
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
