FROM python:3.5

MAINTAINER Edgar Y. Walker
RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get install -y gfortran \
    && apt-get install -y libblas-dev \
    && apt-get install -y liblapack-dev
ADD requirements.txt /requirements.txt
RUN pip install -v -r /requirements.txt
RUN pip install git+https://github.com/datajoint/datajoint-python.git \
     && pip install pymc
WORKDIR /srv
CMD /bin/python
