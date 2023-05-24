#!/bin/bash

archs=linux/amd64

docker buildx build --push \
        --platform $archs \
        --tag registry.cn-hangzhou.aliyuncs.com/zephyruse/chuanghu-chatgpt \
        . || exit -1
