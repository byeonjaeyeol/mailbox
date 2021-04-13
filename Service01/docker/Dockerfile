FROM bsquarelab/upost-basic

MAINTAINER BSQUARELAB <erickahn@bsquarelab.com>

RUN yum install -y libpng libjpeg
RUN yum install -y libXrender libXext fontconfig

COPY epost.interface.service /etc/systemd/system/
RUN systemctl enable epost.interface

WORKDIR /usr/share/tilon

EXPOSE 2100
EXPOSE 22

RUN /install_sshd.sh
CMD ["/usr/sbin/init"]