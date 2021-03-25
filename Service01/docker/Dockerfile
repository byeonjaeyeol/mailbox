FROM bsquarelab/upost-basic

MAINTAINER BSQUARELAB <erickahn@bsquarelab.com>

COPY epost.interface.service /etc/systemd/system/
RUN systemctl enable epost.interface

WORKDIR /usr/share/tilon

EXPOSE 2100
EXPOSE 22

RUN /install_sshd.sh
CMD ["/usr/sbin/init"]