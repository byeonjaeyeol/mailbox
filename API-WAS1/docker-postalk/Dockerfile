FROM bsquarelab/upost-node
MAINTAINER ERICKAHN <alwayswinners@gmail.com>

COPY . /home/tilon

WORKDIR /home/tilon/postalk


RUN npm install

EXPOSE 8080
EXPOSE 4000

CMD node index.js