FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04 as base

RUN apt update && \
    apt install -y python3 python-is-python3

FROM base as build

RUN apt install git build-essential


WORKDIR /src

RUN git clone https://github.com/GaiZhenbiao/ChuanhuChatGPT /src/ --depth 1 && \
    rm -rfv .git



FROM base 

ENV dockerrun=yes
CMD ["python3", "-u", "ChuanhuChatbot.py","2>&1", "|", "tee", "/var/log/application.log"]
