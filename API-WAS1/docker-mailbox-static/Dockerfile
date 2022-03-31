FROM bsquarelab/upost-node
MAINTAINER ERICKAHN <alwayswinners@gmail.com>

COPY . /home/blab

WORKDIR /home/blab/static

RUN npm install

EXPOSE 8081

CMD node server.js