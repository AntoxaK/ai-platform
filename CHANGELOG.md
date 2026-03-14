# Changelog

All notable changes to AI Platform are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)

## [Unreleased]

## [1.0.0] - 2026-03-14

### Added
- SwarmUI (.NET 8) + ComfyUI hybrid architecture
- Ollama LLM inference with qwen2.5-coder:7b
- NVIDIA RTX 4070 GPU support (host ComfyUI + Docker Ollama/SwarmUI)
- Model directory structure for SD 1.5, SDXL, Flux, WAN 2.2, SVD
- extra_model_paths.yaml for model path management
- Example workflows: Basic SDXL, WAN Optimized RTX4070
- MODELS_ATTRIBUTION.md with full license information
- ComfyUI as git submodule (v0.0.2-2277-g361b9a82)
- WAN 2.2 video generation with LightX2V LoRA optimization
- Health check script (quick-check.sh)
- VERSION file and semantic versioning
- Reorganized docs/ and workflows/ directories

[1.0.0]: https://github.com/AntoxaK/ai-platform/releases/tag/v1.0.0
[Unreleased]: https://github.com/AntoxaK/ai-platform/compare/v1.0.0...HEAD
