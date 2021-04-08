package Util

import (
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

func ReadFile(f string) {
	fmt.Println(f)
	os.Open(f)
}

func GetPath() string {
	path, _ := os.Getwd()
	return path
}

func ExistPath(strPath string) bool {
	if _, serr := os.Stat(strPath); serr != nil {
		return false
	}
	return true
}

func Mkdir(strPath string) error {
	if _, serr := os.Stat(strPath); serr != nil {
		merr := os.MkdirAll(strPath, os.ModePerm)
		if merr != nil {
			return merr
		}
	}
	return nil
}

func Remove(strPath string) bool {
	err := os.Remove(strPath)
	if err != nil {
		return false
	}
	return true
}

func Rename(strFrom string, strTo string) bool {
	err := os.Rename(strFrom, strTo)
	if err != nil {
		return false
	}
	return true
}

/////////////////////////////////////////////////////////////////////////
// SFolder_r : get file list include sub-dir
/////////////////////////////////////////////////////////////////////////
func SFolder_r(fileList *[]string, path string, whiteList []string) error {
	files, err := ioutil.ReadDir(path)
	if nil != err {
		return err
	}

	for _, f := range files {
		if true == f.IsDir() {
			SFolder_r(fileList, fmt.Sprint(path, "/", f.Name()), whiteList)
			continue
		}

		absFile := fmt.Sprint(path, "/", f.Name())
		if true == extChecker(absFile, whiteList) {
			*fileList = append(*fileList, absFile)
		}
	}

	return nil
}

func sfolder(fileList *[]string, path string) error {
	files, err := ioutil.ReadDir(path)
	if nil != err {
		return err
	}

	for _, f := range files {
		if true == f.IsDir() {
			continue
		}
		*fileList = append(*fileList, fmt.Sprint(path, "/", f.Name()))
	}
	return nil
}

func extChecker(path string, whiteList []string) bool {
	for _, v := range whiteList {
		if v == filepath.Ext(strings.TrimSpace(path)) {
			return true
		}
	}
	return false
}

/////////////////////////////////////////////////////////////////////////
// FileCopy_s : file copy with temporary extension
/////////////////////////////////////////////////////////////////////////
func FileCopy_s(src string, dst string) (int64, error) {
	sourceFileStat, err := os.Stat(src)
	if err != nil {
		return 0, err
	}
	if !sourceFileStat.Mode().IsRegular() {
		return 0, fmt.Errorf("%s is not a regular file", src)
	}

	source, err := os.Open(src)
	if err != nil {
		return 0, err
	}
	defer source.Close()

	tmp := dst + ".lock"
	destination, err := os.Create(tmp)
	if err != nil {
		return 0, err
	}
	defer destination.Close()

	nBytes, err := io.Copy(destination, source)
	err = os.Rename(tmp, dst)

	return nBytes, err
}
