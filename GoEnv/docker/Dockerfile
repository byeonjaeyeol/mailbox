FROM amd64/golang:1.13

#WORKDIR /go/src/app
#COPY . .
COPY simple.sh /simple.sh

#RUN go get -d -v ./...
#RUN go install -v ./...
RUN go get -u github.com/go-sql-driver/mysql 
RUN go get -u github.com/pkg/sftp
RUN go get -u github.com/djimenez/iconv-go
RUN go get -u github.com/julienschmidt/httprouter

WORKDIR /go/upost

CMD /simple.sh