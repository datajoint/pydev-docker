FROM python:3.5

MAINTAINER Edgar Y. Walker <edgar.walker@gmail.com>

RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get install -y gfortran \
    && apt-get install -y libblas-dev \
    && apt-get install -y liblapack-dev \
    && apt-get install -y cython \
    && apt-get install -y  libhdf5-dev \\
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt \
    && rm /requirements.txt

# Handle packages with improper dependency statements (i.e. pymc)
ADD requirements_post.txt /requirements_post.txt
RUN pip install -r /requirements_post.txt \
    && rm /requirements_post.txt

CMD ["/bin/sh", "-c", "ipython"]
