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

to start the instance for go build
```
$ docker-compose -f docker-compose-go.yml up -d
```

```
$ docker exec -it goenv bash
$ go build -o build/analyzer analyzer/main.go
$ go build -o build/interface_1.0.0.0 interface/src/main.go
$ go build -o build/IljariAgent IljariAgent/main.go

```

# Git Submodule
## init
```
$ git submodule add https://github.com/kyehyukahn/interface.git interface

$ git submodule add https://github.com/kyehyukahn/interface.git
```
## commit
```
$ git status
$ git commit -m "Add submodule interface"
```
## re-clone
서브모듈이 포함된 프로젝트를 클론하면 해당 디렉토리가 비어 있다. 서브 모듈의 내용을 가져오려면
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
