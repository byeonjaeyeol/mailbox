package FileUtils

import (
	"bytes"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"time"
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Create Directory by File Path - Recursive
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func PreCreatePath(path string) error {
	dir := filepath.Dir(path)
	if _, serr := os.Stat(dir); nil != serr {
		merr := os.MkdirAll(dir, os.ModePerm)
		if nil != merr {
			return merr
		}
	} else {
		return serr
	}
	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Write File - Append
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func WriteFile_Append(path string, text string) error {
	fi, err := os.OpenFile(path, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
	if nil != err {
		return err
	}
	defer fi.Close()
	fi.WriteString(text)
	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Write File - Create - File Must Not Exist
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func WriteFile_Create(path string, text string) error {
	fi, err := os.OpenFile(path, os.O_APPEND|os.O_CREATE|os.O_EXCL|os.O_WRONLY, 0666)
	if nil != err {
		return err
	}
	defer fi.Close()
	fi.WriteString(text)
	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Write File - Create - File Must Not Exist
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func WriteFile_CreateByBuffer(path string, buffer *bytes.Buffer) error {
	err := PreCreatePath(path)
	if nil != err {
		return err
	}

	fi, err := os.OpenFile(path, os.O_APPEND|os.O_CREATE|os.O_EXCL|os.O_WRONLY, 0666)
	if nil != err {
		return err
	}
	defer fi.Close()
	fi.Write(buffer.Bytes())
	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Remove File
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func RemoveFile(path string) error {
	err := os.Remove(path)
	if nil != err {
		return err
	}
	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Rename File
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func RenameFile(old string, new string) error {
	err := os.Rename(old, new)
	if nil != err {
		return err
	}
	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Get Directory List
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func GetDirList_r(dirList *[]string, path string) error {
	dirs, err := ioutil.ReadDir(path)
	if nil != err {
		return err
	}

	for _, d := range dirs {
		path := fmt.Sprint(path, "/", d.Name())
		if true == d.IsDir() {
			GetDirList_r(dirList, path)
			*dirList = append(*dirList, path)
		}
	}

	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Copy File
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func CopyFile(srcFile string, dstFile string, bufSize int) error {
	buf := make([]byte, bufSize)

	srcStat, err := os.Stat(srcFile)
	if nil != err {
		return err
	}
	if !srcStat.Mode().IsRegular() {
		return errors.New(srcFile + "is not a regular file")
	}

	src, err := os.Open(srcFile)
	if nil != err {
		return err
	}
	defer src.Close()

	dst, err := os.Create(dstFile)
	if nil != err {
		return err
	}
	defer dst.Close()

	for {
		n, err := src.Read(buf)
		if err != nil && err != io.EOF {
			return err
		}
		if n == 0 {
			break
		}

		if _, err := dst.Write(buf[:n]); err != nil {
			return err
		}
	}

	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Compare FileSize
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func CompareFileSize(srcFile string, bytes int64) bool {
	fileSize, err := GetFileSize(srcFile)
	if fileSize == bytes && nil == err {
		return true
	}
	return false
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Get FileSize
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func GetFileSize(srcFile string) (int64, error) {
	file, err := os.Stat(srcFile)
	if nil != err {
		return 0, err
	}
	return file.Size(), nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Get File Mod Date
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func GetFileModTime(srcFile string) (time.Time, error) {
	file, err := os.Stat(srcFile)
	if nil != err {
		return time.Time{}, err
	}
	return file.ModTime(), nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Get File Add Date
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func GetFileAfterDate(srcFile string, term int) (time.Time, error) {
	fileDate, err := GetFileModTime(srcFile)
	if nil != err {
		return time.Time{}, err
	}
	return fileDate.AddDate(0, 0, term), nil
}

func GetFileAfterTime(srcFile string, term int) (time.Time, error) {
	fileDate, err := GetFileModTime(srcFile)
	if nil != err {
		return time.Time{}, err
	}
	return fileDate.Add(time.Duration(term) * time.Second), nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Compare File Time
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func CompareFileTime(fileTime time.Time) bool {
	return fileTime.Before(time.Now())
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Backup File
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func BackupFile(filepath string, backupFile string, bufferSize int) error {
	err := PreCreatePath(backupFile)
	if nil != err {
		return err
	}

	err = CopyFile(filepath, backupFile+".lock", bufferSize)
	if nil != err {
		RemoveFile(backupFile + ".lock")
		return fmt.Errorf("FileUtils::BackupFile() error : %v, source : %v, target : %v", err, filepath, backupFile)
	}

	err = RemoveFile(filepath)
	if nil != err {
		return err
	}

	err = RenameFile(backupFile+".lock", backupFile)
	if nil != err {
		return err
	}

	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	sfolder
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func sfolder(fileList *[]string, path string) error {
	files, err := ioutil.ReadDir(path)
	if nil != err {
		return err
	}

	for _, f := range files {
		if true == f.IsDir() {
			sfolder(fileList, fmt.Sprint(path, "/", f.Name()))
			continue
		}
		*fileList = append(*fileList, fmt.Sprint(path, "/", f.Name()))
	}

	return nil
}

func sFolder_r(fileList *[]string, path string, whiteList []string) error {
	files, err := ioutil.ReadDir(path)
	if nil != err {
		return err
	}

	// get file list
	for _, f := range files {
		// when file attr is directory,
		if true == f.IsDir() {
			// recursively running
			sFolder_r(fileList, fmt.Sprint(path, "/", f.Name()), whiteList)
			continue
		}

		// check white list extension
		absFile := fmt.Sprint(path, "/", f.Name())
		if true == extChecker(absFile, whiteList) {
			*fileList = append(*fileList, absFile)
		}
	}

	return nil
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Get File List
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func GetFileList(fileList *[]string, path string) int {
	sfolder(fileList, path)
	return len(*fileList)
}

func GetFileList_Ext(fileList *[]string, path string, fileExt string) int {
	var whiteList []string
	whiteList = append(whiteList, fileExt)
	sFolder_r(fileList, path, whiteList)
	return len(*fileList)
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//	File check
/////////////////////////////////////////////////////////////////////////////////////////////////////////
func CheckFileExists(filePath string) bool {
	info, err := os.Stat(filePath)
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
}

func extChecker(path string, whiteList []string) bool {
	for _, v := range whiteList {
		if strings.EqualFold(v, filepath.Ext(strings.TrimSpace(path))) {
			return true
		}
	}
	return false
}
