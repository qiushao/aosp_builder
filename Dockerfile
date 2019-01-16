# base image
FROM ubuntu:14.04

# MAINTAINER
MAINTAINER qiushaox@gmail.com

# use base as sh instead of dash
RUN ln -sf /bin/bash /bin/sh

# add user 
RUN useradd -d /home/builder -m builder
ADD user.txt /home/builder
RUN chpasswd < /home/builder/user.txt
RUN rm /home/builder/user.txt
RUN echo "builder  ALL=(ALL)       ALL" >> /etc/sudoers

# support i386
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y lib32z1 lib32ncurses5 lib32bz2-1.0

# jdk setting
RUN mkdir -p /usr/lib/jvm
ADD tools/jdk1.6.0_45.tar.gz /usr/lib/jvm
RUN apt-get install -y software-properties-common
#RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install -y openjdk-7-jdk
RUN apt-get install -y openjdk-8-jdk

# java env setting, default jdk1.6
ENV JAVA_HOME /usr/lib/jvm/jdk1.6.0_45
ENV PATH $JAVA_HOME/bin:$PATH
RUN echo "" >> /home/builder/.bashrc
RUN echo "# jdk setting" >> /home/builder/.bashrc
RUN echo "export JAVA_HOME=$JAVA_HOME" >> /home/builder/.bashrc
RUN echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> /home/builder/.bashrc

# compile toolchain
RUN apt-get install -y gcc-multilib g++-multilib build-essential
RUN apt-get install -y git-core gnupg bison flex gperf pngcrush bc zip curl lzop
RUN apt-get install -y schedtool libxml2 libxml2-utils xsltproc squashfs-tools
RUN apt-get install -y libesd0-dev libsdl1.2-dev libwxgtk2.8-dev libswitch-perl
RUN apt-get install -y libssl1.0.0 libssl-dev lib32readline-gplv2-dev libncurses5-dev

# use ccache
RUN apt-get install -y ccache
RUN echo "export USE_CCACHE=1" >> /home/builder/.bashrc
RUN echo "" >> /home/builder/.bashrc

# vim setting
RUN apt-get install -y vim
ADD tools/vimrc /home/builder/.vimrc

# android source volume
USER builder
WORKDIR /home/builder
ENV USER builder

