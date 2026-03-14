# ComfyUI Image-to-Video — Quick Start

## ❌ Problem: CLIPLoader error

If you see error:
```
CLIPLoader
Internal: src/sentencepiece_processor.cc(237) [model_proto->ParseFromArray...]
```

**Reason:** You're using **text-to-image** workflow instead of **image-to-video** workflow.

**Solution:** Image-to-video models (SVD, WAN) **DO NOT USE CLIP** — they don't need text prompts!

---

## ✅ Correct way to use I2V models

### Step 1: Open ComfyUI
```
http://127.0.0.1:7821
```

### Step 2: Load ready workflow

#### Option A: Use my workflow (recommended)

1. In ComfyUI press **"Load"** (bottom right)
2. Click **"Upload"** or drag file:
   ```
   /mnt/g/Git/GitHub/ai-platform/video_workflow_basic.json
   ```
3. Workflow will load automatically

#### Option B: Create manually

If file doesn't work, create workflow from these nodes:

```
1. LoadImage
   ↓
2. ImageOnlyCheckpointLoader (video_models/svd.safetensors)
   ↓
3. SVD_img2vid_Conditioning
   ↓
4. KSampler
   ↓
5. VAEDecode
   ↓
6. VHS_VideoCombine (Save Video)
```

### Step 3: Configure parameters

#### In "ImageOnlyCheckpointLoader" node:

Choose model:
- **SVD:** `video_models/svd.safetensors`
- **WAN High:** `video_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors`
- **WAN Low:** `video_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors`

#### In "LoadImage" node:

1. Click **"Choose File"**
2. Select image (1024x576 recommended)
3. Format: PNG, JPG

#### In "SVD_img2vid_Conditioning" node:

**For SVD or quick test:**
```
width: 1024
height: 576
video_frames: 14
motion_bucket_id: 127
fps: 6
augmentation_level: 0
```

**For WAN High Noise (dynamic motion):**
```
width: 1024
height: 576
video_frames: 25
motion_bucket_id: 180
fps: 8
augmentation_level: 0
```

**For WAN Low Noise (smooth motion):**
```
width: 1024
height: 576
video_frames: 25
motion_bucket_id: 100
fps: 6
augmentation_level: 0
```

#### In "KSampler" node:

```
seed: (any number or "randomize")
steps: 20
cfg: 2.5
sampler_name: euler
scheduler: karras
denoise: 1.0
```

#### In "VHS_VideoCombine" node:

```
frame_rate: 6 (or 8)
format: h264-mp4
filename_prefix: video_output
```

### Step 4: Run generation

1. Press **"Queue Prompt"** (top right)
2. Wait 2-10 minutes (depends on model)
3. Video saves to: `output/`

---

## 🎯 Parameters in detail

### motion_bucket_id (Motion amount)

| Value | Effect | Use |
|-------|--------|-----|
| **0-50** | Almost static | Very light motion (breathing, blinking) |
| **50-100** | Light motion | Wind, clouds, light gestures |
| **100-150** | Moderate motion | Walking, normal movements |
| **150-200** | Active motion | Running, dancing, active actions |
| **200-255** | Very dynamic | Fast movement, sports |

### video_frames (Frame count)

| Value | Duration @ 6fps | Duration @ 8fps | VRAM | Generation time |
|-------|-----------------|-----------------|------|-----------------|
| **14** | ~2.3 sec | ~1.75 sec | ~10 GB | 2-5 min |
| **21** | ~3.5 sec | ~2.6 sec | ~11 GB | 4-7 min |
| **25** | ~4.2 sec | ~3.1 sec | ~12 GB | 5-10 min |

### fps (Frames per second)

| Value | Effect |
|-------|--------|
| **6** | Slow, smooth animation |
| **8** | Standard speed |
| **12** | Fast, dynamic animation |

### augmentation_level (Augmentation level)

| Value | Effect |
|-------|--------|
| **0.0** | No changes (recommended) |
| **0.1-0.3** | Light variations |
| **0.5+** | Strong changes (can be chaotic) |

---

## 📋 Common errors and solutions

### Error 1: CLIPLoader sentencepiece error

**Reason:** Using text-to-image workflow

**Solution:** Delete all **CLIPLoader** and **CLIPTextEncode** nodes from workflow. I2V models don't need them!

### Error 2: Model not found

**Reason:** Wrong path to model

**Solution:** In "ImageOnlyCheckpointLoader" node specify:
```
video_models/svd.safetensors
video_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors
video_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
```

### Error 3: Out of memory (CUDA)

**Reason:** VRAM full

**Solution:**
1. Reduce `video_frames` to 14
2. Reduce resolution (768x576 instead of 1024x576)
3. Close SwarmUI during video generation
4. Use SVD instead of WAN (less VRAM)

### Error 4: VHS_VideoCombine not found

**Reason:** Custom nodes not installed

**Solution:**
```bash
cd /mnt/g/Git/GitHub/ai-platform/dlbackend/ComfyUI/custom_nodes
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
# Restart ComfyUI
```

---

## 🎨 Usage examples

### Example 1: Portrait with light motion (SVD)

**Model:** `video_models/svd.safetensors`

**Parameters:**
```
width: 1024
height: 576
video_frames: 14
motion_bucket_id: 80
fps: 6
```

**Result:** Blinking, light hair movement, breathing

### Example 2: Landscape with cloud motion (WAN Low)

**Model:** `video_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors`

**Parameters:**
```
width: 1024
height: 576
video_frames: 25
motion_bucket_id: 100
fps: 6
```

**Result:** Smooth cloud motion, light tree sway

### Example 3: Walking person (WAN High)

**Model:** `video_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors`

**Parameters:**
```
width: 1024
height: 576
video_frames: 25
motion_bucket_id: 180
fps: 8
```

**Result:** Active walking, cloth movement, natural animation

---

## 🔧 Quick commands

```bash
# Check if ComfyUI is running
curl -s http://127.0.0.1:7821/system_stats

# View available video models
ls -lh /mnt/g/Git/GitHub/ai-platform/video_models/

# View generated videos
ls -lht /mnt/g/Git/GitHub/ai-platform/output/ | head -10

# Open output folder
cd /mnt/g/Git/GitHub/ai-platform/output
```

---

## ✅ Checklist

Before generation check:

- [ ] Using **ImageOnlyCheckpointLoader** (NOT CheckpointLoaderSimple)
- [ ] Workflow has **NO** CLIPLoader or CLIPTextEncode nodes
- [ ] Correct model selected (`video_models/...`)
- [ ] Input image uploaded (1024x576)
- [ ] Parameters configured (motion_bucket_id, fps, video_frames)
- [ ] ComfyUI running (http://127.0.0.1:7821)
- [ ] Free VRAM available (~10-12 GB)

---

**Ready! Now you can generate videos from any of the three models!** 🎬✨

**Quick start:**
1. Open ComfyUI: http://127.0.0.1:7821
2. Load workflow: `video_workflow_basic.json`
3. Choose model: `video_models/svd.safetensors`
4. Upload image
5. Queue Prompt!
