#!/usr/bin/env bash

ARGS=("$@" --listen 0.0.0.0 --port 3001)

export PYTHONUNBUFFERED=1
export XFORMERS_DISABLED=1
export FLASH_ATTENTION_FORCE_DISABLE=1
export PYTORCH_SDP_DISABLE_FLASH_ATTN=1
export PYTORCH_SDP_DISABLE_MEM_EFFICIENT_ATTN=1
export PYTORCH_SDP_DISABLE_HEURISTIC=1
export PYTORCH_SDP_DISABLE_FASTPATH=1
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
pip uninstall -y xformers
echo "Starting ComfyUI"
cd /workspace/ComfyUI
source venv/bin/activate
pip uninstall -y xformers


TCMALLOC="$(ldconfig -p | grep -Po "libtcmalloc.so.\d" | head -n 1)"
export LD_PRELOAD="${TCMALLOC}"
python3 main.py "${ARGS[@]}" > /workspace/logs/comfyui.log 2>&1 &
echo "ComfyUI started"
echo "Log file: /workspace/logs/comfyui.log"
deactivate
