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
    apt install -y --fix-missing python3 python-is-python3 python3-pip  && \
    apt install -y --fix-missing git build-essential cmake 
    # apt install -y --fix-missing texlive-full latex-cjk-all 

RUN git clone https://github.com/GaiZhenbiao/ChuanhuChatGPT /src --depth 1 && \
    cd /src && \
    git submodule update --init -r

WORKDIR /src

# -i https://pypi.douban.com/simple/  
RUN --mount=type=cache,target=/root/.cache \
    pip3 install -U setuptools && \
    pip3 install -r requirements.txt && \ 
    pip3 install -r requirements_advanced.txt && \ 
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

ENV dockerrun=yes
CMD ["python3", "-u", "ChuanhuChatbot.py","2>&1", "|", "tee", "/var/log/application.log"]
