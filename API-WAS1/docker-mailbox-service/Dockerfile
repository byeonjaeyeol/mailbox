FROM bsquarelab/upost-node
MAINTAINER ERICKAHN <alwayswinners@gmail.com>

COPY . /home/blab

WORKDIR /home/blab/mailbox-service

RUN npm install

#RUN npm install -g nodemon

EXPOSE 8080
EXPOSE 4000

CMD node index.js
#CMD npm run-script test
#CMD ["npm", "test"]