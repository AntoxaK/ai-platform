# 🎬 Video Models for AI Platform

## 📹 Image-to-Video models (work in SwarmUI)

### ⭐ Stable Video Diffusion (SVD) - RECOMMENDED

**What is it:** Official model from Stability AI for converting images to video

#### SVD versions:

| Model | Frames | Size | VRAM | Speed |
|-------|--------|------|------|-------|
| **SVD** | 14 frames | ~9.8 GB | ~10-12 GB | Medium |
| **SVD-XT** | 25 frames | ~9.8 GB | ~10-12 GB | Slow |
| **SVD 1.1** | 14 frames | ~9.8 GB | ~10-12 GB | Medium (improved quality) |

**For RTX 4070 (12GB):** ✅ SVD or SVD 1.1 (14 frames)

---

## 📥 Where to download

### Hugging Face (official)

#### SVD (Stable Video Diffusion)
```
https://huggingface.co/stabilityai/stable-video-diffusion-img2vid
File: svd.safetensors
Size: ~9.8 GB
```

#### SVD-XT (Extended - 25 frames)
```
https://huggingface.co/stabilityai/stable-video-diffusion-img2vid-xt
File: svd_xt.safetensors
Size: ~9.8 GB
```

#### SVD 1.1 (improved version)
```
https://huggingface.co/stabilityai/stable-video-diffusion-img2vid-xt-1-1
File: svd_xt_1_1.safetensors
Size: ~9.8 GB
```

### Civitai (alternative versions)

```
https://civitai.com/models/204418/stable-video-diffusion
```

Search models with tags:
- **Model Type:** Video
- **Base Model:** SVD 1.0 / SVD XT

---

## 📦 How to install

### Step 1: Download model

**Choose one:**

**For fast generation (14 frames):**
```bash
cd /mnt/g/Git/GitHub/ai-platform/models/Stable-Diffusion/

# Download SVD
wget https://huggingface.co/stabilityai/stable-video-diffusion-img2vid/resolve/main/svd.safetensors
```

**Or for longer videos (25 frames):**
```bash
# Download SVD-XT
wget https://huggingface.co/stabilityai/stable-video-diffusion-img2vid-xt/resolve/main/svd_xt.safetensors
```

### Step 2: Place in correct folder

```bash
# SVD models go to Stable-Diffusion or separate folder
mv svd*.safetensors /mnt/g/Git/GitHub/ai-platform/models/Stable-Diffusion/
```

Alternatively create separate folder:
```bash
mkdir -p models/video_models
mv svd*.safetensors models/video_models/
```

### Step 3: Update ComfyUI paths (if using separate folder)

Add to `dlbackend/ComfyUI/extra_model_paths.yaml`:

```yaml
ai_platform:
    base_path: ../../models
    # ... existing paths
    video_models: |
       video_models
       Stable-Diffusion  # SVD can also be here
```

### Step 4: Restart system

```bash
./stop.sh
./start.sh
```

### Step 5: Refresh models in SwarmUI

1. Open http://127.0.0.1:7801
2. Bottom left: **Server** → **Utilities** → **Refresh Models**

---

## 🎬 How to use in SwarmUI

### Settings for Video Generation:

1. **Model:** Choose SVD model from dropdown
2. **Input Image:** Upload image (recommended 1024×576 or 576×1024)
3. **Video Settings:**
   - **Frames:** 14 (SVD) or 25 (SVD-XT)
   - **FPS:** 6-8 (standard for SVD)
   - **Motion Bucket:** 127 (higher = more motion)
   - **Augmentation Level:** 0.0-0.3

4. **Generation:**
   - Press **Generate**
   - Wait ~2-5 minutes (depends on frames)

---

## ⚙️ Recommended settings for RTX 4070

### SVD (14 frames):
```
Resolution: 1024×576
Frames: 14
FPS: 7
Motion Bucket: 127
Steps: 20-25
Cfg Scale: 2.5
```

**Generation time:** ~2-3 minutes
**VRAM:** ~10-11 GB

### SVD-XT (25 frames):
```
Resolution: 1024×576
Frames: 25
FPS: 6
Motion Bucket: 127
Steps: 20-25
Cfg Scale: 2.5
```

**Generation time:** ~4-5 minutes
**VRAM:** ~11-12 GB ⚠️ (almost fully uses 12GB)

---

## 🔧 Alternative models (if SVD doesn't suit)

### AnimateDiff (for SD1.5 models)

**What is it:** Adds animation to existing SD1.5 models

**Download:**
```
https://huggingface.co/guoyww/animatediff/tree/main
File: mm_sd_v15_v2.ckpt
Size: ~1.7 GB
```

**Folder:** `models/animatediff_models/`

**Advantages:**
- ✅ Less VRAM (~6-8 GB)
- ✅ Faster generation
- ✅ Works with your SD1.5 models

**Disadvantages:**
- ❌ Lower quality than SVD
- ❌ Requires additional configuration

---

## 📊 Model comparison

| Model | Quality | VRAM | Speed | Recommendation |
|-------|---------|------|-------|-----------------|
| **SVD** | ⭐⭐⭐⭐⭐ | 10-11 GB | Medium | ✅ Best for RTX 4070 |
| **SVD-XT** | ⭐⭐⭐⭐⭐ | 11-12 GB | Slow | ⚠️ Uses almost all VRAM |
| **SVD 1.1** | ⭐⭐⭐⭐⭐ | 10-11 GB | Medium | ✅ Improved SVD version |
| **AnimateDiff** | ⭐⭐⭐☆☆ | 6-8 GB | Fast | ✅ If low VRAM |

---

## ❌ What does NOT work (text-to-video)

These models are **NOT supported** in SwarmUI for direct text-to-video generation:

- ❌ **ModelScope** (text-to-video)
- ❌ **ZeroScope** (text-to-video)
- ❌ **Show-1** (text-to-video)
- ❌ **CogVideo** (text-to-video)

**Why:** SwarmUI focuses on image-to-video workflow via SVD.

**Workaround:** First generate image (SDXL/SD1.5), then convert to video via SVD.

---

## 🚀 Quick start (commands)

### Download SVD:

```bash
cd /mnt/g/Git/GitHub/ai-platform/models/Stable-Diffusion/

# SVD (14 frames) - recommended
wget -O svd.safetensors https://huggingface.co/stabilityai/stable-video-diffusion-img2vid/resolve/main/svd.safetensors

# Or SVD 1.1 (improved)
wget -O svd_1_1.safetensors https://huggingface.co/stabilityai/stable-video-diffusion-img2vid-xt-1-1/resolve/main/svd_xt_1_1.safetensors

# Restart
cd /mnt/g/Git/GitHub/ai-platform
docker compose restart swarmui
```

### Refresh model list:

1. Open http://127.0.0.1:7801
2. **Server** → **Utilities** → **Refresh Models**

---

## 💡 Tips

### For better video quality:

1. **Use high-quality input images**
   - Recommended: 1024×576 or higher
   - Without artifacts and noise

2. **Motion Bucket settings:**
   - 0-50: Minimal motion
   - 50-127: Moderate motion (recommended)
   - 127-255: Intensive motion

3. **FPS:**
   - 6 FPS: Cinematic look
   - 8 FPS: Standard
   - 12 FPS: Smoother (needs more frames)

4. **Augmentation Level:**
   - 0.0: Follows input image exactly
   - 0.3: Allows more creativity

---

## 📝 Example workflow

1. **Generate image** (SDXL):
   ```
   Prompt: "beautiful landscape with sunset, mountains"
   Model: juggernautXL
   Resolution: 1024×576
   ```

2. **Convert to video** (SVD):
   ```
   Model: svd.safetensors
   Input: generated image
   Frames: 14
   FPS: 7
   Motion Bucket: 127
   ```

3. **Result:**
   - 14-frame video (~2 seconds at 7 FPS)
   - Size: 1024×576
   - Smooth scene animation

---

## ✅ Ready!

After downloading SVD model you can:
- ✅ Convert images to short videos
- ✅ Animate static scenes
- ✅ Create cinematic loops

**Video generation time on RTX 4070:** ~2-3 minutes (14 frames) 🎬✨
