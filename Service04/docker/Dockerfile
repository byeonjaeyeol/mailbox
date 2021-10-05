FROM bsquarelab/upost-basic

MAINTAINER BSQUARELAB <erickahn@bsquarelab.com>

COPY IljariAgent.service /etc/systemd/system/
RUN systemctl enable IljariAgent.service

COPY sender.service /etc/systemd/system/
RUN systemctl enable sender.service

WORKDIR /usr/share/tilon

#VOLUME [ "/data/tilon",  "/usr/share/tilon/IljariAgent", "/usr/share/tilon/sender"]

EXPOSE 22

RUN chmod +x /install_sshd.sh

RUN /install_sshd.sh
CMD ["/usr/sbin/init"]
