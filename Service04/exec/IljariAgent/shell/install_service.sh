cp IljariAgent.service /usr/lib/systemd/system/
systemctl daemon-reload
systemctl start IljariAgent.service
systemctl status IljariAgent.service
