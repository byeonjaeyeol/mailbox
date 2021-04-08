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
$ go build -o build/IljariAgent IljariAgent/main.go
$ go build -o build/interface_1.0.0.0 interface/src/main.go

```
