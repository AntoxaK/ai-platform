# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Local, offline-first AI image generation platform combining SwarmUI (.NET 8 web frontend) with ComfyUI (Python inference backend). Designed for GPU-accelerated image generation with NVIDIA RTX support.

## Architecture

### Hybrid Architecture

```
Host System:
  └── ComfyUI (Port 7821)     ← Image generation backend
          └── GPU Inference   ← Direct CUDA acceleration

Docker Compose:
  ├── SwarmUI (Port 7801)     ← .NET web UI (host network mode)
  │       └── ComfyUI API     ← http://127.0.0.1:7821
  │
  └── Ollama (Port 11434)     ← LLM inference [Docker]
          └── GPU Inference   ← Shared RTX 4070 (NVIDIA Container Toolkit)
```

**Key relationships:**
- ComfyUI runs on **host** for direct GPU access (image generation)
- Ollama runs in **Docker** with GPU passthrough (LLM inference)
- SwarmUI runs in **Docker** and connects via API to both services
- Image models stored in `models/`, LLM models in `ollama-models/`
- GPU VRAM shared automatically (Ollama unloads after 5min idle)

### Volume Strategy

| Mount | Type | Purpose |
|-------|------|---------|
| `models/` | Bind | User-managed ML models (SD, LoRA, VAE, ControlNet) |
| `output/` | Bind | Generated images with direct host access |
| `data/` | Bind | SwarmUI configuration and user data |
| `dlbackend/` | Bind | Local ComfyUI repository |
| `swarmui-dlnodes` | Named | ComfyUI custom nodes |
| `swarmui-extensions` | Named | SwarmUI extensions |

## Development Commands

### Lifecycle Management

```bash
./start.sh              # Start ComfyUI (host) + SwarmUI & Ollama (Docker)
./stop.sh               # Graceful shutdown (preserves all data)
./stop.sh --purge       # Full cleanup (removes named volumes)
```

### Docker Operations

```bash
docker compose up -d              # Start SwarmUI only
docker compose down               # Stop SwarmUI
docker compose logs -f swarmui    # Stream logs
docker compose restart swarmui    # Restart (refresh models)
```

### Direct ComfyUI Access (Development)

```bash
cd dlbackend/ComfyUI
source venv/bin/activate
python main.py --listen 127.0.0.1 --port 7821 --extra-model-paths-config extra_model_paths.yaml
```

## Ollama LLM Integration

### Overview

Ollama provides local LLM inference for coding assistance. Runs in Docker with NVIDIA GPU passthrough, sharing the RTX 4070 with ComfyUI.

### First-time Setup

```bash
# Start the platform
./start.sh

# Download coding model (~4.5GB)
docker exec -it ollama ollama pull qwen2.5-coder:7b

# Verify
docker exec ollama ollama list
```

### Configuration

Settings in `docker-compose.yml` (environment section):

| Variable | Value | Purpose |
|----------|-------|---------|
| `OLLAMA_KEEP_ALIVE` | `5m` | Unload model after 5min idle |
| `OLLAMA_MAX_LOADED_MODELS` | `1` | Single model in VRAM |
| `OLLAMA_FLASH_ATTENTION` | `1` | Memory optimization (~20-30% savings) |
| `OLLAMA_KV_CACHE_TYPE` | `q8_0` | 8-bit K/V cache |
| `CUDA_VISIBLE_DEVICES` | `0` | Explicit GPU selection |

### Recommended Models for RTX 4070 (12GB)

| Model | Parameters | VRAM | Use Case |
|-------|------------|------|----------|
| `qwen2.5-coder:7b` | 7B Q4_K_M | ~4.5GB | **Recommended** - code generation |
| `qwen2.5-coder:3b` | 3B Q4_K_M | ~2.2GB | Fast/lightweight alternative |
| `deepseek-coder:6.7b` | 6.7B Q4_K_M | ~4.2GB | Alternative coding model |
| `codellama:7b` | 7B Q4_K_M | ~4.5GB | Meta's coding model |

### API Usage

**Native Ollama API:**
```bash
# List models
curl http://127.0.0.1:11434/api/tags

# Generate code
curl -X POST http://127.0.0.1:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5-coder:7b",
    "prompt": "Write a Python function to calculate fibonacci",
    "stream": false
  }'
```

**OpenAI-Compatible API:**
```bash
curl -X POST http://127.0.0.1:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5-coder:7b",
    "messages": [
      {"role": "system", "content": "You are a coding assistant."},
      {"role": "user", "content": "Explain recursion"}
    ]
  }'
```

### Adding New LLM Models

```bash
# Pull model (runs inside Docker container)
docker exec -it ollama ollama pull <model-name>

# List available models
docker exec ollama ollama list

# Remove model
docker exec ollama ollama rm <model-name>
```

### VRAM Sharing Strategy

ComfyUI (host) and Ollama (Docker) share the GPU automatically:

1. **Ollama idle timeout** (`OLLAMA_KEEP_ALIVE=5m`): Model unloaded after 5 minutes
2. **Single model limit** (`OLLAMA_MAX_LOADED_MODELS=1`): Only one LLM in VRAM
3. **Flash Attention** (`OLLAMA_FLASH_ATTENTION=1`): ~20-30% VRAM savings
4. **Workflow**: Use LLM → wait 5min → VRAM freed for image generation

For heavy image generation sessions, manually unload LLM:
```bash
curl http://127.0.0.1:11434/api/generate -d '{"model":"qwen2.5-coder:7b","keep_alive":0}'
```

## Adding New Models

### Supported Model Architectures

| Architecture | Quality | Speed | VRAM (12GB) | Notes |
|--------------|---------|-------|-------------|-------|
| **SD 1.5** | ★★★☆☆ | Fast | ~4 GB ✓ | Найбільше моделей, легкий |
| **SD 2.x** | ★★★☆☆ | Fast | ~5 GB ✓ | Менш популярний |
| **SDXL** | ★★★★☆ | Medium | ~6-8 GB ✓ | **Рекомендовано** — баланс якості/швидкості |
| **SDXL Turbo/Lightning** | ★★★★☆ | Very Fast | ~6 GB ✓ | 1-4 кроки, швидка генерація |
| **Pony Diffusion** | ★★★★☆ | Medium | ~6-8 GB ✓ | Стилізовані, аніме |
| **Flux Schnell** | ★★★★★ | Fast | ~10 GB ✓ | Висока якість, швидкий |
| **Flux Dev** | ★★★★★ | Slow | ~12 GB ⚠ | Найвища якість, потребує FP8 |
| **SD 3 / SD 3.5** | ★★★★★ | Slow | ~12+ GB ⚠ | Нова архітектура, важкий |
| **PixArt-α/Σ** | ★★★★☆ | Medium | ~8-10 GB ✓ | Альтернатива SDXL |
| **Kolors** | ★★★★☆ | Medium | ~8 GB ✓ | Китайська модель |
| **AuraFlow** | ★★★★☆ | Medium | ~8 GB ✓ | Відкрита альтернатива Flux |

### Download Sources

| Source | URL | Що шукати |
|--------|-----|-----------|
| **Civitai** | https://civitai.com/models | Checkpoint, LoRA — найбільша спільнота |
| **Hugging Face** | https://huggingface.co/models?pipeline_tag=text-to-image | Офіційні релізи |
| **OpenModelDB** | https://openmodeldb.info | Upscalers |

### Civitai: Фільтри для пошуку

- **Base Model**: SD 1.5, SDXL 1.0, Pony, Flux.1 D/S, SD 3.5, etc.
- **Model Type**: Checkpoint, LoRA, VAE, Embedding, ControlNet
- **Download format**: Завжди `.safetensors` (безпечніше, швидше)

### Model Placement

| Тип моделі | Директорія | Civitai фільтр |
|------------|------------|----------------|
| **Основні моделі:** | | |
| Base checkpoints | `models/Stable-Diffusion/` | **Model Type:** Checkpoint |
| LoRA adapters | `models/Lora/` | **Model Type:** LoRA |
| LyCORIS (LoCon, LoHa) | `models/Lora/` | **Model Type:** LoCon, LoHa |
| VAE | `models/VAE/` | **Model Type:** VAE |
| Textual inversions | `models/Embeddings/` | **Model Type:** Embedding, Textual Inversion |
| **Контроль генерації:** | | |
| ControlNet | `models/ControlNet/` | **Model Type:** ControlNet |
| T2I-Adapter | `models/ControlNet/` | **Model Type:** Controlnet (T2I) |
| IP-Adapter | `models/ipadapter/` | **Model Type:** IP-Adapter |
| **Покращення якості:** | | |
| Upscalers (ESRGAN, etc.) | `models/upscale_models/` | OpenModelDB, Hugging Face |
| **Спеціалізовані моделі:** | | |
| AnimateDiff | `models/animatediff_models/` | **Model Type:** Motion Module |
| AnimateDiff LoRA | `models/animatediff_motion_lora/` | **Model Type:** AnimateDiff |
| InstantID | `models/instantid/` | **Model Type:** InstantID |
| PhotoMaker | `models/photomaker/` | **Model Type:** PhotoMaker |
| **Додаткові компоненти:** | | |
| CLIP models | `models/clip_vision/` | Hugging Face |
| Text encoders (Flux/SD3) | `models/text_encoders/` | Hugging Face |
| UNET моделі | `models/unet/` | — |
| Diffusion моделі | `models/diffusion_models/` | — |

#### Як фільтрувати на Civitai

**Крок 1: Виберіть Base Model** (залежно від того, що вам потрібно):
- `SD 1.5` — для легких, швидких моделей (4GB VRAM)
- `SDXL 1.0` — **рекомендовано** для балансу якості/швидкості (6-8GB VRAM)
- `Pony` — для стилізованих/аніме зображень (6-8GB VRAM)
- `Flux.1 D` або `Flux.1 S` — для найвищої якості (10-12GB VRAM)
- `SD 3` або `SD 3.5 Large` — нові моделі (12GB+ VRAM)

**Крок 2: Виберіть Model Type**:
- `Checkpoint` — основні моделі (ідуть у `Stable-Diffusion/`)
- `LoRA` — адаптери для модифікації стилю (ідуть у `Lora/`)
- `LoCon`, `LoHa` — різновиди LoRA (також у `Lora/`)
- `VAE` — декодери (ідуть у `VAE/`)
- `Embedding` — текстові інверсії (ідуть у `Embeddings/`)
- `ControlNet` — контроль композиції (ідуть у `ControlNet/`)

**Крок 3: Формат файлу**:
- Завжди обирайте `.safetensors` (безпечніше, швидше)
- Уникайте `.ckpt` та `.pt` (застарілі, менш безпечні)

### Flux моделі — додаткові компоненти

Flux потребує окремих файлів (завантажте з HuggingFace):
```
models/
├── Stable-Diffusion/
│   └── flux1-schnell.safetensors    # Основна модель
├── text_encoders/
│   ├── clip_l.safetensors           # CLIP-L encoder
│   └── t5xxl_fp8_e4m3fn.safetensors # T5-XXL (fp8 для економії VRAM)
└── VAE/
    └── ae.safetensors               # Flux VAE (autoencoder)
```

### Рекомендації для RTX 4070 (12GB)

**✓ Найкращий вибір:**
- SDXL моделі — оптимальний баланс
- SDXL Turbo/Lightning — швидка генерація
- Flux Schnell — найвища якість

**⚠ З обережністю:**
- Flux Dev — використовуйте FP8 квантизацію
- SD 3.5 Large — може потребувати offloading

**❌ Не рекомендовано:**
- SD 2.x — застарілий, менше спільнота
- Kandinsky — застарілий, складна установка
- DeepFloyd IF — потребує багато VRAM (20GB+)

### Детальний довідник архітектур

#### SD 1.5 (Stable Diffusion 1.5)
- **Civitai Base Model**: `SD 1.5`
- **Розмір**: 2-4 GB (pruned), 7 GB (full)
- **Роздільна здатність**: 512x512 (можна 768x768 з VAE)
- **Популярні моделі**: DreamShaper, Realistic Vision, MajicMix
- **Переваги**: Швидкий, велика бібліотека LoRA/Embeddings
- **Недоліки**: Нижча якість ніж SDXL/Flux

#### SDXL (Stable Diffusion XL)
- **Civitai Base Model**: `SDXL 1.0`
- **Розмір**: 6-7 GB
- **Роздільна здатність**: 1024x1024 (native), до 2048x2048
- **Популярні моделі**: Juggernaut XL, RealVisXL, DreamshaperXL
- **Переваги**: **Найкращий баланс якості/швидкості**, велика спільнота
- **Недоліки**: Повільніше за SD 1.5

#### SDXL Turbo/Lightning
- **Civitai Base Model**: `SDXL Turbo`, `SDXL Lightning`
- **Розмір**: 6-7 GB
- **Роздільна здатність**: 1024x1024
- **Особливості**: Генерація за 1-4 кроки (замість 20-30)
- **Популярні моделі**: SDXL Lightning, SDXL Turbo
- **Переваги**: Дуже швидко (3-5 секунд)
- **Недоліки**: Менше контролю (низький CFG)

#### Pony Diffusion
- **Civitai Base Model**: `Pony`
- **Розмір**: 6-7 GB
- **Роздільна здатність**: 1024x1024
- **Популярні моделі**: Pony Diffusion V6, Autism Mix
- **Переваги**: Відмінно для аніме, furry, стилізованих зображень
- **Недоліки**: Специфічні теги (Danbooru format)

#### Flux Schnell
- **Civitai Base Model**: `Flux.1 S`
- **Розмір**: ~24 GB (модель + text encoders + VAE)
  - Main model: ~10 GB
  - CLIP-L: 235 MB
  - T5-XXL (FP8): ~4.6 GB
  - VAE: ~335 MB
- **Роздільна здатність**: 1024x1024, підтримка будь-яких розмірів
- **Популярні моделі**: Flux.1 Schnell (офіційна)
- **Переваги**: **Найвища якість**, 4 кроки, чудове розуміння промптів
- **Недоліки**: Великий розмір, потребує додаткові файли

#### Flux Dev
- **Civitai Base Model**: `Flux.1 D`
- **Розмір**: ~24 GB (аналогічно Schnell)
- **Роздільна здатність**: 1024x1024, підтримка будь-яких розмірів
- **Популярні моделі**: Flux.1 Dev (офіційна), Flux Realism LoRA
- **Переваги**: **Абсолютна найвища якість**, точне відтворення промптів
- **Недоліки**: Повільний (25+ кроків), 12GB VRAM (використовуйте FP8)

#### SD 3 / SD 3.5
- **Civitai Base Model**: `SD 3`, `SD 3.5 Large`, `SD 3.5 Medium`
- **Розмір**:
  - SD 3.5 Large: ~12 GB
  - SD 3.5 Medium: ~5 GB
- **Роздільна здатність**: 1024x1024+
- **Переваги**: Нова архітектура, краще розуміння тексту
- **Недоліки**: Менше моделей на Civitai, потребує більше VRAM

#### Інші архітектури

**PixArt-α / PixArt-Σ**
- **Розмір**: 8-10 GB
- **Особливості**: Альтернатива SDXL, менше ресурсів
- **Доступність**: В основному Hugging Face

**Kolors**
- **Розмір**: ~8 GB
- **Особливості**: Китайська модель, добре працює з ієрогліфами
- **Доступність**: Hugging Face

**AuraFlow**
- **Розмір**: ~8 GB
- **Особливості**: Відкрита альтернатива Flux
- **Доступність**: Hugging Face

### Додаткові типи моделей

#### LoRA (Low-Rank Adaptation)
- **Розмір**: 10-200 MB
- **Застосування**: Зміна стилю, додавання персонажів, покращення деталей
- **Популярні категорії**:
  - Style LoRAs (аніме, реалізм, арт стилі)
  - Character LoRAs (конкретні персонажі)
  - Concept LoRAs (поза, освітлення, деталі)
  - NSFW LoRAs (дорослий контент)
- **Використання**: Weight 0.5-1.0 (експериментуйте)

#### VAE (Variational Autoencoder)
- **Розмір**: 300-800 MB
- **Застосування**: Покращує якість кольорів, різкість
- **Популярні моделі**:
  - `sdxl_vae.safetensors` — для всіх SDXL моделей
  - `vae-ft-mse-840000-ema-pruned.safetensors` — для SD 1.5
  - `ae.safetensors` — для Flux
- **Примітка**: Багато моделей мають вбудований VAE (baked-in)

#### ControlNet
- **Розмір**: 1-3 GB
- **Застосування**: Контроль композиції через:
  - Canny (контури)
  - Depth (глибина)
  - OpenPose (скелет людини)
  - Scribble (малюнки)
  - Normal map (освітлення)
- **Доступність**: Civitai, Hugging Face
- **Примітка**: Потрібна окрема модель для кожного типу контролю

#### Embeddings / Textual Inversions
- **Розмір**: 10-100 KB
- **Застосування**: Додавання концептів через ключові слова
- **Популярні**: EasyNegative, BadDream, FastNegative (негативні промпти)
- **Використання**: Просто вкажіть назву у промпті

#### IP-Adapter
- **Розмір**: 200 MB - 2 GB
- **Застосування**: Перенесення стилю з референсного зображення
- **Потрібно**: CLIP Vision model (автоматично завантажується)

#### AnimateDiff
- **Розмір**: 1-2 GB (motion module) + 100-300 MB (LoRA)
- **Застосування**: Генерація анімацій/відео
- **Примітка**: Потребує спеціальні workflow у ComfyUI

### After Adding Models

**Крок 1: Покласти файл у правильну папку**
```
models/Stable-Diffusion/  ← для checkpoints (.safetensors)
models/Lora/              ← для LoRA
models/VAE/               ← для VAE
```

**Крок 2: Оновити список моделей**

Варіант A — через веб-інтерфейс (рекомендовано):
1. Відкрити http://127.0.0.1:7801
2. Внизу зліва: **Server** → **Utilities** → **Refresh Models**

Варіант B — через термінал:
```bash
docker compose restart swarmui
```

**Крок 3: Вибрати модель**
1. У SwarmUI натиснути на поле **Model** (зверху)
2. Знайти нову модель у списку
3. Клікнути для вибору

**Примітка:** ComfyUI перезапускати НЕ потрібно — він автоматично бачить нові файли у папках моделей.

## Model Organization

```
models/
├── Stable-Diffusion/   # Base models (SD1.5, SDXL, Flux) - text-to-image
├── diffusion_models/   # Specialized diffusion models (SVD - image-to-video)
├── Lora/               # LoRA adapters
├── VAE/                # VAE models
├── ControlNet/         # ControlNet models
├── Embeddings/         # Textual inversions
├── clip_vision/        # CLIP vision models
├── text_encoders/      # Text encoding models
├── upscale_models/     # ESRGAN, etc.
├── ipadapter/          # IP-Adapter models
├── animatediff_models/ # AnimateDiff motion modules
└── animatediff_motion_lora/ # AnimateDiff LoRA
```

**Important Notes:**
- **Stable-Diffusion/** contains only text-to-image checkpoints (8 models)
- **diffusion_models/** contains SVD for video generation (1 model, 9GB)
- SVD does NOT appear in SwarmUI model list (use via ComfyUI workflows)
- See `VIDEO_GENERATION.md` for SVD usage instructions

## Ports

| Port | Service | Notes |
|------|---------|-------|
| 7801 | SwarmUI Web UI | Docker, main access point |
| 7821 | ComfyUI | Host-based, image generation |
| 11434 | Ollama | Docker, LLM inference |

## Key Configuration

### extra_model_paths.yaml

Located at `dlbackend/ComfyUI/extra_model_paths.yaml`. Uses **relative paths** from ComfyUI directory:

```yaml
ai_platform:
    base_path: ../../models    # Relative to dlbackend/ComfyUI
    checkpoints: Stable-Diffusion
    loras: Lora
    vae: VAE
    # ... etc
```

### Backends.fds

SwarmUI backend configuration at `data/Backends.fds`:
- Type: `comfyui_api` (connects to running ComfyUI)
- Address: `http://127.0.0.1:7821`

## GPU Configuration

- **Target**: NVIDIA RTX 4070 (12GB VRAM)
- **Runtime**: nvidia-docker with GPU reservation
- **Optimization**: FP16 inference, memory-efficient attention
- **CUDA**: 12.1 (PyTorch cu121)

## Technology Stack

| Layer | Technology |
|-------|------------|
| Frontend | SwarmUI (.NET 8, C#, JavaScript) |
| Backend | ComfyUI (Python 3.12, PyTorch 2.5.1) |
| Database | LiteDB (embedded) |
| Container | Docker with NVIDIA runtime |
| GPU | CUDA 12.1 + cuDNN |

## Troubleshooting

```bash
# GPU not detected
nvidia-smi

# ComfyUI not responding
tail -f /tmp/comfyui.log

# Ollama not responding
docker compose logs ollama
curl http://127.0.0.1:11434/api/tags  # Test API

# Restart everything
./stop.sh && ./start.sh

# Fresh start (preserves models)
./stop.sh --purge && ./start.sh

# Check model paths
cat dlbackend/ComfyUI/extra_model_paths.yaml

# VRAM issues (unload LLM for image generation)
curl http://127.0.0.1:11434/api/generate -d '{"model":"qwen2.5-coder:7b","keep_alive":0}'

# Check Ollama container health
docker inspect --format='{{.State.Health.Status}}' ollama
```

## Logs

| Service | Command |
|---------|---------|
| ComfyUI | `tail -f /tmp/comfyui.log` |
| SwarmUI | `docker compose logs -f swarmui` |
| Ollama | `docker compose logs -f ollama` |
