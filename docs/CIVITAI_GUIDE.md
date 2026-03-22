# Civitai Guide for AI Platform

Quick reference for downloading models from https://civitai.com

---

## 🎯 Quick start

### Step 1: Open Civitai
```
https://civitai.com/models
```

### Step 2: Apply filters

**Required filters:**
1. **Format**: `SafeTensor` ✓ (always safer)
2. **Base Model**: Choose one from table below ↓
3. **Model Type**: Choose type (Checkpoint, LoRA, etc.)

### Step 3: Download to correct folder

| Civitai Model Type | Folder on disk |
|-------------------|----------------|
| Checkpoint | `G:\Git\GitHub\ai-platform\models\Stable-Diffusion\` |
| LoRA, LoCon, LoHa | `G:\Git\GitHub\ai-platform\models\Lora\` |
| VAE | `G:\Git\GitHub\ai-platform\models\VAE\` |
| Embedding, Textual Inversion | `G:\Git\GitHub\ai-platform\models\Embeddings\` |
| ControlNet, Controlnet (T2I) | `G:\Git\GitHub\ai-platform\models\ControlNet\` |

### Step 4: Refresh SwarmUI
```
http://127.0.0.1:7801
→ Server → Utilities → Refresh Models
```

---

## 📊 Base Model Filter — What to choose?

### For RTX 4070 (12GB VRAM)

| Civitai Base Model | VRAM | Speed | Quality | Recommendation |
|-------------------|------|-------|---------|----------------|
| **SD 1.5** | ~4 GB ✓ | ⚡⚡⚡ Very fast | ⭐⭐⭐ Good | For tests, quick generation |
| **SDXL 1.0** | ~6-8 GB ✓ | ⚡⚡ Medium | ⭐⭐⭐⭐ Excellent | **🏆 RECOMMENDED** — best balance |
| **SDXL Turbo** | ~6 GB ✓ | ⚡⚡⚡ Fast | ⭐⭐⭐⭐ Excellent | For fast quality generation |
| **SDXL Lightning** | ~6 GB ✓ | ⚡⚡⚡ Fast | ⭐⭐⭐⭐ Excellent | 1-4 steps, very fast |
| **Pony** | ~6-8 GB ✓ | ⚡⚡ Medium | ⭐⭐⭐⭐ Excellent | For anime, furry, styling |
| **Flux.1 S** | ~10 GB ✓ | ⚡⚡ Fast | ⭐⭐⭐⭐⭐ Best | **🏆 Highest quality**, 4 steps |
| **Flux.1 D** | ~12 GB ⚠ | ⚡ Slow | ⭐⭐⭐⭐⭐ Best | Maximum quality (FP8!) |
| **SD 3.5 Large** | ~12 GB ⚠ | ⚡ Slow | ⭐⭐⭐⭐⭐ Best | New architecture |
| **SD 3.5 Medium** | ~5 GB ✓ | ⚡⚡ Medium | ⭐⭐⭐⭐ Excellent | Lighter SD 3.5 version |

**Legend:**
- ✓ — Works comfortably on RTX 4070 12GB
- ⚠ — Works, but needs FP8 or offloading

---

## 🎨 Popular models by category

### Realistic photos (SDXL)

**Civitai filters:**
- Base Model: `SDXL 1.0`
- Model Type: `Checkpoint`
- Tags: `realistic`, `photorealistic`

**Recommended models:**
- Juggernaut XL ✓ (already have)
- RealVisXL
- DreamshaperXL
- ProteusV0.4
- CopaxTimelessxlSDXL1

### Anime (SDXL/Pony)

**Civitai filters:**
- Base Model: `SDXL 1.0` or `Pony`
- Model Type: `Checkpoint`
- Tags: `anime`, `illustration`

**Recommended models:**
- NovaAnimeXL ✓ (already have)
- AnimagineXL
- Pony Diffusion V6
- AutismMix (Pony)
- AnythingXL

### Landscapes and locations (SDXL)

**Civitai filters:**
- Base Model: `SDXL 1.0`
- Model Type: `Checkpoint`
- Tags: `landscape`, `scenery`

**Recommended models:**
- Kodorail ✓ (already have)
- RealitiesEdgeXL
- Copax Turbo

### Fast generation (SD 1.5)

**Civitai filters:**
- Base Model: `SD 1.5`
- Model Type: `Checkpoint`

**Recommended models:**
- DreamShaper 8 ✓ (already have)
- Realistic Vision V6.0 ✓ (already have)
- MajicMix Realistic ✓ (already have)

### Highest quality (Flux)

**Civitai filters:**
- Base Model: `Flux.1 D` or `Flux.1 S`
- Model Type: `Checkpoint` or `LoRA`

**Recommended models:**
- zImageBase ✓ (already have — Flux Schnell)
- Flux.1 Dev (official, needs FP8)
- Flux Realism LoRA
- Flux Uncensored LoRA

---

## 🔧 Additional model types

### LoRA (style adapters)

**What is it:** Small files (10-200 MB) that modify checkpoint model style

**Civitai filters:**
- Model Type: `LoRA`
- Base Model: Same as your checkpoint (SD 1.5, SDXL, Pony, Flux)

**Popular categories:**
- **Style LoRA**: Art styles (watercolor, oil, anime)
- **Character LoRA**: Specific characters (from anime, movies, games)
- **Detail LoRA**: Detail enhancement (hands, faces, textures)
- **Clothing LoRA**: Clothes, costumes

**Examples:**
- `Detail Tweaker LoRA` (detail enhancement)
- `Add More Details` (sharpness, detail)
- `Anime Lineart LoRA` (outlines)
- Hands + Feet + skin v1.1 ✓ (already have)

**Folder:** `models/Lora/`

### VAE (image decoder)

**What is it:** File that converts latent space to final image (colors, sharpness)

**Popular:**
- `sdxl_vae.safetensors` ✓ (already have) — for SDXL
- `vae-ft-mse-840000-ema-pruned.safetensors` ✓ (already have) — for SD 1.5

**Note:** Many models have built-in VAE ("baked-in VAE"), so separate not needed

**Folder:** `models/VAE/`

### Embeddings (textual inversions)

**What is it:** Small files (10-100 KB) that add concepts via keywords

**Civitai filters:**
- Model Type: `Embedding` or `Textual Inversion`

**Popular (for negative prompts):**
- `EasyNegative`
- `BadDream`
- `UnrealisticDream`
- `FastNegative`

**Usage:** Add name in prompt, e.g.: `EasyNegative` in Negative Prompt

**Folder:** `models/Embeddings/`

### ControlNet (composition control)

**What is it:** Models for precise composition control via reference images

**Civitai filters:**
- Model Type: `ControlNet`
- Base Model: Same as checkpoint

**ControlNet types:**
- **Canny** — object contours
- **Depth** — depth map
- **OpenPose** — human skeleton (poses)
- **Scribble** — hand drawings
- **Normal map** — lighting directions
- **Lineart** — line drawings

**Folder:** `models/ControlNet/`

---

## 📂 All model folders

```
G:\Git\GitHub\ai-platform\models\
│
├── Stable-Diffusion\       ← Checkpoint models (main)
│   ├── dreamshaper_8.safetensors (SD 1.5) ✓
│   ├── majicmixRealistic_v7.safetensors (SD 1.5) ✓
│   ├── realisticVisionV60B1_v51HyperVAE.safetensors (SD 1.5) ✓
│   ├── hsUltrahdCG_illepic.safetensors (SDXL) ✓
│   ├── juggernautXL_ragnarokBy.safetensors (SDXL) ✓
│   ├── kodorail_v120.safetensors (SDXL) ✓
│   ├── novaAnimeXL_ilV160.safetensors (SDXL) ✓
│   ├── zImageBase_base.safetensors (Flux) ✓
│   └── svd.safetensors (Video) ✓
│
├── Lora\                   ← LoRA, LoCon, LoHa adapters
│   └── Hands + Feet + skin v1.1.safetensors ✓
│
├── VAE\                    ← VAE decoders
│   ├── sdxl_vae.safetensors ✓
│   └── vae-ft-mse-840000-ema-pruned.safetensors ✓
│
├── Embeddings\             ← Textual inversions
│   └── (add here)
│
├── ControlNet\             ← ControlNet models
│   └── (add here)
│
├── text_encoders\          ← Text encoders for Flux/SD3
│   ├── clip_l.safetensors ✓
│   └── t5xxl_fp8_e4m3fn.safetensors ✓
│
├── clip_vision\            ← CLIP Vision for IP-Adapter
│   └── (auto-loaded)
│
├── upscale_models\         ← Upscaler models (ESRGAN)
│   └── (add from OpenModelDB)
│
├── ipadapter\              ← IP-Adapter models
│   └── (add here)
│
├── animatediff_models\     ← AnimateDiff motion modules
│   └── (for video generation)
│
├── animatediff_motion_lora\ ← AnimateDiff LoRA
│   └── (for video generation)
│
└── diffusion_models\       ← Specialized diffusion models
    └── svd.safetensors ✓   (Stable Video Diffusion, 9.0 GB)
```

**Mark ✓** = already installed

---

## ⚙️ After downloading model

### Option 1: Via web interface (RECOMMENDED)

1. Open SwarmUI:
   ```
   http://127.0.0.1:7801
   ```

2. Press **"Server"** bottom left

3. Select **"Utilities"**

4. Press **"Refresh Models"**

5. Wait 5-10 seconds

6. Refresh page (F5)

### Option 2: Via Docker

```bash
cd /mnt/g/Git/GitHub/ai-platform
docker compose restart swarmui
```

**Note:** ComfyUI does NOT need to restart — it auto-detects new files.

---

## 🎓 Civitai filter examples

### Example 1: Realistic portrait (SDXL)

**Filters:**
- Base Model: `SDXL 1.0` ✓
- Model Type: `Checkpoint` ✓
- Tags: `realistic`, `portrait`, `photorealistic`
- Format: `SafeTensor` ✓

**Result:** Finds models like JuggernautXL, RealVisXL

**Folder:** `models/Stable-Diffusion/`

### Example 2: Anime LoRA for SDXL

**Filters:**
- Base Model: `SDXL 1.0` ✓
- Model Type: `LoRA` ✓
- Tags: `anime`, `style`
- Format: `SafeTensor` ✓

**Result:** Finds LoRA for anime styling

**Folder:** `models/Lora/`

### Example 3: ControlNet for poses (SDXL)

**Filters:**
- Base Model: `SDXL 1.0` ✓
- Model Type: `ControlNet` ✓
- Tags: `openpose`, `pose`
- Format: `SafeTensor` ✓

**Result:** Finds OpenPose ControlNet for SDXL

**Folder:** `models/ControlNet/`

### Example 4: Negative embeddings

**Filters:**
- Base Model: `SD 1.5` or `SDXL 1.0` ✓
- Model Type: `Embedding` or `Textual Inversion` ✓
- Tags: `negative`, `quality`

**Result:** Finds EasyNegative, BadDream, etc.

**Folder:** `models/Embeddings/`

### Example 5: Flux LoRA for realism

**Filters:**
- Base Model: `Flux.1 D` or `Flux.1 S` ✓
- Model Type: `LoRA` ✓
- Tags: `realism`, `photography`
- Format: `SafeTensor` ✓

**Result:** Finds Flux Realism, Flux Uncensored, etc.

**Folder:** `models/Lora/`

---

## ❓ FAQ

### Question: How many models can I install?

**Answer:** Unlimited! Checkpoint models take 2-12 GB each, LoRA — 10-200 MB. You have 1.2 TB free space.

### Question: Can I use SD 1.5 LoRA with SDXL models?

**Answer:** No. LoRA must match the Base Model checkpoint:
- SD 1.5 LoRA → only for SD 1.5 models
- SDXL LoRA → only for SDXL models
- Flux LoRA → only for Flux models

### Question: What is "baked-in VAE"?

**Answer:** Means model already contains VAE inside. Don't need to download separate VAE file.

### Question: Why need separate VAE?

**Answer:** VAE improves colors and sharpness. If model has no baked-in VAE, or you want to experiment with different VAE — download separate.

### Question: What's better — Checkpoint or LoRA?

**Answer:**
- **Checkpoint** = base model (required)
- **LoRA** = modifier (added to checkpoint)
- Use: 1 checkpoint + 0-5 LoRA simultaneously

### Question: Why are Flux models so large?

**Answer:** Flux is modular:
- Main model: ~10 GB
- CLIP-L: 235 MB ✓ (already have)
- T5-XXL (FP8): 4.6 GB ✓ (already have)
- VAE: ~335 MB
- **Total: ~15 GB**

But quality is highest!

### Question: What is FP8 quantization?

**Answer:** Reducing precision (Float Point 8-bit instead of 16-bit) to save VRAM:
- FP16: 9.8 GB (full precision)
- FP8: 4.6 GB (minimal quality loss)
- For RTX 4070 12GB use FP8!

### Question: Where to find Upscaler models?

**Answer:**
- OpenModelDB: https://openmodeldb.info
- Hugging Face: https://huggingface.co/models?pipeline_tag=image-to-image

Popular: RealESRGAN, ESRGAN, SwinIR, UltraSharp

**Folder:** `models/upscale_models/`

### Question: Why doesn't SVD appear in SwarmUI model list?

**Answer:** SVD (Stable Video Diffusion) is **image-to-video** model, which does NOT support text-to-image generation. It:
- Has no text encoder (CLIP)
- Used only via ComfyUI workflows
- Generates video from one image
- Located in `models/diffusion_models/`

**More info:** See `VIDEO_GENERATION.md`

### Question: How to generate video?

**Answer:** Two options:

**Option 1: SVD (image-to-video)**
- Uses one image as input
- Generates 14-25 frames (~2-3 seconds)
- Highest quality
- See `VIDEO_GENERATION.md`

**Option 2: AnimateDiff (text-to-video)**
- Uses text prompt
- Works with SD 1.5 / SDXL models
- Can add LoRA
- Download motion modules from Civitai

---

## 🔗 Useful links

- **Civitai**: https://civitai.com/models
- **Hugging Face**: https://huggingface.co/models?pipeline_tag=text-to-image
- **OpenModelDB** (upscalers): https://openmodeldb.info
- **SwarmUI Docs**: https://github.com/mcmonkeyprojects/SwarmUI/tree/master/docs

---

## ✅ Checklist before downloading

- [ ] Checked Base Model (SD 1.5, SDXL, Flux, etc.)
- [ ] Checked Model Type (Checkpoint, LoRA, VAE, etc.)
- [ ] Chose format `.safetensors` (NOT .ckpt, NOT .pt)
- [ ] Checked file size (enough space?)
- [ ] Know where to put file (Stable-Diffusion, Lora, VAE, etc.)
- [ ] Know how to refresh models (Server → Utilities → Refresh Models)

---

**Ready! Now you can download models from Civitai with confidence!** 🎨✨
