# Models & Attribution

This project does NOT include model files. All models must be downloaded separately.
Models are excluded via `.gitignore` (see `.gitignore` for patterns).

## Software Components

| Component | Source | License |
|-----------|--------|---------|
| SwarmUI | github.com/mcmonkeyprojects/SwarmUI | MIT |
| ComfyUI | github.com/comfyanonymous/ComfyUI | GPL-3.0 |
| Ollama | github.com/ollama/ollama | MIT |

## Image Generation Models (Checkpoints)

### SD 1.5 Based

| Model | Download | License | Commercial Use |
|-------|----------|---------|----------------|
| DreamShaper 8 | civitai.com/models/4384 | OpenRAIL-M | ✓ Allowed |
| MajicMix Realistic v7 | civitai.com/models/43331 | OpenRAIL-M | ✓ Allowed |
| Realistic Vision v6.0 | civitai.com/models/4201 | OpenRAIL-M | ✓ Allowed |

### SDXL Based

| Model | Download | License | Commercial Use |
|-------|----------|---------|----------------|
| Juggernaut XL | civitai.com/models/133005 | OpenRAIL-M | ✓ Allowed |
| NovaAnime XL | civitai.com | OpenRAIL-M | ✓ Allowed |
| Pony Diffusion V6 XL | civitai.com/models/257749 | OpenRAIL-M | ✓ Allowed |
| + other SDXL checkpoints | civitai.com | OpenRAIL-M | ✓ Allowed |

### Flux Based

| Model | Download | License | Commercial Use |
|-------|----------|---------|----------------|
| Flux Schnell (base) | huggingface.co/black-forest-labs/FLUX.1-schnell | Flux License | Personal/Research only |

## Video Generation Models

| Model | Source | License | Commercial Use |
|-------|--------|---------|----------------|
| Stable Video Diffusion (SVD) | huggingface.co/stabilityai/stable-video-diffusion-img2vid | OpenRAIL-M | Non-commercial |
| WAN 2.2 I2V 14B (high noise) | HuggingFace / Wanxiang | CC-BY-NC-SA 4.0 | ✗ Non-commercial only |
| WAN 2.2 I2V 14B (low noise) | HuggingFace / Wanxiang | CC-BY-NC-SA 4.0 | ✗ Non-commercial only |

**Note on WAN 2.2:** Models by Wanxiang (万象). Licensed under CC-BY-NC-SA 4.0.
Commercial use requires explicit permission from Wanxiang.

## Text Encoders

| File | Model | Source | License |
|------|-------|--------|---------|
| clip_l.safetensors | OpenAI CLIP-L | huggingface.co/openai/clip-vit-large-patch14 | MIT |
| t5xxl_fp8_e4m3fn.safetensors | Google T5-XXL | huggingface.co/google/t5-v1_1-xxl | Apache 2.0 |
| umt5_xxl_fp8_e4m3fn_scaled.safetensors | Universal Multilingual T5 | HuggingFace | Apache 2.0 |
| qwen_3_4b.safetensors | Alibaba Qwen 3 4B | huggingface.co/Qwen | Qwen License |

## VAE Models

| File | Source | License |
|------|--------|---------|
| sdxl_vae.safetensors | Stability AI | OpenRAIL-M |
| vae-ft-mse-840000-ema-pruned.safetensors | Stability AI | OpenRAIL-M |
| wan_2.1_vae.safetensors | Wanxiang | CC-BY-NC-SA 4.0 |
| Flux/ae.safetensors | Black Forest Labs | Flux License |

## LoRA Adapters

| File | Source | License | Notes |
|------|--------|---------|-------|
| Hands + Feet + skin v1.1 | civitai.com | OpenRAIL-M | Anatomy improvement |
| wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise | Wanxiang / HuggingFace | CC-BY-NC-SA 4.0 | Video quality |
| wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise | Wanxiang / HuggingFace | CC-BY-NC-SA 4.0 | Video quality |
| Other LoRA adapters | civitai.com | Varies per author | Check CivitAI page |

## LLM Models (Ollama)

| Model | Source | License | Commercial Use |
|-------|--------|---------|----------------|
| qwen2.5-coder:7b | ollama.com/library/qwen2.5-coder | Qwen License | ✓ Allowed (with attribution) |

## License Notes

- **OpenRAIL-M**: Permissive for most uses including commercial, with responsible-AI restrictions
- **MIT / Apache 2.0**: Permissive open-source, commercial use allowed
- **CC-BY-NC-SA 4.0**: Attribution required, non-commercial only, share-alike
- **Flux License**: Personal and research use allowed; commercial requires separate license from Black Forest Labs
- **Qwen License**: Research and commercial use allowed; redistribution has restrictions

## Disclaimer

This repository contains only configuration, scripts, and documentation.
No model weights are distributed. Each model must be obtained according to its respective license terms.
All trademarks belong to their respective owners.
