# AI Platform - Stage 1: Image Generation

Local, offline-first AI platform for image generation using SwarmUI + ComfyUI.

## Architecture Decision: Local Build

**Decision**: Use local Docker build from official SwarmUI repository.

**Context** (February 2026):
- No official pre-built Docker image exists for SwarmUI
- GHCR registry returns "denied" for all mcmonkeyprojects paths
- Community images lack maintenance guarantees
- InvokeAI has official Docker but different UX philosophy (canvas-first vs batch/experiments)

**Rationale**:
- Full control over source and build process
- Reproducible across environments (WSL2 → Proxmox)
- No registry dependencies for deployment
- Ability to pin specific commits if needed

**Trade-offs accepted**:
- First build takes ~10-15 minutes
- Updates require `git pull && rebuild`

**This is intentional, not a workaround.**

## Quick Start

```bash
./start.sh          # Clone, build, start
./stop.sh           # Graceful shutdown
./stop.sh --purge   # Full cleanup (re-downloads backend on next start)
```

Access: http://127.0.0.1:7801

## Architecture

### SwarmUI + ComfyUI Relationship

```
┌─────────────────────────────────────────────────────┐
│                    SwarmUI                          │
│  (Web UI on port 7801)                              │
│                                                     │
│  ┌───────────────────────────────────────────────┐  │
│  │           ComfyUI Backend                      │  │
│  │  (Internal process, no exposed ports)         │  │
│  │  - Node-based image generation                │  │
│  │  - Manages GPU inference                      │  │
│  │  - Located at /SwarmUI/dlbackend              │  │
│  └───────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

**How it works:**
1. SwarmUI starts as the main process (dotnet application)
2. On first launch, it downloads/installs ComfyUI to `/SwarmUI/dlbackend`
3. SwarmUI spawns ComfyUI as a subprocess with internal socket communication
4. ComfyUI handles actual GPU inference; SwarmUI provides stable web UI
5. Models are shared between both via the `/SwarmUI/Models` mount

**Key difference from standalone ComfyUI:**
- ComfyUI runs internally - no separate container/port needed
- SwarmUI abstracts ComfyUI's node complexity into simpler UI
- Custom ComfyUI workflows still work via the workflows mount

### Directory Structure

```
ai-platform/
├── docker-compose.yml     # Service definition
├── start.sh               # Lifecycle management
├── stop.sh
├── swarmui/               # Cloned repository (gitignored)
├── models/                # Bind mount - YOUR models
│   ├── Stable-Diffusion/  # Base models (SD 1.5, SDXL, etc.)
│   ├── Lora/              # LoRA adapters
│   ├── VAE/               # VAE models
│   ├── Embeddings/        # Textual inversions
│   ├── ControlNet/        # ControlNet models
│   ├── upscale_models/    # ESRGAN, etc.
│   └── clip_vision/       # CLIP models
├── output/                # Bind mount - generated images
├── data/                  # Bind mount - SwarmUI config
└── workflows/             # Bind mount - custom ComfyUI workflows
```

### Volume Strategy

| Path | Type | Rationale |
|------|------|-----------|
| `models/` | Bind mount | Full control, manual organization |
| `output/` | Bind mount | Direct access to generated images |
| `data/` | Bind mount | Config backup, transparency |
| `dlbackend/` | Named volume | Internal ComfyUI, managed by SwarmUI |
| `DLNodes/` | Named volume | ComfyUI custom nodes |
| `Extensions/` | Named volume | SwarmUI extensions |

## Filesystem Permissions

### How it works

The container runs as your host user (via `HOST_UID`/`HOST_GID` env vars):

```yaml
user: "${HOST_UID:-1000}:${HOST_GID:-1000}"
```

**start.sh** exports these automatically:
```bash
export HOST_UID=$(id -u)
export HOST_GID=$(id -g)
```

This ensures:
1. Files created in bind mounts are owned by you (not root)
2. You can read/write models and outputs without sudo
3. No permission conflicts when stopping/starting

### Potential issues

| Problem | Cause | Solution |
|---------|-------|----------|
| Permission denied on models/ | Directory created as root | `sudo chown -R $(id -u):$(id -g) models/` |
| Can't write to output/ | Wrong ownership | `sudo chown -R $(id -u):$(id -g) output/` |
| Container won't start | UID mismatch after rebuild | `./stop.sh --purge && ./start.sh --build` |

## Model Organization (Civitai)

### Recommended structure

Download from Civitai and place in appropriate subdirectory:

```
models/
├── Stable-Diffusion/
│   ├── sd_xl_base_1.0.safetensors      # SDXL base
│   ├── sd_xl_refiner_1.0.safetensors   # SDXL refiner (optional)
│   └── v1-5-pruned.safetensors         # SD 1.5 (legacy)
├── Lora/
│   ├── detail_enhancer_xl.safetensors
│   └── style_anime_v1.safetensors
├── VAE/
│   └── sdxl_vae.safetensors
├── ControlNet/
│   ├── control_v11p_sd15_canny.pth
│   └── controlnet-canny-sdxl-1.0.safetensors
└── upscale_models/
    └── 4x-UltraSharp.pth
```

### Civitai download tips

1. **Always download .safetensors** over .ckpt (safer, faster loading)
2. **Check model base** - SDXL models won't work with SD1.5 pipelines
3. **Match LoRAs to base model** - SDXL LoRAs for SDXL, SD1.5 for SD1.5
4. **VAE is optional** - SDXL has good built-in VAE; SD1.5 benefits from external
5. **Naming convention** - keep original names for community troubleshooting

### First model to download

For RTX 4070 (12GB VRAM), start with:
- **SDXL Base** (~6.5GB) - good quality, fits in VRAM
- Or **SDXL Turbo/Lightning** - faster variants

Avoid SD3/Flux initially - higher VRAM requirements.

## GPU Optimization (RTX 4070)

The docker-compose.yml includes:

```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: 1
          capabilities: [gpu]
```

SwarmUI auto-detects and optimizes for your GPU. Additional tweaks in SwarmUI UI:
- Enable "Memory-efficient attention" (Settings > Backend)
- Use FP16 for inference (default on RTX 40-series)
- Batch size 1 for 12GB VRAM stability

## Proxmox Migration Notes

When migrating to Proxmox with GPU passthrough:

1. **Same structure works** - just copy the directory
2. **Update UID/GID** if different user on Proxmox VM
3. **Named volumes** must be recreated (or use `--purge` and rebuild)
4. **GPU passthrough config** needed on Proxmox side:
   - IOMMU enabled
   - vfio-pci drivers
   - GPU device assigned to VM

## Models

Model weights are **not included** in this repository (excluded via `.gitignore`).

See [MODELS_ATTRIBUTION.md](MODELS_ATTRIBUTION.md) for the full list of models used,
their download sources, and license information.

For setup instructions, see [CLAUDE.md](CLAUDE.md) under "Adding New Models".

## Troubleshooting

```bash
# View logs
docker compose logs -f swarmui

# Check GPU visibility
docker compose exec swarmui nvidia-smi

# Force rebuild
./stop.sh --purge
./start.sh --build

# Manual container access
docker compose exec swarmui bash
```
