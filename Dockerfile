FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04 as base

RUN sed -i \
        -e 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' \
        -e 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' \
        /etc/apt/sources.list

RUN apt update && \
    apt install -y python3 python-is-python3 python3-pip \
                    git build-essential cmake


RUN git clone https://github.com/GaiZhenbiao/ChuanhuChatGPT /src --depth 1 && \
    rm -rfv .git

WORKDIR /src

RUN --mount=type=cache,target=/root/.cache \
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
RUN --mount=type=cache,target=/root/.cache \
    pip3 install -r requirements.txt
RUN --mount=type=cache,target=/root/.cache \
    pip3 install -r requirements_advanced.txt 

ENV dockerrun=yes
CMD ["python3", "-u", "ChuanhuChatbot.py","2>&1", "|", "tee", "/var/log/application.log"]
