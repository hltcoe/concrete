# Installing the thrift compiler can be painful, so this Dockerfile
# does it for you!
#
# To build:
# 
#     docker build -t concrete-thrift .
#
# To run:
#
#     docker run --rm concrete-thrift --help
#
# To generate source code for a concrete library repository that
# expects the schema to be located at ~/concrete or ../concrete:
#
#     docker run --mount type=bind,src=$PWD,dst=/app --rm concrete-thrift
#
# Also consider making a script at ~/bin/thrift with the following
# contents:
#
#    #!/bin/bash                                                             
#    docker run --mount type=bind,src=$PWD,dst=/app --rm concrete-thrift "$@"
#
# If this script is executable (chmod u+x ~/bin/thrift) and ~/bin is in
# your PATH, you can then run thrift, calling this Docker image, as if
# it was installed directly on your host machine.  There are some
# limitations, however:  Depending on your Docker install, files
# written by thrift-in-Docker will be owned by root.  Also, if you pass
# an absolute thrift definition path like /home/cmay/test.thrift
# instead of a relative path like ../test.thrift, it won't be
# resolvable in the Docker container.
#
# If those limitations are an issue, consider running the container
# interactively instead, copying files to/from the container as they
# are needed.  For example, to start an interactive bash shell in a
# concrete-thrift container:
#
#     docker run --entrypoint= --rm -it --name interactive-thrift concrete-thrift bash
#
# Then, in another window, you can use Docker cp to copy files you
# need to and from the container.  For example:
#
#     docker cp ~/concrete-python interactive-thrift:/app/
#
# Then, once you're done using thrift in the container:
#
#     docker cp interactive-thrift:/app/concrete-python ~/updated-concrete-python


FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        curl \
        default-jdk \
        git \
        libboost-all-dev \
        python-is-python3 \
        python3 \
        python3-pip \
        python3-setuptools \
        npm \
        unzip \
    && rm -rf /var/lib/apt/lists/*
RUN pip install \
        beautifulsoup4 \
        git+https://chromium.googlesource.com/external/gyp \
        six

RUN curl -O https://dlcdn.apache.org/thrift/0.17.0/thrift-0.17.0.tar.gz && \
    tar xvfz thrift-0.17.0.tar.gz && \
    cd thrift-0.17.0 && \
    ./configure && \
    make && \
    make install

ADD . /concrete
WORKDIR /app

ENTRYPOINT ["thrift"]
