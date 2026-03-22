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
| **SD 1.5** | ★★★☆☆ | Fast | ~4 GB ✓ | Most models available, lightweight |
| **SD 2.x** | ★★★☆☆ | Fast | ~5 GB ✓ | Less popular |
| **SDXL** | ★★★★☆ | Medium | ~6-8 GB ✓ | **Recommended** — best quality/speed balance |
| **SDXL Turbo/Lightning** | ★★★★☆ | Very Fast | ~6 GB ✓ | 1-4 steps, fast generation |
| **Pony Diffusion** | ★★★★☆ | Medium | ~6-8 GB ✓ | Stylized, anime |
| **Flux Schnell** | ★★★★★ | Fast | ~10 GB ✓ | High quality, fast |
| **Flux Dev** | ★★★★★ | Slow | ~12 GB ⚠ | Highest quality, requires FP8 |
| **SD 3 / SD 3.5** | ★★★★★ | Slow | ~12+ GB ⚠ | New architecture, heavy |
| **PixArt-α/Σ** | ★★★★☆ | Medium | ~8-10 GB ✓ | SDXL alternative |
| **Kolors** | ★★★★☆ | Medium | ~8 GB ✓ | Chinese model |
| **AuraFlow** | ★★★★☆ | Medium | ~8 GB ✓ | Open Flux alternative |

### Download Sources

| Source | URL | What to Search For |
|--------|-----|-----------|
| **Civitai** | https://civitai.com/models | Checkpoints, LoRA — largest community |
| **Hugging Face** | https://huggingface.co/models?pipeline_tag=text-to-image | Official releases |
| **OpenModelDB** | https://openmodeldb.info | Upscalers |

### Civitai: Filtering Guide

- **Base Model**: SD 1.5, SDXL 1.0, Pony, Flux.1 D/S, SD 3.5, etc.
- **Model Type**: Checkpoint, LoRA, VAE, Embedding, ControlNet
- **Download format**: Always `.safetensors` (safer, faster)

### Model Placement

| Model Type | Directory | Civitai Filter |
|------------|-----------|----------------|
| **Base Models:** | | |
| Base checkpoints | `models/Stable-Diffusion/` | **Model Type:** Checkpoint |
| LoRA adapters | `models/Lora/` | **Model Type:** LoRA |
| LyCORIS (LoCon, LoHa) | `models/Lora/` | **Model Type:** LoCon, LoHa |
| VAE | `models/VAE/` | **Model Type:** VAE |
| Textual inversions | `models/Embeddings/` | **Model Type:** Embedding, Textual Inversion |
| **Generation Control:** | | |
| ControlNet | `models/ControlNet/` | **Model Type:** ControlNet |
| T2I-Adapter | `models/ControlNet/` | **Model Type:** Controlnet (T2I) |
| IP-Adapter | `models/ipadapter/` | **Model Type:** IP-Adapter |
| **Quality Enhancement:** | | |
| Upscalers (ESRGAN, etc.) | `models/upscale_models/` | OpenModelDB, Hugging Face |
| **Specialized Models:** | | |
| AnimateDiff | `models/animatediff_models/` | **Model Type:** Motion Module |
| AnimateDiff LoRA | `models/animatediff_motion_lora/` | **Model Type:** AnimateDiff |
| InstantID | `models/instantid/` | **Model Type:** InstantID |
| PhotoMaker | `models/photomaker/` | **Model Type:** PhotoMaker |
| **Additional Components:** | | |
| CLIP models | `models/clip_vision/` | Hugging Face |
| Text encoders (Flux/SD3) | `models/text_encoders/` | Hugging Face |
| UNET models | `models/unet/` | — |
| Diffusion models | `models/diffusion_models/` | — |

#### How to Filter on Civitai

**Step 1: Choose Base Model** (depending on your needs):
- `SD 1.5` — for lightweight, fast models (4GB VRAM)
- `SDXL 1.0` — **recommended** for quality/speed balance (6-8GB VRAM)
- `Pony` — for stylized/anime images (6-8GB VRAM)
- `Flux.1 D` or `Flux.1 S` — for highest quality (10-12GB VRAM)
- `SD 3` or `SD 3.5 Large` — new models (12GB+ VRAM)

**Step 2: Choose Model Type**:
- `Checkpoint` — base models (go to `Stable-Diffusion/`)
- `LoRA` — style adapters (go to `Lora/`)
- `LoCon`, `LoHa` — LoRA variants (also to `Lora/`)
- `VAE` — decoders (go to `VAE/`)
- `Embedding` — textual inversions (go to `Embeddings/`)
- `ControlNet` — composition control (go to `ControlNet/`)

**Step 3: File Format**:
- Always choose `.safetensors` (safer, faster)
- Avoid `.ckpt` and `.pt` (outdated, less secure)

### Flux Models — Additional Components

Flux requires separate files (download from HuggingFace):
```
models/
├── Stable-Diffusion/
│   └── flux1-schnell.safetensors    # Base model
├── text_encoders/
│   ├── clip_l.safetensors           # CLIP-L encoder
│   └── t5xxl_fp8_e4m3fn.safetensors # T5-XXL (fp8 for VRAM savings)
└── VAE/
    └── ae.safetensors               # Flux VAE (autoencoder)
```

### Recommendations for RTX 4070 (12GB)

**✓ Best Choices:**
- SDXL models — optimal balance
- SDXL Turbo/Lightning — fast generation
- Flux Schnell — highest quality

**⚠ Use with Caution:**
- Flux Dev — use FP8 quantization
- SD 3.5 Large — may require offloading

**❌ Not Recommended:**
- SD 2.x — outdated, less community
- Kandinsky — outdated, complex setup
- DeepFloyd IF — requires lots of VRAM (20GB+)

### Detailed Architecture Guide

#### SD 1.5 (Stable Diffusion 1.5)
- **Civitai Base Model**: `SD 1.5`
- **Size**: 2-4 GB (pruned), 7 GB (full)
- **Resolution**: 512x512 (up to 768x768 with VAE)
- **Popular Models**: DreamShaper, Realistic Vision, MajicMix
- **Advantages**: Fast, large LoRA/Embeddings library
- **Disadvantages**: Lower quality than SDXL/Flux

#### SDXL (Stable Diffusion XL)
- **Civitai Base Model**: `SDXL 1.0`
- **Size**: 6-7 GB
- **Resolution**: 1024x1024 (native), up to 2048x2048
- **Popular Models**: Juggernaut XL, RealVisXL, DreamshaperXL
- **Advantages**: **Best quality/speed balance**, large community
- **Disadvantages**: Slower than SD 1.5

#### SDXL Turbo/Lightning
- **Civitai Base Model**: `SDXL Turbo`, `SDXL Lightning`
- **Size**: 6-7 GB
- **Resolution**: 1024x1024
- **Features**: Generation in 1-4 steps (instead of 20-30)
- **Popular Models**: SDXL Lightning, SDXL Turbo
- **Advantages**: Very fast (3-5 seconds)
- **Disadvantages**: Less control (low CFG)

#### Pony Diffusion
- **Civitai Base Model**: `Pony`
- **Size**: 6-7 GB
- **Resolution**: 1024x1024
- **Popular Models**: Pony Diffusion V6, Autism Mix
- **Advantages**: Excellent for anime, furry, stylized images
- **Disadvantages**: Specific tags (Danbooru format)

#### Flux Schnell
- **Civitai Base Model**: `Flux.1 S`
- **Size**: ~24 GB (model + text encoders + VAE)
  - Main model: ~10 GB
  - CLIP-L: 235 MB
  - T5-XXL (FP8): ~4.6 GB
  - VAE: ~335 MB
- **Resolution**: 1024x1024, supports any size
- **Popular Models**: Flux.1 Schnell (official)
- **Advantages**: **Highest quality**, 4 steps, excellent prompt understanding
- **Disadvantages**: Large size, requires additional files

#### Flux Dev
- **Civitai Base Model**: `Flux.1 D`
- **Size**: ~24 GB (similar to Schnell)
- **Resolution**: 1024x1024, supports any size
- **Popular Models**: Flux.1 Dev (official), Flux Realism LoRA
- **Advantages**: **Absolute highest quality**, exact prompt reproduction
- **Disadvantages**: Slow (25+ steps), 12GB VRAM (use FP8)

#### SD 3 / SD 3.5
- **Civitai Base Model**: `SD 3`, `SD 3.5 Large`, `SD 3.5 Medium`
- **Size**:
  - SD 3.5 Large: ~12 GB
  - SD 3.5 Medium: ~5 GB
- **Resolution**: 1024x1024+
- **Advantages**: New architecture, better text understanding
- **Disadvantages**: Fewer models on Civitai, requires more VRAM

#### Other Architectures

**PixArt-α / PixArt-Σ**
- **Size**: 8-10 GB
- **Features**: SDXL alternative, fewer resources
- **Availability**: Mainly Hugging Face

**Kolors**
- **Size**: ~8 GB
- **Features**: Chinese model, works well with hieroglyphics
- **Availability**: Hugging Face

**AuraFlow**
- **Size**: ~8 GB
- **Features**: Open Flux alternative
- **Availability**: Hugging Face

### Additional Model Types

#### LoRA (Low-Rank Adaptation)
- **Size**: 10-200 MB
- **Use**: Style changes, add characters, enhance details
- **Popular Categories**:
  - Style LoRAs (anime, realism, art styles)
  - Character LoRAs (specific characters)
  - Concept LoRAs (poses, lighting, details)
- **Usage**: Weight 0.5-1.0 (experiment)

#### VAE (Variational Autoencoder)
- **Size**: 300-800 MB
- **Use**: Improve color quality, sharpness
- **Popular Models**:
  - `sdxl_vae.safetensors` — for all SDXL models
  - `vae-ft-mse-840000-ema-pruned.safetensors` — for SD 1.5
  - `ae.safetensors` — for Flux
- **Note**: Many models have built-in VAE (baked-in)

#### ControlNet
- **Size**: 1-3 GB
- **Use**: Control composition via:
  - Canny (contours)
  - Depth (depth map)
  - OpenPose (human skeleton)
  - Scribble (drawings)
  - Normal map (lighting)
- **Availability**: Civitai, Hugging Face
- **Note**: Separate model needed for each control type

#### Embeddings / Textual Inversions
- **Size**: 10-100 KB
- **Use**: Add concepts via keywords
- **Popular**: EasyNegative, BadDream, FastNegative (negative prompts)
- **Usage**: Just specify the name in your prompt

#### IP-Adapter
- **Size**: 200 MB - 2 GB
- **Use**: Transfer style from reference image
- **Required**: CLIP Vision model (auto-loaded)

#### AnimateDiff
- **Size**: 1-2 GB (motion module) + 100-300 MB (LoRA)
- **Use**: Generate animations/videos
- **Note**: Requires special workflows in ComfyUI

### After Adding Models

**Step 1: Place file in correct folder**
```
models/Stable-Diffusion/  ← for checkpoints (.safetensors)
models/Lora/              ← for LoRA
models/VAE/               ← for VAE
```

**Step 2: Update model list**

Option A — via web interface (recommended):
1. Open http://127.0.0.1:7801
2. Bottom left: **Server** → **Utilities** → **Refresh Models**

Option B — via terminal:
```bash
docker compose restart swarmui
```

**Step 3: Select model**
1. In SwarmUI click **Model** field (top)
2. Find new model in list
3. Click to select

**Note:** ComfyUI does NOT need to restart — it auto-detects new files in model folders.

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
- See `docs/VIDEO_GENERATION.md` for SVD usage instructions

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
