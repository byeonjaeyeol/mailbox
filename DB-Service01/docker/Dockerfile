FROM bsquarelab/upost-basic

MAINTAINER BSQUARELAB <erickahn@bsquarelab.com>

COPY analyzer.service /etc/systemd/system/
RUN systemctl enable analyzer.service

COPY analyzer.authorized.service /etc/systemd/system/
RUN systemctl enable analyzer.authorized.service

COPY sender.service /etc/systemd/system/
RUN systemctl enable sender.service


COPY tracer.service /etc/systemd/system/
RUN systemctl enable tracer.service




WORKDIR /usr/share/tilon

VOLUME [ "/data/tilon",  "/usr/share/tilon/analyzer", "/usr/share/tilon/sender", "/usr/share/tilon/analyzer.authorized", "/usr/share/tilon/tracer"]

EXPOSE 22

RUN /install_sshd.sh
CMD ["/usr/sbin/init"]