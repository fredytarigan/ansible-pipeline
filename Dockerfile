FROM golang:alpine AS builder 

WORKDIR /app

COPY main.go /app/

RUN apk add --update --no-cache; \
    apk add git; \
    go get gopkg.in/src-d/go-git.v4; \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o pipeline main.go


FROM alpine:latest

LABEL MAINTAINER="Fredy Samuel B. Tarigan"

COPY --from=builder /app/pipeline /usr/local/bin/pipeline

RUN apk add --update --no-cache; \
    apk add --no-cache git curl jq python3 python3-dev bash openssh nodejs npm py3-virtualenv; \
    pip3 install --upgrade pip; \
    apk add --no-cache --virtual .build-deps gcc musl-dev alpine-sdk libffi-dev openssl-dev; \
    pip3 install ansible; \
    pip3 install hvac; \
    pip3 install hvac[parser]; \
    pip3 install python-consul; \
    pip3 install yamllint; \
    pip3 install pylint; \
    pip3 install molecule[lint]; \
    pip3 install docker; \
    apk del .build-deps;