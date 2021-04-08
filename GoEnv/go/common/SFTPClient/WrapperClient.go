package SFTPClient

import (
	"io"
	"net"
	"os"

	"github.com/pkg/sftp"
	"golang.org/x/crypto/ssh"
)

func Connect(addr string, user string, passwd string) (*ssh.Client, *sftp.Client, error) {
	config := &ssh.ClientConfig{
		User: user,
		Auth: []ssh.AuthMethod{
			ssh.Password(passwd),
		},
		HostKeyCallback: func(hostname string, remote net.Addr, key ssh.PublicKey) error {
			return nil
		},
	}

	conn, err := ssh.Dial("tcp", addr, config)
	if err != nil {
		return nil, nil, err
	}

	client, err := sftp.NewClient(conn)
	if err != nil {
		conn.Close()
		return nil, nil, err
	}

	return conn, client, err
}

func UploadFile(client *sftp.Client, localFile string, serverFile string) (int64, error) {
	tmpFile := serverFile + ".lock"

	dst, err := client.Create(tmpFile)
	if nil != err {
		return 0, err
	}

	src, err := os.Open(localFile)
	if nil != err {
		return 0, err
	}

	writtenBytes, err := io.Copy(dst, src)
	if nil != err {
		return int64(writtenBytes), err
	}

	src.Close()
	dst.Close()

	err = client.Rename(tmpFile, serverFile)
	return int64(writtenBytes), err
}
