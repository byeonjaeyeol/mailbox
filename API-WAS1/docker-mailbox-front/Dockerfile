FROM bsquarelab/upost-node
MAINTAINER ERICKAHN <alwayswinners@gmail.com>

COPY . /home/blab

WORKDIR /home/blab/mailbox-front


RUN npm install
RUN npm rebuild node-sass
#RUN npm install -g nodemon

EXPOSE 3000

CMD npm run-script start
#CMD ["npm", "test"]