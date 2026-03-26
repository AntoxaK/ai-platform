# AI Platform

[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![GPU](https://img.shields.io/badge/GPU-RTX%204070%2012GB-76b900?logo=nvidia&logoColor=white)](.)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](docker-compose.yml)
[![ComfyUI](https://img.shields.io/badge/ComfyUI-submodule-orange)](dlbackend/ComfyUI)

Local offline-first AI platform for image generation and LLM inference.
Runs entirely on your hardware — no cloud required.

## Architecture

```
┌─────────────────────────────────────────────────┐
│                   Host System                   │
│                                                 │
│   ComfyUI :7821  ←──── GPU (RTX 4070 12GB)     │
│   Python / PyTorch    direct CUDA access        │
└──────────────┬──────────────────────────────────┘
               │ HTTP API (localhost)
┌──────────────▼──────────────────────────────────┐
│              Docker Compose                     │
│                                                 │
│   SwarmUI :7801  ──→  ComfyUI API               │
│   (.NET 8 Web UI)     image generation          │
│                                                 │
│   Ollama  :11434  ←── GPU passthrough           │
│   LLM inference       qwen2.5-coder:7b          │
└─────────────────────────────────────────────────┘
```

GPU VRAM is shared: Ollama unloads models after 5 min idle, freeing memory for image generation.

## Quick Start

**Prerequisites:** Docker + NVIDIA Container Toolkit + CUDA drivers

```bash
git clone --recurse-submodules https://github.com/AntoxaK/ai-platform.git
cd ai-platform
./start.sh
```

| Service | URL | Purpose |
|---------|-----|---------|
| SwarmUI | http://127.0.0.1:7801 | Web UI — image generation |
| ComfyUI | http://127.0.0.1:7821 | Node-based workflow editor |
| Ollama  | http://127.0.0.1:11434 | LLM API (OpenAI-compatible) |

```bash
./quick-check.sh  # Verify all services are healthy
./stop.sh         # Graceful shutdown
./stop.sh --purge # Full cleanup (removes volumes)
```

## First-time Setup

### 1. Build SwarmUI Docker image
```bash
docker build -t swarmui:production .
```

### 2. Download a coding model for Ollama
```bash
docker exec -it ollama ollama pull qwen2.5-coder:7b
```

### 3. Add image generation models
Place `.safetensors` files into the appropriate directory:

| Model type | Directory |
|------------|-----------|
| Checkpoints (SD, SDXL, Flux) | `models/Stable-Diffusion/` |
| LoRA adapters | `models/Lora/` |
| VAE | `models/VAE/` |
| ControlNet | `models/ControlNet/` |
| Text encoders (Flux/WAN) | `models/text_encoders/` |

See [MODELS_ATTRIBUTION.md](MODELS_ATTRIBUTION.md) for download sources and licenses.

## Supported Model Architectures

| Architecture | VRAM | Speed | Quality |
|--------------|------|-------|---------|
| SD 1.5 | ~4 GB | Fast | ★★★☆☆ |
| SDXL | ~6-8 GB | Medium | ★★★★☆ |
| Flux Schnell | ~10 GB | Fast | ★★★★★ |
| WAN 2.2 (video) | ~12 GB | Slow | ★★★★★ |

GPU: NVIDIA RTX 4070 (12 GB VRAM)

## Documentation

| Document | Description |
|----------|-------------|
| [docs/VIDEO_GENERATION.md](docs/VIDEO_GENERATION.md) | WAN 2.2 and SVD video generation |
| [docs/CIVITAI_GUIDE.md](docs/CIVITAI_GUIDE.md) | Downloading models from CivitAI |
| [docs/ERRORS_EXPLAINED.md](docs/ERRORS_EXPLAINED.md) | Troubleshooting common errors |
| [docs/WAN_QUICK_START.md](docs/WAN_QUICK_START.md) | WAN 2.2 quick reference |
| [MODELS_ATTRIBUTION.md](MODELS_ATTRIBUTION.md) | Model sources and licenses |
| [CHANGELOG.md](CHANGELOG.md) | Version history |

## Project Structure

```
ai-platform/
├── start.sh / stop.sh / quick-check.sh  # Lifecycle management
├── docker-compose.yml                    # SwarmUI + Ollama
├── Dockerfile                            # SwarmUI image build
├── VERSION                               # Semantic version (1.0.0)
├── dlbackend/
│   ├── ComfyUI/          # git submodule
│   └── extra_model_paths.yaml
├── models/               # User-managed model files (gitignored)
├── workflows/            # ComfyUI workflow JSON files
│   └── Examples/         # Example workflows
├── docs/                 # Guides and documentation
└── output/               # Generated images (gitignored)
```

## Acknowledgments

Built with assistance from [Claude](https://claude.ai) (Anthropic AI) —
used for code generation, documentation, and architecture design.
