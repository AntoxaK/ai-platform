# WAN 2.2 Image-to-Video — Ready to Use! 🎬

## ✅ All models installed:

```
models/
├── text_encoders/
│   └── umt5_xxl_fp8_e4m3fn_scaled.safetensors ✓ (6.7 GB)
├── VAE/
│   └── wan_2.1_vae.safetensors ✓ (243 MB)
├── diffusion_models/
│   ├── wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors ✓ (14 GB)
│   ├── wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors ✓ (14 GB)
│   └── svd.safetensors ✓ (9 GB)
└── Lora/
    ├── wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors ✓ (1.2 GB)
    └── wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors ✓ (1.2 GB)
```

**Total:** ~47 GB of models for video generation

---

## 🚀 How to use (3 steps):

### Step 1: Open ComfyUI
```
http://127.0.0.1:7821
```

### Step 2: Load official WAN workflow

**Option A:** Drag and drop file
- Drag file to ComfyUI:
  ```
  /mnt/g/Git/GitHub/ai-platform/WAN_WORKFLOW.json
  ```
- Or on Windows:
  ```
  G:\Git\GitHub\ai-platform\WAN_WORKFLOW.json
  ```

**Option B:** Load via UI
1. Press **Load** (bottom right)
2. Click **Upload**
3. Select `WAN_WORKFLOW.json`

### Step 3: Configure and run

#### Nodes will appear in workflow:
1. **CLIPLoader** → umt5_xxl_fp8_e4m3fn_scaled.safetensors ✓
2. **CLIPTextEncode (Positive)** → your prompt in Chinese
3. **CLIPTextEncode (Negative)** → negative prompt
4. **LoadImage** → upload image
5. **DiffusionModelLoader** → wan2.2_i2v_high_noise or low_noise
6. **VAELoader** → wan_2.1_vae.safetensors
7. **KSampler** → generation
8. **VHS_VideoCombine** → save video

#### What to change:

**1. Upload image:**
- Node **LoadImage** → Choose File
- Resolution: 768x768 or 1024x576

**2. Choose model:**
- Node **DiffusionModelLoader**:
  - `wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors` — dynamic motion
  - `wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors` — smooth motion

**3. Write prompt (in Chinese!):**
- Workflow uses Chinese prompts
- Example: `一只可爱的猫咪在走路` (cat walking)
- Or in English, but quality is worse

**4. Adjust parameters:**
- `num_frames`: 14-25 (number of frames)
- `motion_strength`: 0.5-1.0 (motion strength)
- `fps`: 6-8 (video speed)

**5. Queue Prompt:**
- Press **Queue Prompt**
- Wait 5-15 minutes
- Video appears in `output/`

---

## 📊 Model comparison:

| Model | Use | VRAM | Speed |
|-------|-----|------|-------|
| **High Noise** | Active motion, dynamic scenes | ~12 GB | 5-10 min |
| **Low Noise** | Smooth motion, static objects | ~12 GB | 5-10 min |
| **+ LightX2V LoRA** | Fast generation (4 steps) | ~12 GB | 2-5 min |

---

## 🎯 Example prompts:

### Chinese (better quality):

**Cat walking:**
```
正面: 一只可爱的猫咪在草地上慢慢走路，阳光明媚，高质量，4k
负面: 色调艳丽，过曝，静态，模糊，低质量
```

**Person:**
```
正面: 一个女孩在海滩上奔跑，长发飘扬，自然光线，专业摄影
负面: 静止不动，模糊，变形，低质量
```

**Landscape:**
```
正面: 美丽的山景，云朵移动，树叶轻轻摇曳，高质量视频
负面: 静态，过曝，模糊
```

### English (works, but worse):

**Cat walking:**
```
Positive: a cute cat walking on grass, sunny day, high quality, detailed
Negative: static, blurry, low quality, deformed
```

---

## 🔧 Additional features:

### Using LightX2V LoRA (faster generation):

Workflow has **LoraLoader** node:
1. Select LoRA:
   - `wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors`
   - `wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors`
2. Set weight: 0.8-1.0
3. In KSampler change steps to 4 (instead of 20)

**Result:** Generation in 2-5 minutes instead of 5-10!

---

## 📝 KSampler parameters:

| Parameter | Recommended | Description |
|-----------|-------------|-------------|
| **steps** | 20 (or 4 with LoRA) | Number of steps |
| **cfg** | 2.5-3.5 | CFG scale |
| **sampler_name** | euler | Sampler |
| **scheduler** | normal | Scheduler |
| **denoise** | 1.0 | Denoising |

---

## ⚠️ Important:

### ✅ DO use:
- CLIPLoader with umt5_xxl (this is WAN text encoder!)
- CLIPTextEncode for prompts
- Chinese prompts for better quality
- 14-25 frames for video

### ❌ DON'T use:
- Regular CLIP for SD models
- Too long prompts (>512 tokens)
- Too high resolution (>1024x1024)

---

## 🎬 Result:

After generation you'll get:
- MP4 video in `output/`
- Duration: ~2-4 seconds
- FPS: 6-8
- Resolution: same as input image

---

## 🔍 Troubleshooting:

### Error: "CUDA out of memory"
**Solution:**
- Reduce `num_frames` to 14
- Close SwarmUI
- Use LightX2V LoRA

### Error: "Model not found"
**Solution:**
- Check model paths
- Restart ComfyUI: `bash start.sh`

### Video is static (no motion)
**Solution:**
- Increase `motion_strength` to 0.8-1.0
- Use `high_noise` model
- Improve prompt (add action verbs)

---

## 📖 Official documentation:

- **Comfy Docs:** https://docs.comfy.org/tutorials/video/wan/wan2_2
- **WAN 2.2 GitHub:** https://github.com/ali-vilab/VGen
- **Workflow Template:** https://github.com/Comfy-Org/workflow_templates

---

**Ready! Open ComfyUI and upload the workflow!** 🎬✨

**Quick start:**
```bash
# 1. ComfyUI already running at http://127.0.0.1:7821
# 2. Drag and drop WAN_WORKFLOW.json
# 3. Upload image
# 4. Queue Prompt!
```
