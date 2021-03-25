FROM bsquarelab/upost-basic

MAINTAINER BSQUARELAB <erickahn@bsquarelab.com>

COPY analyzer.service /etc/systemd/system/
RUN systemctl enable analyzer.service

COPY sender.service /etc/systemd/system/
RUN systemctl enable sender.service

WORKDIR /usr/share/tilon

VOLUME [ "/data/tilon",  "/usr/share/tilon/analyzer", "/usr/share/tilon/sender"]

EXPOSE 22

RUN /install_sshd.sh
CMD ["/usr/sbin/init"]