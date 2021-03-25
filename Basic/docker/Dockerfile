FROM centos:7
MAINTAINER Lloyd Benson <lloyd.benson@gmail.com>
ENV container docker
RUN yum -y swap -- remove systemd-container systemd-container-libs -- install systemd systemd-libs
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

# centos7 systemd
#--------------------------------------------
# centos7 systemd + sshd

RUN yum -y install openssh-server openssh-clients epel-release sudo && \
    rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN yum -y install pwgen

COPY sshd_config /etc/ssh/sshd_config
COPY install_sshd.sh /install_sshd.sh

EXPOSE 22
RUN systemctl enable sshd

## use as a base and then add these 
#RUN /install_sshd.sh
#CMD ["/usr/sbin/init"]