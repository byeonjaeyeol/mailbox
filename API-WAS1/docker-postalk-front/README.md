# upost-node-postalk-front
모바일 우편함 관리자 페이지 프론트

# Pre-requisite

도커 이미지 빌드
```
$ docker build -t bsquarelab/upost-node-postalk-front:0.1 .
```

to start the docker instance (stand alone)
```
$ docker run -p 3000:3000 --net=bridge -it bsquarelab/upost-node-postalk-front:0.1 bash
```

# production build
yarn build 이용하며 자세한 사항은 [README.md](./postalk-front/src/README.md) 파일을 참조

# API Path 변경
[config.js](./postalk-front/src/config.js)에서 원하는 경로로 설정  
default 는 NODE_ENV 가 development를 되어 있으며 localhost의 docker환경 기준으로 설정  
test-network(aws)의 주소는 15.165.68.163  
자세한 사항은 config.js 참조

