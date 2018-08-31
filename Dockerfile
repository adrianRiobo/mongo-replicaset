#golang version:1.11.0-alpine3.8
FROM golang@sha256:dc6ec3db081a5d2a6425a648720fd1c8888a138cb59e6aeb301174de0c99c5cb AS exporter-builder

#Clean up multi stage
LABEL disposable=true

ENV EXPORTER_URL=https://github.com/percona/mongodb_exporter/archive \
    EXPORTER_VERSION=0.6.1

ENV EXPORTER_PATH $GOPATH/src/github.com/percona

RUN apk --update add build-base git openssh \
    && wget $EXPORTER_URL/$EXPORTER_VERSION.tar.gz -P /tmp \
    && mkdir -p $EXPORTER_PATH \
    && tar -xzvf /tmp/$EXPORTER_VERSION.tar.gz -C $EXPORTER_PATH \
    && mv $EXPORTER_PATH/mongodb_exporter-$EXPORTER_VERSION $EXPORTER_PATH/mongodb_exporter \
    && cd $EXPORTER_PATH/mongodb_exporter \
    && make build

#mongo version: 4.0.1-xenial
FROM mongo@sha256:bf2281831947dbbce14d4ebba4378ba599bf4b889f86d3af7070c4288ae53f3a

LABEL maintainer "Adrian Riobo Lorenzo <adrian.riobo.lorenzo@google.com>"

COPY --from=exporter-builder /go/src/github.com/percona/mongodb_exporter/mongodb_exporter /usr/local/bin/ 

ENV COORDINATOR false

RUN apt-get update -y \
    && apt-get install -y gettext-base

#ENV PRIMARY 
#ENV SECONDARY_01 
#ENV SECONDARY_02

COPY init.sh /docker-entrypoint-initdb.d/
COPY rs_initiate.js.template /tmp

CMD ["--replSet", "rs0", "--bind_ip_all" ]

#Exporter port
EXPOSE 9216
