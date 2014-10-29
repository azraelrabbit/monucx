# This for mono-opt under centos 6
FROM centos:centos6

MAINTAINER azraelrabbit <azraelrabbit@gmail.com>

#Install required system packages
RUN yum install -y wget sudo tar

#add mono-opt source
WORKDIR /etc/yum.repos.d

RUN wget http://download.opensuse.org/repositories/home:tpokorra:mono/CentOS_CentOS-6/home:tpokorra:mono.repo
RUN yum install -y openssh-server mono-opt

RUN mkdir -p /var/run/sshd
RUN echo root:monupx |chpasswd

#set the PATH for mono-opt
ENV PATH $PATH:/opt/mono/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/mono/lib
ENV PKG_CONFIG_PATH $PKG_CONFIG_PATH:/opt/mono/lib/pkgconfig

# install mono web server Jexus
RUN curl https://raw.githubusercontent.com/azraelrabbit/monufile/master/jwsinstall|sh


# open port for ssh 
EXPOSE 22

# open port for jexus web server
EXPOSE 8081

#ENTRYPOINT /usr/sbin/sshd -D && /usr/jexus/jws start
CMD /usr/jexus/jws start & /usr/sbin/sshd
