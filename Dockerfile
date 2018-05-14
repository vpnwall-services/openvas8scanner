# pull base image
FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install locales

# set the locales
RUN locale-gen fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR.UTF-8
ENV LC_ALL fr_FR.UTF-8

# install dependancies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -qq locales software-properties-common lsof tmux tcpdump
RUN apt-add-repository ppa:mrazavi/openvas
RUN apt-get update
RUN apt-get install -qq wget unzip openvas
RUN apt-get install -qq openvas-gsa
RUN apt-get install -qq ssh
RUN apt-get install -qq iputils-ping
RUN apt-get install -qq nano
# grab the checked out source
RUN mkdir -p /workingdir
WORKDIR /workingdir
COPY ./workingdir /workingdir

# run initial commands
# CMD [executable,param1,param2]
ENTRYPOINT ["/workingdir/entrypoint.sh"]
