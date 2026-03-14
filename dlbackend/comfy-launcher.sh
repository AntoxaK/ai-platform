#!/bin/bash
# Wrapper script to run ComfyUI with venv

cd /SwarmUI/dlbackend/ComfyUI
source venv/bin/activate
exec python main.py "$@"
