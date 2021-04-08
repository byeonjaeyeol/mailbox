package Util

import (
	"bytes"
	"net"
)

func IsIPv4Addr(ip string) bool {
	netIP := net.ParseIP(ip)
	if nil == netIP.To4() {
		return false
	}
	return true
}

func IpBetween(from string, to string, ip string) bool {
	netFrom := net.ParseIP(from)
	netTo := net.ParseIP(to)
	netIP := net.ParseIP(ip)

	if nil == netFrom.To4() || nil == netTo.To4() || nil == netIP.To4() {
		return false
	}

	if bytes.Compare(netIP, netFrom) >= 0 && bytes.Compare(netIP, netTo) <= 0 {
		return true
	}

	return false
}
