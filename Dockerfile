# This for mono-opt under centos 6
FROM centos:centos6

MAINTAINER azraelrabbit <azraelrabbit@gmail.com>

#install perrequired
RUN yum install -y wget tar sudo 

#add mono-opt source
WORKDIR /etc/yum.repos.d

RUN wget http://download.opensuse.org/repositories/home:tpokorra:mono/CentOS_CentOS-6/home:tpokorra:mono.repo
RUN yum install -y openssh-server mono-*opt

RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd
RUN echo "root:monupx" |chpasswd
RUN useradd admin  &&  echo "admin:monupx" | chpasswd  &&  echo "admin   ALL=(ALL)       ALL" >> /etc/sudoers 

# 下面这两句比较特殊，在centos6上必须要有，否则创建出来的容器sshd不能登录
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key  
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key


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
CMD /usr/jexus/jws start && /usr/sbin/sshd &
