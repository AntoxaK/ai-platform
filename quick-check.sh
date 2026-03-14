#!/bin/bash
# AI Platform — Health Check

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLATFORM_VERSION=$(cat "$SCRIPT_DIR/VERSION" 2>/dev/null || echo "dev")

echo "═══════════════════════════════════════════════"
echo "  AI Platform v${PLATFORM_VERSION} — Health Check"
echo "═══════════════════════════════════════════════"
echo ""

# ComfyUI
if curl -s http://127.0.0.1:7821/system_stats > /dev/null 2>&1; then
    echo "✓ ComfyUI:  running (http://127.0.0.1:7821)"
else
    echo "✗ ComfyUI:  not responding"
fi

# SwarmUI
if docker compose ps swarmui | grep -q "Up"; then
    echo "✓ SwarmUI:  running (http://127.0.0.1:7801)"
else
    echo "✗ SwarmUI:  not running"
fi

# GPU
if nvidia-smi > /dev/null 2>&1; then
    GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -1)
    echo "✓ GPU:      $GPU_NAME"
else
    echo "✗ GPU:      not detected"
fi

echo ""
echo "═══════════════════════════════════════════════"
echo ""
echo "📦 Checking models via ComfyUI API:"
echo ""

curl -s http://127.0.0.1:7821/object_info 2>&1 | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    checkpoints = data.get('CheckpointLoaderSimple', {}).get('input', {}).get('required', {}).get('ckpt_name', [[]])[0]
    vae_list = data.get('VAELoader', {}).get('input', {}).get('required', {}).get('vae_name', [[]])[0]
    lora_list = data.get('LoraLoader', {}).get('input', {}).get('required', {}).get('lora_name', [[]])[0]

    print(f'  Checkpoints: {len(checkpoints)} models')
    print(f'  VAE:         {len(vae_list)} models')
    print(f'  LoRA:        {len(lora_list)} adapters')
    print('')
    print(f'  Total:       {len(checkpoints) + len(vae_list) + len(lora_list)} files')
except:
    print('  ⚠ Unable to retrieve model list')
    print('  ComfyUI is still loading or not responding')
" 2>&1

echo ""
echo "═══════════════════════════════════════════════"
echo ""
echo "🌐 Web interfaces:"
echo "   SwarmUI:  http://127.0.0.1:7801"
echo "   ComfyUI:  http://127.0.0.1:7821"
echo ""
echo "📖 Documentation:"
echo "   cat docs/MODELS_CHECK.md              # Check installed models"
echo "   cat docs/HOW_TO_USE_PRESETS.md        # How to use presets"
echo "   cat docs/CIVITAI_GUIDE.md             # Model download guide"
echo "   cat docs/VIDEO_GENERATION.md          # Video generation (detailed)"
echo "   cat docs/COMFYUI_VIDEO_QUICK_START.md # 🎬 Quick start for video"
echo "   cat docs/ERRORS_EXPLAINED.md          # Troubleshooting errors"
echo ""
