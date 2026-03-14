# Video Generation with SVD (Stable Video Diffusion)

## 📹 What are Image-to-Video models?

**Image-to-Video (I2V)** models generate short videos from a single image.

### Available models:

#### 1. SVD (Stable Video Diffusion)
- **Size:** 9.0 GB
- **Type:** Image-to-Video base model
- **Output:** 14-25 frames (~1-2 seconds)
- **Quality:** ⭐⭐⭐☆☆ Good
- **Speed:** ⚡⚡ Medium (2-5 min)
- **VRAM:** ~10-12 GB
- **Features:** First popular I2V model, stable

#### 2. WAN 2.2 High Noise (Wanxiang)
- **Size:** 14 GB (FP8)
- **Type:** Improved I2V model
- **Output:** 14-25 frames (~1-2 seconds)
- **Quality:** ⭐⭐⭐⭐☆ Excellent
- **Speed:** ⚡ Slow (5-10 min)
- **VRAM:** ~12 GB
- **Features:** More dynamics, active motion, expressive

#### 3. WAN 2.2 Low Noise
- **Size:** 14 GB (FP8)
- **Type:** Improved I2V model
- **Output:** 14-25 frames (~1-2 seconds)
- **Quality:** ⭐⭐⭐⭐⭐ Best
- **Speed:** ⚡ Slow (5-10 min)
- **VRAM:** ~12 GB
- **Features:** Smoother motion, fewer artifacts, more natural

### Which model to choose?

| Task | Recommended model |
|------|------------------|
| Quick test | **SVD** |
| Static scenes (landscapes) | **WAN 2.2 Low Noise** |
| Dynamic motion (people, animals) | **WAN 2.2 High Noise** |
| Highest quality | **WAN 2.2 Low Noise** |
| Limited VRAM (<12GB) | **SVD** |

**General:**
- **DO NOT use** text prompts (no text encoder/CLIP)
- **Input:** One image (first frame)
- **Output:** Video 14-25 frames

---

## 📂 Location

```
video_models/  (separate folder outside models/)
├── svd.safetensors  ✓  (9.0 GB)
├── wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors  ✓  (14 GB)
└── wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors  ✓  (14 GB)
```

**Important:**
- ❌ Video models **DO NOT APPEAR** in SwarmUI model list
- ❌ Video models **CANNOT BE USED** via SwarmUI UI
- ✓ Video models **ONLY for** ComfyUI workflows
- ✓ ComfyUI sees them via symlink: `models/video_models/`

**Available models:**
1. **SVD (Stable Video Diffusion)** — 9 GB, 14-25 frames, base model
2. **WAN 2.2 High Noise** — 14 GB, improved quality, more dynamics
3. **WAN 2.2 Low Noise** — 14 GB, less noise, smoother motion

---

## 🎬 How to use SVD

### Option 1: Via ComfyUI (Recommended)

SVD requires special workflow in ComfyUI with these components:

#### Basic workflow:

1. **Load Image** — load input image (first frame)
2. **SVD_img2vid_Conditioning** — set video parameters
3. **VideoLinearCFGGuidance** — quality control
4. **KSampler** — frame generation
5. **VAE Decode** — decode to video
6. **VHS_VideoCombine** — assemble final video

#### SVD parameters:

| Parameter | Value | Description |
|-----------|-------|-------------|
| **width** | 1024 | Video width |
| **height** | 576 | Video height |
| **video_frames** | 14-25 | Number of frames |
| **motion_bucket_id** | 127 | Motion amount (0-255, higher = more motion) |
| **fps** | 6-8 | Frames per second |
| **augmentation_level** | 0.0 | Augmentation level (0.0-1.0) |

#### Step 1: Open ComfyUI

```
http://127.0.0.1:7821
```

#### Step 2: Load SVD workflow

ComfyUI has built-in examples for SVD:
1. Click **"Load"** → **"Default"**
2. Search for **"stable-video-diffusion"** or **"SVD"**

Or create your own workflow from nodes above.

#### Step 2.5: Choose model

In workflow find **"ImageOnlyCheckpointLoader"** or **"CheckpointLoaderSimple"** node:

**For SVD:**
- In **"ckpt_name"** field select: `video_models/svd.safetensors`

**For WAN 2.2 High Noise:**
- In **"ckpt_name"** field select: `video_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors`

**For WAN 2.2 Low Noise:**
- In **"ckpt_name"** field select: `video_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors`

**Note:** ComfyUI automatically sees `models/video_models/` folder via symlink.

#### Step 3: Load input image

- SVD works best with **static scenes**
- Recommended resolution: **1024x576** (16:9)
- Avoid overly complex scenes

#### Step 4: Configure parameters

**For slow motion** (subtle animation):
```
motion_bucket_id: 50-100
fps: 6
video_frames: 14
```

**For dynamic motion** (active animation):
```
motion_bucket_id: 150-255
fps: 8
video_frames: 25
```

#### Step 5: Run generation

- Press **"Queue Prompt"**
- Generation takes **2-5 minutes** on RTX 4070
- Final video saves to `output/`

---

## 🎨 Workflow examples

### Example 1: Simple landscape animation

**Input:** Photo of mountains or forest

**Parameters:**
```
width: 1024
height: 576
video_frames: 14
motion_bucket_id: 80
fps: 6
```

**Result:** Light tree sway, cloud movement

### Example 2: Dynamic character animation

**Input:** Portrait or full-body character

**Parameters:**
```
width: 1024
height: 576
video_frames: 25
motion_bucket_id: 180
fps: 8
```

**Result:** Hair movement, cloth movement, blinking

### Example 3: Abstract animation

**Input:** Abstract image or texture

**Parameters:**
```
width: 1024
height: 576
video_frames: 25
motion_bucket_id: 200
fps: 8
augmentation_level: 0.3
```

**Result:** Dynamic shape transformation

---

## 📊 System requirements

| Parameter | Value |
|-----------|-------|
| **VRAM** | ~10-12 GB (for 1024x576, 14 frames) |
| **Generation time** | 2-5 min (RTX 4070) |
| **Model size** | 9.0 GB |
| **FP16 support** | Yes ✓ |
| **Batch size** | 1 (SVD doesn't support batching) |

---

## 🚀 Option 2: Alternative methods

### AnimateDiff (for text-to-video)

If you need video generation **from text prompt**, use AnimateDiff:

1. Download AnimateDiff motion module from Civitai:
   - Base Model: `AnimateDiff`
   - Model Type: `Motion Module`

2. Place in folder:
   ```
   models/animatediff_models/
   ```

3. Use AnimateDiff workflow in ComfyUI

**AnimateDiff advantages:**
- Supports text prompts
- Works with SD 1.5 / SDXL models
- Can add LoRA for styling

**AnimateDiff disadvantages:**
- Lower quality than SVD
- Needs more VRAM

---

## ⚠️ SVD limitations

1. **No text prompts** — SVD doesn't understand text, only images
2. **Short videos** — maximum 25 frames (~3 seconds at 8 fps)
3. **Static scenes** — works best with stationary objects
4. **High VRAM** — needs ~10-12 GB for full quality
5. **Slow generation** — 2-5 minutes per video

---

## 🎯 Tips for better results

### Prepare input image:

1. **Resolution:** 1024x576 (16:9) or 768x768 (1:1)
2. **Quality:** High definition, good lighting
3. **Composition:** Avoid overly complex scenes
4. **Style:** Realistic images work better

### Adjust parameters:

1. **motion_bucket_id:**
   - 0-50: Almost static image
   - 50-100: Light motion (wind, clouds)
   - 100-150: Moderate motion (walking, gestures)
   - 150-255: Strong motion (running, active actions)

2. **video_frames:**
   - 14 frames = ~2 seconds (faster, less VRAM)
   - 25 frames = ~3 seconds (longer, more VRAM)

3. **fps:**
   - 6 fps: Slow, smooth animation
   - 8 fps: Standard speed
   - 12 fps: Fast, dynamic animation

### Optimize VRAM:

If generation exceeds 12GB:
- Reduce `video_frames` to 14
- Reduce resolution to 768x576
- Use `--lowvram` flag in ComfyUI

---

## 📖 Useful resources

- **Official SVD repository:** https://github.com/Stability-AI/generative-models
- **ComfyUI workflows for SVD:** https://comfyanonymous.github.io/ComfyUI_examples/
- **AnimateDiff models (alternative):** https://civitai.com/models?tag=AnimateDiff

---

## 🔧 Troubleshooting

### Problem: "Out of memory" during generation

**Solution:**
1. Reduce `video_frames` to 14
2. Reduce resolution (768x576 instead of 1024x576)
3. Close SwarmUI during video generation
4. Use `--lowvram` mode in ComfyUI

### Problem: Video is too static

**Solution:**
1. Increase `motion_bucket_id` to 150-200
2. Increase `fps` to 8-12
3. Use input image with dynamic elements

### Problem: Video is too chaotic

**Solution:**
1. Reduce `motion_bucket_id` to 50-100
2. Reduce `augmentation_level` to 0.0
3. Use more static input image

### Problem: Low video quality

**Solution:**
1. Use high-quality input image (1024x576)
2. Increase `video_frames` to 25
3. Increase `steps` in KSampler to 25-30

---

## ✅ Checklist

- [x] SVD model moved to `models/diffusion_models/`
- [ ] Open ComfyUI (http://127.0.0.1:7821)
- [ ] Load SVD workflow (Load → Default → Stable Video Diffusion)
- [ ] Prepare input image (1024x576 recommended)
- [ ] Configure parameters (motion_bucket_id, fps, video_frames)
- [ ] Run generation (Queue Prompt)
- [ ] Check result in `output/` folder

---

**SVD is ready to use! Open ComfyUI and experiment with video generation!** 🎬✨
