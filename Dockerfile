FROM ubuntu:20.04

LABEL software="BSbolt"
LABEL description="BSbolt is a tool for processing Bisulfide sequencing data"
LABEL maintainer="PacInfo"

RUN apt-get update && apt-get install software-properties-common -y && add-apt-repository ppa:deadsnakes/ppa && apt-get install python3.8 python3-pip libbz2-dev liblzma-dev -y
RUN apt install samtools -y 
RUN pip3 install bsbolt
RUN pip install pandas tabulate