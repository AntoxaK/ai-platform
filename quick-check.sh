#!/bin/bash
# Швидка перевірка стану AI Platform

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLATFORM_VERSION=$(cat "$SCRIPT_DIR/VERSION" 2>/dev/null || echo "dev")

echo "═══════════════════════════════════════════════"
echo "  AI Platform v${PLATFORM_VERSION} — Швидка перевірка"
echo "═══════════════════════════════════════════════"
echo ""

# ComfyUI
if curl -s http://127.0.0.1:7821/system_stats > /dev/null 2>&1; then
    echo "✓ ComfyUI:  запущений (http://127.0.0.1:7821)"
else
    echo "✗ ComfyUI:  не відповідає"
fi

# SwarmUI
if docker compose ps swarmui | grep -q "Up"; then
    echo "✓ SwarmUI:  запущений (http://127.0.0.1:7801)"
else
    echo "✗ SwarmUI:  не запущений"
fi

# GPU
if nvidia-smi > /dev/null 2>&1; then
    GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -1)
    echo "✓ GPU:      $GPU_NAME"
else
    echo "✗ GPU:      не виявлено"
fi

echo ""
echo "═══════════════════════════════════════════════"
echo ""
echo "📦 Перевірка моделей через ComfyUI API:"
echo ""

curl -s http://127.0.0.1:7821/object_info 2>&1 | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    checkpoints = data.get('CheckpointLoaderSimple', {}).get('input', {}).get('required', {}).get('ckpt_name', [[]])[0]
    vae_list = data.get('VAELoader', {}).get('input', {}).get('required', {}).get('vae_name', [[]])[0]
    lora_list = data.get('LoraLoader', {}).get('input', {}).get('required', {}).get('lora_name', [[]])[0]
    
    print(f'  Checkpoints: {len(checkpoints)} моделей')
    print(f'  VAE:         {len(vae_list)} моделей')
    print(f'  LoRA:        {len(lora_list)} адаптерів')
    print('')
    print(f'  Всього:      {len(checkpoints) + len(vae_list) + len(lora_list)} файлів')
except:
    print('  ⚠ Не вдалося отримати список моделей')
    print('  ComfyUI ще завантажується або не відповідає')
" 2>&1

echo ""
echo "═══════════════════════════════════════════════"
echo ""
echo "🌐 Веб-інтерфейси:"
echo "   SwarmUI:  http://127.0.0.1:7801"
echo "   ComfyUI:  http://127.0.0.1:7821"
echo ""
echo "📖 Документація:"
echo "   cat MODELS_CHECK.md                  # Перевірка встановлених моделей"
echo "   cat HOW_TO_USE_PRESETS.md            # Як використовувати пресети"
echo "   cat CIVITAI_GUIDE.md                 # Довідник завантаження моделей"
echo "   cat VIDEO_GENERATION.md              # Генерація відео (детально)"
echo "   cat COMFYUI_VIDEO_QUICK_START.md     # 🎬 Швидкий старт для відео"
echo "   cat ERRORS_EXPLAINED.md              # Пояснення помилок у логах"
echo ""
