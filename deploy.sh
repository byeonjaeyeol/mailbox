echo "배포할 기능을 다음에서 골라 입력하세요."
echo "interface / analyzer / analyzer.authorized / collector"
echo "collect.agent / sync.agent / iljari.agent / all"
read deployment
echo "배포 기능은 $deployment 입니다."


function deplay_interface()
{
    docker exec goenv go build -o build/interface_1.0.0.0 interface/src/main.go
    if [ $? -eq 0 ];then 
        echo "interface 빌드를 완료하였습니다."
    else 
        echo "interface 빌드를 완료하지 못했습니다."
        exit 9;
    fi

    rm ./Service01/exec/interface/interface_1.0.0.0
    if [ $? -eq 0 ];then 
        echo "기존 interface 실행파일이 삭제되었습니다."
    else 
        echo "기존 interface 실행파일 삭제가 실패되었습니다."
        exit 9;
    fi
    rm ./Service02/exec/interface/interface_1.0.0.0
    if [ $? -eq 0 ];then 
        echo "기존 interface 실행파일이 삭제되었습니다."
    else 
        echo "기존 interface 실행파일 삭제가 실패되었습니다."
        exit 9;
    fi

    cp ./GoEnv/go/build/interface_1.0.0.0 ./Service01/exec/interface/interface_1.0.0.0
    cp ./GoEnv/go/build/interface_1.0.0.0 ./Service02/exec/interface/interface_1.0.0.0
    if [ $? -eq 0 ];then 
        echo "기존 interface 실행파일 배포가 완료되었습니다."
    else
        echo "기존 interface 실행파일 배포가 실패했습니다."
        exit 9;
    fi
}

deplay_interface