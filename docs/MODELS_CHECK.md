# Model Check in SwarmUI

## ✅ System restarted

**Date:** $(date +"%d.%m.%Y %H:%M")

### System status:
- ✓ ComfyUI v0.11.1 — running (http://127.0.0.1:7821)
- ✓ SwarmUI — running (http://127.0.0.1:7801)
- ✓ GPU: NVIDIA RTX 4070 (12GB VRAM)
- ✓ Metadata cache cleared

---

## 📦 Available models (confirmed by ComfyUI API)

### Checkpoints: 8 models (text-to-image)

**SD 1.5 (3 models):**
- ✓ dreamshaper_8.safetensors
- ✓ majicmixRealistic_v7.safetensors
- ✓ realisticVisionV60B1_v51HyperVAE.safetensors

**SDXL (4 models):**
- ✓ hsUltrahdCG_illepic.safetensors
- ✓ juggernautXL_ragnarokBy.safetensors
- ✓ kodorail_v120.safetensors
- ✓ novaAnimeXL_ilV160.safetensors

**Flux (1 model):**
- ✓ zImageBase_base.safetensors

### VAE: 3 models
- ✓ sdxl_vae.safetensors
- ✓ vae-ft-mse-840000-ema-pruned.safetensors
- ✓ pixel_space (built-in)

### LoRA: 1 adapter
- ✓ Hands + Feet + skin v1.1.safetensors (163 MB)

### Video Diffusion Models: 1 model
- ✓ svd.safetensors (9.0 GB) — Stable Video Diffusion (image-to-video)

**Note:** SVD doesn't appear in SwarmUI because it's used via ComfyUI workflows for video generation.
**More info:** `VIDEO_GENERATION.md`

---

## 🎯 How to verify models in SwarmUI

### Step 1: Open SwarmUI
```
http://127.0.0.1:7801
```

### Step 2: Refresh model list (if needed)
1. Press **"Server"** bottom left
2. Select **"Utilities"**
3. Press **"Refresh Models"**
4. Wait 5-10 seconds
5. Refresh page (F5)

### Step 3: Check dropdown list
Click **"Model"** field at top — should show all 8 models:

```
"Model" dropdown:
├── dreamshaper_8
├── majicmixRealistic_v7
├── realisticVisionV60B1_v51HyperVAE
├── hsUltrahdCG_illepic
├── juggernautXL_ragnarokBy
├── kodorail_v120
├── novaAnimeXL_ilV160
└── zImageBase_base
```

**Note:** SVD (Stable Video Diffusion) no longer appears here because it was moved to `models/diffusion_models/` for use via ComfyUI workflows.

### Step 4: Check VAE
If **"VAE"** field exists (may be in Advanced settings):

```
"VAE" dropdown:
├── Automatic
├── sdxl_vae
├── vae-ft-mse-840000-ema-pruned
└── pixel_space
```

### Step 5: Check LoRA
In **"LoRA"** or **"Add LoRA"** section (if available):

```
"LoRA" dropdown:
└── Hands + Feet + skin v1.1
```

---

## 🧪 Quick test

### Test 1: SD 1.5 model
```
Model: majicmixRealistic_v7
VAE: vae-ft-mse-840000-ema-pruned
Prompt: portrait of a person
Steps: 20
```

### Test 2: SDXL model
```
Model: juggernautXL_ragnarokBy
VAE: sdxl_vae
Prompt: beautiful landscape
Steps: 25
```

### Test 3: Flux model
```
Model: zImageBase_base
VAE: automatic
Prompt: high quality photo
Steps: 20
CFG: 3.5
```

### Test 4: SDXL + LoRA
```
Model: novaAnimeXL_ilV160
VAE: sdxl_vae
LoRA: Hands + Feet + skin v1.1 (weight: 0.8)
Prompt: anime girl, detailed hands
Steps: 28
```

---

## 🔧 If models not showing

### 1. Refresh via UI
```
Server → Utilities → Refresh Models → Wait → F5
```

### 2. Restart SwarmUI
```bash
cd /mnt/g/Git/GitHub/ai-platform
docker compose restart swarmui
```

### 3. Full restart
```bash
cd /mnt/g/Git/GitHub/ai-platform
./stop.sh
./start.sh
```

### 4. Clear cache and restart
```bash
cd /mnt/g/Git/GitHub/ai-platform
rm -f data/model_metadata*.ldb
docker compose restart swarmui
```

---

## 📂 Model locations

```
/mnt/g/Git/GitHub/ai-platform/models/
├── Stable-Diffusion/      → 9 checkpoint models
├── VAE/                   → 2 VAE files
├── Lora/                  → 2 LoRA adapters
└── [other folders]
```

---

## 🎨 Ready presets

In file `data/AI-Platform-Presets.json` there are 8 ready presets:

1. **SDXL Portrait** — portraits (JuggernautXL)
2. **SDXL Landscape** — landscapes (Kodorail)
3. **SDXL Anime** — anime (NovaAnimeXL)
4. **SD 1.5 Fast** — fast generation (DreamShaper)
5. **Flux High Quality** — maximum quality (Flux)
6. **Cats Realistic** 🐱 — realistic cats
7. **Cats SDXL** 🐱 — cats SDXL
8. **Cats Anime** 🐱 — cats anime

**How to import:** See `HOW_TO_USE_PRESETS.md`

## 📥 Download new models

**Detailed guide:** `CIVITAI_GUIDE.md`

Quick start:
1. Open https://civitai.com/models
2. Filters:
   - Format: `SafeTensor` ✓
   - Base Model: `SDXL 1.0` (recommended for RTX 4070)
   - Model Type: `Checkpoint`, `LoRA`, `VAE`, etc.
3. Download to right folder (see CIVITAI_GUIDE.md)
4. SwarmUI → Server → Utilities → Refresh Models

---

## ✅ Checklist

- [x] ComfyUI running and sees 8 text-to-image checkpoints
- [x] ComfyUI sees 1 video diffusion model (SVD)
- [x] ComfyUI sees 3 VAE
- [x] ComfyUI sees 1 LoRA
- [x] SwarmUI running
- [x] Metadata cache cleared
- [x] System ready to work

**If all models not showing in SwarmUI:**
→ Use **Server → Utilities → Refresh Models** in web interface
→ Or restart: `docker compose restart swarmui`

---

**System ready! Open http://127.0.0.1:7801 and start generating!** 🎨✨
