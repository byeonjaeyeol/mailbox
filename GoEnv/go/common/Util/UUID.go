package Util

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/md5"
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"encoding/binary"
	"encoding/hex"
	"errors"
	"fmt"
	"hash/fnv"
	"io"
	"runtime"
	"strconv"
)

// GenerateUuid : CreateUUID string
func GenerateUuid() string {
	b := make([]byte, 16)
	rand.Read(b)
	uuid := fmt.Sprintf("%x-%x-%x-%x-%x", b[0:4], b[4:6], b[6:8], b[8:10], b[10:])
	b = nil
	return uuid
}

// Sha256 : create sha256 hash value
func Sha256(plainText string) string {
	hashBytes := sha256.Sum256([]byte(plainText))

	return hex.EncodeToString(hashBytes[:])
}

// Sha256 : create sha256 hash value
func Sha256b(plainBytes []byte) string {
	hashBytes := sha256.Sum256(plainBytes)

	return hex.EncodeToString(hashBytes[:])
}

func FNV1a64(plainText string) string {
	h := fnv.New64a()
	h.Write([]byte(plainText))
	sum := h.Sum64()

	buffer := make([]byte, 8)
	binary.LittleEndian.PutUint64(buffer, sum)
	res := hex.EncodeToString(buffer)
	buffer = nil

	return res
}

func MD5(plainText string) string {
	hashBytes := md5.Sum([]byte(plainText))
	fmt.Println(hashBytes, len(hashBytes))
	return hex.EncodeToString(hashBytes[:])
}

func MD5b(plainBytes []byte) string {
	hashBytes := md5.Sum(plainBytes)
	return hex.EncodeToString(hashBytes[:])
}

func Encrypt(k string, p string) (string, error) {
	key := []byte(k)
	plainText := []byte(p)

	block, err := aes.NewCipher(key)
	if err != nil {
		return "", err
	}

	b := base64.StdEncoding.EncodeToString(plainText)

	ciphertext := make([]byte, aes.BlockSize+len(b))

	iv := ciphertext[:aes.BlockSize]
	if _, err := io.ReadFull(rand.Reader, iv); err != nil {
		return "", err
	}
	cfb := cipher.NewCFBEncrypter(block, iv)
	cfb.XORKeyStream(ciphertext[aes.BlockSize:], []byte(b))

	cipherHex := hex.EncodeToString(ciphertext)

	return cipherHex, nil
}

func Decrypt(k string, c string) (string, error) {
	key := []byte(k)

	text, err := hex.DecodeString(c)
	if nil != err {
		return "", err
	}

	block, err := aes.NewCipher(key)
	if err != nil {
		return "", err
	}
	if len(text) < aes.BlockSize {
		return "", errors.New("ciphertext too short")
	}
	iv := text[:aes.BlockSize]
	text = text[aes.BlockSize:]
	cfb := cipher.NewCFBDecrypter(block, iv)
	cfb.XORKeyStream(text, text)
	data, err := base64.StdEncoding.DecodeString(string(text))
	if err != nil {
		return "", err
	}

	return string(data), nil
}

func Decrypt_base64(k string, c string) (string, error) {
	key := []byte(k)

	ptb, err := base64.StdEncoding.DecodeString(c)
	if nil != err {
		return "", err
	}

	hx := hex.EncodeToString(ptb)
	text, err := hex.DecodeString(hx)
	if nil != err {
		return "", err
	}

	block, err := aes.NewCipher(key)
	if err != nil {
		return "", err
	}
	if len(text) < aes.BlockSize {
		return "", errors.New("ciphertext too short")
	}
	iv := text[:aes.BlockSize]
	text = text[aes.BlockSize:]
	cfb := cipher.NewCFBDecrypter(block, iv)
	cfb.XORKeyStream(text, text)
	data, err := base64.StdEncoding.DecodeString(string(text))
	if err != nil {
		return "", err
	}

	return string(data), nil
}

func GetGID() uint64 {
	b := make([]byte, 64)
	b = b[:runtime.Stack(b, false)]
	b = bytes.TrimPrefix(b, []byte("goroutine "))
	b = b[:bytes.IndexByte(b, ' ')]
	n, _ := strconv.ParseUint(string(b), 10, 64)
	return n
}
