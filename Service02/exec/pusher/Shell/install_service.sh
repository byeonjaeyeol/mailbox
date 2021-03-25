cp pusher.service /etc/systemd/system/
systemctl daemon-reload
systemctl start pusher
systemctl status pusher
