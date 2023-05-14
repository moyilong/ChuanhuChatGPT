FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04 as base

RUN apt update && \
    apt install -y python3 python-is-python3 python3-pip

FROM base as build

RUN apt install -y git build-essential


WORKDIR /src

RUN git clone https://github.com/GaiZhenbiao/ChuanhuChatGPT /src --depth 1 && \
    rm -rfv .git

FROM base 

WORKDIR /src

COPY --from=build /src /src

RUN pip3 install -r requirements.txt
RUN pip3 install -r requirements_advanced.txt 

ENV dockerrun=yes
CMD ["python3", "-u", "ChuanhuChatbot.py","2>&1", "|", "tee", "/var/log/application.log"]
