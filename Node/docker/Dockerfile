FROM centos:7
MAINTAINER ERICKAHN <alwayswinners@gmail.com>

#RUN rm /etc/yum.repos.d/nodesource-el.repo

RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash -
RUN yum clean all && yum makecache fast
RUN yum install -y gcc-c++ make
RUN yum install -y nodejs

RUN node -v
RUN npm -v

RUN npm install pm2 -g

## use as a base and then add these 
#CMD ["node", "app.js"] by node 
#CMD ["pm2-runtime", "app.js"] by pm2