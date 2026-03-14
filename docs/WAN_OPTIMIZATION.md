# WAN 2.2 Optimization for RTX 4070 12GB

## ⚠️ Problem: Hanging During Generation

WAN 2.2 14B is a VERY large model (14 billion parameters). Even in FP8 it requires ~12GB VRAM.

---

## 🚀 Quick Fixes (in order):

### 1. Close SwarmUI (free 2-3 GB VRAM)

```bash
docker compose stop swarmui
```

**Effect:** +2-3 GB free VRAM

### 2. Reduce number of frames

In workflow find parameter **num_frames** or **video_frames**:

| Was | Became | VRAM | Speed |
|-----|--------|------|-------|
| 25 frames | **14 frames** | -40% | 2x faster |
| 21 frames | **14 frames** | -30% | 1.5x faster |

**Where to change:**
- Node with generation parameters
- Or node **EmptyLatentVideo**
- Set: `frames: 14`

### 3. Reduce image resolution

| Was | Became | VRAM | Quality |
|-----|--------|------|---------|
| 1024x1024 | **768x768** | -30% | Good |
| 1024x576 | **768x432** | -30% | Good |
| 768x768 | **512x512** | -50% | Acceptable |

**How:**
1. Open input image in editor
2. Resize to 768x768
3. Save and upload to ComfyUI

### 4. Use LightX2V LoRA (4 steps instead of 20)

In workflow activate **LoraLoader**:
- **lora_name:** `wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors`
- **strength_model:** 1.0

In **KSampler**:
- **steps:** change from 20 to **4**

**Effect:**
- 5x faster generation
- -20% VRAM
- Slightly lower quality, but acceptable

### 5. Use Low Noise model (less noise = fewer steps)

Instead of `wan2.2_i2v_high_noise` use:
```
wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
```

**Effect:** Can reduce steps to 15-18

---

## 🔧 Optimal settings for RTX 4070 12GB:

### Configuration A: Fastest (2-3 minutes)

```
Model: wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
LoRA: wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors (strength 1.0)
Resolution: 768x768
Frames: 14
Steps: 4
FPS: 6
VRAM: ~8-9 GB
```

### Configuration B: Balance (5-7 minutes)

```
Model: wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
LoRA: Disabled
Resolution: 768x768
Frames: 14
Steps: 18
FPS: 6
VRAM: ~10-11 GB
```

### Configuration C: Best quality (10-15 minutes)

```
Model: wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors
LoRA: Disabled
Resolution: 1024x768
Frames: 21
Steps: 20
FPS: 8
VRAM: ~12 GB (maximum!)
```

---

## 📝 Step-by-step workflow optimization:

### Step 1: Open workflow in ComfyUI

http://127.0.0.1:7821

### Step 2: Find critical nodes

**Node 1: DiffusionModelLoader / UNETLoader**
- Change to: `wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors`

**Node 2: LoraLoader (if exists)**
- Activate (mode: 0)
- lora_name: `wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors`
- strength_model: 1.0
- strength_clip: 1.0

**Node 3: EmptyLatentVideo / video parameters**
- width: 768
- height: 768
- length: 14 (number of frames)
- batch_size: 1

**Node 4: KSampler**
- steps: 4 (if LoRA) or 18 (without LoRA)
- cfg: 2.5
- sampler_name: euler
- scheduler: normal

**Node 5: LoadImage**
- Upload image 768x768

### Step 3: Queue Prompt

Generation should take 2-5 minutes instead of 10-15.

---

## 🔍 How to understand if it hung vs generating?

### Generating (all OK):
```bash
# Check GPU
nvidia-smi

# Should show:
# - GPU Utilization: 90-100%
# - Memory Used: 10-12 GB
# - Temperature: 60-80°C
```

### Hung (problem):
```bash
nvidia-smi

# Shows:
# - GPU Utilization: 0%
# - Memory Used: 12282 MB (100%)
# - Or error "CUDA out of memory"
```

### Check ComfyUI logs:
```bash
tail -50 /tmp/comfyui.log
```

Search for:
- `CUDA out of memory` → Reduce parameters
- `Killed` → RAM ran out
- Progress bar `15%...30%...` → Generating (wait)

---

## 🆘 Emergency help:

### If it hung now:

**1. Interrupt generation:**
- In ComfyUI press **Interrupt** (red button)
- Or:
```bash
pkill -f "python.*main.py.*comfy"
sleep 3
./start.sh
```

**2. Free VRAM:**
```bash
# Close SwarmUI
docker compose stop swarmui

# Restart ComfyUI
pkill -f comfy && sleep 3 && ./start.sh
```

**3. Check if ComfyUI is alive:**
```bash
curl http://127.0.0.1:7821/system_stats
```

### Alternative: Use SVD (lighter model)

If WAN is too heavy, try SVD:

```
Model: svd.safetensors (9 GB instead of 14 GB)
Resolution: 1024x576
Frames: 14
Steps: 20
VRAM: ~10 GB
Time: 3-5 minutes
```

SVD doesn't require text encoder, simpler, faster.

---

## 📊 Resource comparison:

| Model | VRAM | Time (14 frames) | Quality |
|-------|------|-----------------|---------|
| **SVD** | ~10 GB | 3-5 min | ⭐⭐⭐ |
| **WAN + LightX2V** | ~9 GB | 2-3 min | ⭐⭐⭐⭐ |
| **WAN Low Noise** | ~11 GB | 5-7 min | ⭐⭐⭐⭐⭐ |
| **WAN High Noise** | ~12 GB | 7-10 min | ⭐⭐⭐⭐⭐ |

---

## ✅ Recommended workflow for RTX 4070:

1. **Close SwarmUI:**
   ```bash
   docker compose stop swarmui
   ```

2. **Use Configuration A (fastest):**
   - Model: low_noise
   - LoRA: lightx2v_4steps
   - Resolution: 768x768
   - Frames: 14
   - Steps: 4

3. **After generation — restart SwarmUI:**
   ```bash
   docker compose start swarmui
   ```

---

## 🎯 If nothing helps:

### Plan B: Use smaller parameters

```
Model: wan2.2_i2v_low_noise (SAME)
LoRA: lightx2v_4steps (ENABLE)
Resolution: 512x512 (SMALLER!)
Frames: 10 (SMALLER!)
Steps: 4 (SMALLER!)
```

This should work even on 8GB VRAM.

---

**Try Configuration A — it should work guaranteed!** 🚀
