package AutoRemove

import (
	"fmt"

	"../../common/Logger"
	"../FileUtils"
)

func (ri *rmInst) removeFile() {
	remover(ri.removePath, ri.removeTerm)
}

func autoRemove(fileList []string, term int) {
	for _, removeFile := range fileList {
		afterDate, err := FileUtils.GetFileAfterDate(removeFile, term)
		if nil != err {
			Logger.WriteLog("remove", 10, fmt.Errorf("Failed removeFile::AutoRemove::removeFile()::autoRemove()::FileUtils::GetFileAfterDate() : %v, removeFile : %v", err, removeFile))
			continue
		}

		if !FileUtils.CompareFileTime(afterDate) {
			// do nothing
		} else {
			err = FileUtils.RemoveFile(removeFile)
			if nil != err {
				Logger.WriteLog("remove", 10, fmt.Errorf("Failed removeFile::AutoRemove::removeFile()::autoRemove()::FileUtils::RemoveFile() : %v, removeFile : %v", err, removeFile))
				continue
			}
		}
	}
}

func remover(path string, term int) {
	var fileList []string
	FileUtils.GetFileList(&fileList, path)
	autoRemove(fileList, term)
}
