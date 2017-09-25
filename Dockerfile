FROM ubuntu:16.04

RUN apt-get update && apt-get -y upgrade

RUN mkdir /app
COPY ./main /app
WORKDIR /app
