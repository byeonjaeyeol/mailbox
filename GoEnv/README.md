# UPOST-GOENV
모바일우편함 GO 개발 및 빌드 서버

# Pre-requisite
to docker build
```
$ docker build -t bsquarelab/upost-goenv:latest .
$ docker build -t bsquarelab/upost-goenv:0.1 .
$ docker push bsquarelab/upost-goenv:0.1
$ docker pull bsquarelab/upost-goenv:0.1
```

# Build
compile an app inside the docker container
```
$ docker exec -it goenv bash
$ go build -o build/analyzer analyzer/main.go
$ go build -o build/interface_1.0.0.0 interface/src/main.go
$ go build -o build/IljariAgent IljariAgent/main.go

```

# Git Submodule
## init
초기에 프로젝트 만들 때 submodule을 등록해 놓기 위해서 필요한 작업이며 해당 작업으로 프로젝트에 타 git 프로젝트를 포함하여 제공할 수 있다. 그러나 git 프로젝트 각각의 관리는 각자 관리 된다. 
```
$ git submodule add https://github.com/kyehyukahn/interface.git interface

$ git submodule add https://github.com/kyehyukahn/interface.git
```
## commit
```
$ git status
$ git commit -m "Add submodule interface"
```
## re-clone (운영)
서브모듈이 포함된 프로젝트를 클론하면 서브모듈에 대한 해당 디렉토리가 비어 있다. 
서브 모듈의 내용을 가져오려면 다음과 같은 단계를 거쳐 서브모듈 프로젝트를 초기에 가져올 수 있다.
```
git submodule init
git submodule udpate
```

## delete
서버모듈 삭제는 조금 복잡하다.

.gitmoudules 파일을 열어 관련 서브모듈 내용을 삭제한다.
.git/config 파일을 열어서 관련 서브모듈 내용을 삭제한다.
git rm --cached <서브모듈폴더>
commit
