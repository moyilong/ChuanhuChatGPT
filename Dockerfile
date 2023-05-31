FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04 as base

RUN sed -i \
    -e 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' \
    -e 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' \
    /etc/apt/sources.list
    
# Skip Debian 
ARG DEBIAN_FRONTEND=noninteractive

# Parallel build 
ARG MAX_JOBS=32

RUN apt update && \
    apt install -y --fix-missing \
    python3 python- is-python3 python3-pip \
    git build-essential cmake texlive-full latex-cjk-all 


RUN git clone https://github.com/GaiZhenbiao/ChuanhuChatGPT /src --depth 1 && \
    cd /src && \
    git submodule update --init -r && \
    rm -rfv .git && \
    cat requirements.txt requirements_advanced.txt | sort | grep -vE 'torch' | uniq > requirements-all.txt

WORKDIR /src


RUN --mount=type=cache,target=/root/.cache \
    pip3 install -r requirements-all.txt -i https://pypi.douban.com/simple/ && \
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

ENV dockerrun=yes
CMD ["python3", "-u", "ChuanhuChatbot.py","2>&1", "|", "tee", "/var/log/application.log"]
