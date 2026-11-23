#!/bin/sh

docker run -d --rm -v ~/Models:/models -p 8080:8080 --entrypoint /app/llama-server ghcr.io/ggml-org/llama.cpp:server -m /models/qwen/Qwen3.5-0.8B-Base-Q4_0.gguf --host 0.0.0.0

sleep 8

curl http://localhost:8080/health; echo
curl http://localhost:8080/v1/models; echo

curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Qwen3.5-0.8B-Base-Q4_0",
    "messages": [
      {"role":"system","content":"You are a helpful assistant"},
      {"role":"user","content":"Hello!"}
    ],
    "max-tokens": 1024,
    "temperature": 0.7
  }'

echo

