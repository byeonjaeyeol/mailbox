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

실제 개발서버 혹은 운영서버 배포를 위해 다음과 같이 빌드를 하여 해당 실행파일을 정해진 위치에 이동한다.
```
$ docker exec -it goenv bash
$ go build -o build/analyzer analyzer/main.go
$ go build -o build/analyzer.authorized analyzer-authorized/main.go
$ go build -o build/interface_1.0.0.0 interface/src/main.go
$ go build -o build/IljariAgent IljariAgent/main.go
$ go build -o build/collector_1.0.0.0 Collector/src/main.go
$ go build -o build/CollectAgent BlabAgent/main.go

```

개발을 위해 다음과 같이 각각의 플랫폼에서 빌드를 한 후에 해당 폴더에서 동작하여 각 기능에 대해 디버깅을 진행할 수 있다.
```
$ cd GoEnv/go
$ go build -o buildd/analyzer/analyzer analyzer/main.go
$ go build -o buildd/analyzer.authorized/analyzer.authorized analyzer-authorized/main.go
$ go build -o buildd/IljariAgent/IljariAgent IljariAgent/main.go
$ go build -o buildd/interface/interface interface/src/main.go
$ go build -o buildd/Collector/collector_1.0.0.0 Collector/src/main.go
$ go build -o buildd/CollectAgent BlabAgent/main.go
```

# Git Submodule
## init
초기에 프로젝트 만들 때 submodule을 등록해 놓기 위해서 필요한 작업이며 해당 작업으로 프로젝트에 타 git 프로젝트를 포함하여 제공할 수 있다. 그러나 git 프로젝트 각각의 관리는 각자 관리 된다. 
```
$ git submodule add https://github.com/kyehyukahn/interface.git interface

$ git submodule add https://github.com/kyehyukahn/interface.git
$ git submodule add https://github.com/bsquarelab/eDocHubApi.git
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
