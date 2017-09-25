FROM ubuntu:16.04

RUN apt-get update && apt-get -y upgrade && apt-get -y install wget

# Install Mitamae https://github.com/itamae-kitchen/mitamae
RUN wget https://github.com/itamae-kitchen/mitamae/releases/download/v1.5.1/mitamae-x86_64-linux -O /bin/mitamae
RUN chmod 777 /bin/mitamae

RUN mkdir /app
COPY ./main /app
WORKDIR /app
