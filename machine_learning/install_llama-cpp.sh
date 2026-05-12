#!/bin/bash

if [ ! command -v hf &>/dev/null ]; then
  curl -LsSf https://hf.co/cli/install.sh | bash
fi

if [ ! -d "$~/Models" ]; then
  mkdir -p ~/Models
  mkdir ~/Models/qwen && cd ~/Models/qwen
  hf download ggml-org/Qwen3.5-0.8B-Base-GGUF
fi

# https://github.com/ggml-org/llama.cpp/blob/master/docs/docker.md

docker run -v ~/Models:/models ghcr.io/ggml-org/llama.cpp:full --all-in-one "/models/" 7B
docker run -it --rm -v ~/Models:/models --entrypoint /app/llama-cli ghcr.io/ggml-org/llama.cpp:light -m /models/qwen/Qwen3.5-0.8B-Base-GGUF
