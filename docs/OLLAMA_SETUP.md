# Ollama Setup Guide (Docker-based)

Ollama runs in Docker with GPU passthrough, sharing the RTX 4070 with ComfyUI.

## Quick Start

### 1. Start the Platform

```bash
./start.sh
```

This starts:
- ComfyUI (port 7821) — image generation (host)
- SwarmUI (port 7801) — web UI (Docker)
- Ollama (port 11434) — LLM inference (Docker)

### 2. Download a Coding Model

```bash
# Download recommended coding model (~4.5GB)
docker exec -it ollama ollama pull qwen2.5-coder:7b
```

### 3. Verify Installation

```bash
# List models
docker exec ollama ollama list

# Test API
curl http://127.0.0.1:11434/api/tags
```

## Verification

```bash
# Check all services
curl -s http://127.0.0.1:7821 && echo "✓ ComfyUI OK"
curl -s http://127.0.0.1:11434/api/tags && echo "✓ Ollama OK"
curl -s http://127.0.0.1:7801 && echo "✓ SwarmUI OK"

# Test code generation
curl -X POST http://127.0.0.1:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{"model": "qwen2.5-coder:7b", "prompt": "Write hello world in Python", "stream": false}'
```

## Available Models

| Model | Size | VRAM | Best For |
|-------|------|------|----------|
| `qwen2.5-coder:7b` | 4.5GB | ~4.5GB | **Recommended** - general coding |
| `qwen2.5-coder:3b` | 2.2GB | ~2.2GB | Fast responses, less VRAM |
| `deepseek-coder:6.7b` | 4.2GB | ~4.2GB | Alternative coding model |
| `codellama:7b` | 4.5GB | ~4.5GB | Meta's coding model |

Pull additional models:
```bash
docker exec -it ollama ollama pull qwen2.5-coder:3b  # Lightweight
docker exec -it ollama ollama pull deepseek-coder:6.7b  # Alternative
```

## Configuration

Settings in `docker-compose.yml` (ollama service environment):

| Variable | Value | Purpose |
|----------|-------|---------|
| `OLLAMA_KEEP_ALIVE` | `5m` | Unload model after 5min idle |
| `OLLAMA_MAX_LOADED_MODELS` | `1` | Single model in VRAM |
| `OLLAMA_FLASH_ATTENTION` | `1` | Memory optimization (~20-30% savings) |
| `OLLAMA_KV_CACHE_TYPE` | `q8_0` | 8-bit K/V cache |
| `CUDA_VISIBLE_DEVICES` | `0` | Explicit GPU selection |

## VRAM Management

RTX 4070 (12GB) can run both ComfyUI and Ollama via automatic GPU sharing:

1. **Active LLM usage**: ~4.5GB VRAM (qwen2.5-coder:7b)
2. **After 5min idle**: Ollama unloads model, VRAM freed
3. **Image generation**: Full 12GB available for ComfyUI

For heavy image generation, manually unload LLM:
```bash
# Immediate unload
curl http://127.0.0.1:11434/api/generate -d '{"model":"qwen2.5-coder:7b","keep_alive":0}'
```

## API Examples

### Native Ollama API

```bash
# Generate code
curl -X POST http://127.0.0.1:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5-coder:7b",
    "prompt": "Write a Python function to calculate fibonacci",
    "stream": false
  }'
```

### OpenAI-Compatible API

```bash
curl -X POST http://127.0.0.1:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5-coder:7b",
    "messages": [
      {"role": "system", "content": "You are a helpful coding assistant."},
      {"role": "user", "content": "Explain this: def fib(n): return n if n < 2 else fib(n-1) + fib(n-2)"}
    ]
  }'
```

## Model Management

```bash
# List downloaded models
docker exec ollama ollama list

# Pull new model
docker exec -it ollama ollama pull <model-name>

# Remove model
docker exec ollama ollama rm <model-name>

# Check running models (loaded in VRAM)
docker exec ollama ollama ps
```

## Troubleshooting

```bash
# Check container status
docker compose ps ollama

# Check container health
docker inspect --format='{{.State.Health.Status}}' ollama

# View logs
docker compose logs -f ollama

# Test API
curl http://127.0.0.1:11434/api/tags

# GPU usage
nvidia-smi

# Check loaded models
docker exec ollama ollama ps

# Restart Ollama only
docker compose restart ollama

# Restart everything
./stop.sh && ./start.sh
```

## Data Persistence

Models are stored in `ollama-models/` directory (bind mount to container's `/root/.ollama`).

This directory persists across container restarts and recreations.

```bash
# Check model storage
ls -la ollama-models/

# Backup models
tar -czf ollama-models-backup.tar.gz ollama-models/
```

## Removal

To completely remove Ollama:

```bash
# Stop platform
./stop.sh

# Remove models (optional)
rm -rf ollama-models/*

# Models directory structure will be recreated on next start
```

No host system changes needed — everything runs in Docker!
