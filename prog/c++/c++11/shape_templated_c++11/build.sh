#!/bin/bash
cmake -S . -B build
cmake --build build -j$(nproc) --target circle
