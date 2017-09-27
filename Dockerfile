FROM ubuntu:16.04

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN ./bin/install
