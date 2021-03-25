FROM bsquarelab/upost-basic

MAINTAINER BSQUARELAB <erickahn@bsquarelab.com>

COPY epost.interface.service /etc/systemd/system/
RUN systemctl enable epost.interface

COPY epost.collector.service /etc/systemd/system/
RUN systemctl enable epost.collector

COPY pusher.service /etc/systemd/system/
RUN systemctl enable pusher


WORKDIR /usr/share/tilon

VOLUME [ "/usr/share/tilon/collector",  "/usr/share/tilon/interface", "/usr/share/tilon/pusher"]

EXPOSE 2100
EXPOSE 22

RUN /install_sshd.sh
CMD ["/usr/sbin/init"]