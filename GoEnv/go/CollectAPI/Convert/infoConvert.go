package Convert

import (
	"fmt"
	"strconv"
	"strings"
	"time"

	"../Utils"
)

func (ci *convInst) getPathByExt(templateCode string, ext string) string {
	return fmt.Sprintf("%v/%v/%v/%v/%v_%v_%v.%v", ci.optionDirectory, ci.orgCode, ci.deptCode, templateCode,
		ci.orgCode, ci.deptCode, templateCode, ext)
}

func (ci *convInst) getDoneDate() ([]string, error) {
	doneDate, err := Utils.GetSliceFromFile(ci.getPathByExt(ILJARI_COMMON_CODE, EXT_DONE), "\r\n")
	if nil != err {
		return nil, fmt.Errorf("load doneDate error : %v, baseFile : %v", err, ci.getPathByExt(ILJARI_COMMON_CODE, EXT_DONE))
	}
	return doneDate, nil
}

func (ci *convInst) getCollectDoneDate() ([]string, error) {
	doneDate, err := Utils.GetSliceFromFile(ci.getPathByExt(BLAB_COLLECT_COMMON_CODE, EXT_DONE), "\r\n")
	if nil != err {
		return nil, fmt.Errorf("load doneDate error : %v, baseFile : %v", err, ci.getPathByExt(BLAB_COLLECT_COMMON_CODE, EXT_DONE))
	}
	return doneDate, nil
}

func (ci *convInst) getDataInfo(samFile string) ([]string, error) {
	samData, err := Utils.GetSliceFromFile(samFile, "\n")
	if nil != err {
		return nil, fmt.Errorf("load samFile error : %v", err)
	}
	return samData, nil
}

func (ci *convInst) setDoneDate() error {
	err := Utils.WriteDone(ci.getPathByExt(ILJARI_COMMON_CODE, EXT_DONE))
	if nil != err {
		return fmt.Errorf("WriteDone() : %v", err)
	}
	return nil
}

func (ci *convInst) setWebDoneDate(count int) error {
	err := Utils.WriteWebDone(ci.getPathByExt(BLAB_COMMON_CODE, EXT_DONE), strconv.Itoa(count))
	if nil != err {
		return fmt.Errorf("WriteDone() : %v", err)
	}
	return nil
}

func (ci *convInst) setCollectDoneDate(count int) error {
	err := Utils.WriteWebDone(ci.getPathByExt(BLAB_COLLECT_COMMON_CODE, EXT_DONE), strconv.Itoa(count))
	if nil != err {
		return fmt.Errorf("WriteDone() : %v", err)
	}
	return nil
}

func (ci *convInst) getBulkPath() string {
	t := time.Now()
	timeString := fmt.Sprintf("%v%v%v%v.%v", t.Format("20060102"), t.Hour(), t.Minute(), t.Second(), t.Nanosecond())

	return fmt.Sprintf("%v/%v/%v/%v_%v_%v.json.lock", ci.outputPath, ci.orgCode, ci.deptCode, ci.orgCode, ci.deptCode, timeString)
}

func (ci *convInst) getBackupPath(path string) string {
	return strings.Replace(path, ci.baseDirectory, ci.backupDirectory, -1)
}

func (ci *convInst) getTemplatePath(path string) string {
	return strings.Replace(path, ci.baseDirectory, ci.templateDirectory, 1)
}

func getPdfFileLastName(samFile string) string {
	var samFilePath []string
	var samFileFullName []string
	var samFileLastName string
	var ext string
	var pdfFileLastName string

	samFilePath = Utils.SplitDelimiter(samFile, "/")
	samFileFullName = Utils.SplitDelimiter(samFilePath[len(samFilePath)-1], DELIMITER_SAMFILE_NAME)
	samFileLastName = samFileFullName[len(samFileFullName)-1]
	ext = samFileLastName[len(samFileLastName)-4:]
	pdfFileLastName = strings.Replace(samFileLastName, ext, ".pdf", 1)

	return pdfFileLastName
}

func fetchPdfFilePath(pdfFileLastName string, pdfFileList []string) (string, bool) {
	var pdfFileFullPath string
	var bFind bool

	bFind = false
	for _, filePath := range pdfFileList {
		if strings.Contains(strings.ToLower(filePath), strings.ToLower(pdfFileLastName)) {
			pdfFileFullPath = filePath
			bFind = true
			break
		}
	}

	return pdfFileFullPath, bFind
}

func getPdfFileFullName(pdfFileFullPath string) string {
	pdfFilePath := Utils.SplitDelimiter(pdfFileFullPath, "/")
	return pdfFilePath[len(pdfFilePath)-1]
}
