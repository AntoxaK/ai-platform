# Simple Image-to-Video Workflow (WITHOUT CLIPLoader)

## ❌ YOU'RE DOING IT WRONG:

If your workflow looks like this:
```
CLIPLoader → ...
```

**THIS IS WRONG!** Delete all CLIPLoader nodes!

---

## ✅ CORRECT WORKFLOW (minimal):

### Method 1: Without VHS (simplest)

Create these nodes manually in ComfyUI:

```
1. Load Image
   - Upload your image (1024x576)

2. ImageOnlyCheckpointLoader
   - ckpt_name: /mnt/g/Git/GitHub/ai-platform/video_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors

3. SVD_img2vid_Conditioning
   - Connect: clip_vision from (2)
   - Connect: init_image from (1)
   - Connect: vae from (2)
   - width: 1024
   - height: 576
   - video_frames: 14
   - motion_bucket_id: 127
   - fps: 6
   - augmentation_level: 0

4. KSampler
   - Connect: model from (2)
   - Connect: positive from (3)
   - Connect: negative from (3)
   - Connect: latent_image from (3)
   - seed: random
   - steps: 20
   - cfg: 2.5
   - sampler_name: euler
   - scheduler: karras

5. VAEDecode
   - Connect: samples from (4)
   - Connect: vae from (2)

6. SaveImage
   - Connect: images from (5)
   - filename_prefix: video_frames_
```

**Result:** 14 individual frames saved in `output/`

---

## 📋 Step-by-step instructions:

### Step 1: Clear ComfyUI

1. Open http://127.0.0.1:7821
2. Press **Clear** (clear entire workflow)
3. Make sure there are NO CLIPLoader or CLIPTextEncode nodes

### Step 2: Add nodes

#### Node 1: LoadImage
- Right click → **Add Node** → **image** → **LoadImage**
- Upload your image

#### Node 2: ImageOnlyCheckpointLoader
- Right click → **Add Node** → **loaders** → **ImageOnlyCheckpointLoader**
- In **ckpt_name** field click **Browse**
- Find: `/mnt/g/Git/GitHub/ai-platform/video_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors`
- If not found - enter full path manually

#### Node 3: SVD_img2vid_Conditioning
- Right click → **Add Node** → **conditioning** → **video_models** → **SVD_img2vid_Conditioning**
- Connect:
  - `clip_vision` from ImageOnlyCheckpointLoader
  - `init_image` from LoadImage
  - `vae` from ImageOnlyCheckpointLoader
- Configure parameters:
  ```
  width: 1024
  height: 576
  video_frames: 14
  motion_bucket_id: 127
  fps: 6
  augmentation_level: 0
  ```

#### Node 4: KSampler
- Right click → **Add Node** → **sampling** → **KSampler**
- Connect:
  - `model` from ImageOnlyCheckpointLoader
  - `positive` from SVD_img2vid_Conditioning
  - `negative` from SVD_img2vid_Conditioning
  - `latent_image` from SVD_img2vid_Conditioning
- Configure:
  ```
  seed: random
  steps: 20
  cfg: 2.5
  sampler_name: euler
  scheduler: karras
  denoise: 1.0
  ```

#### Node 5: VAEDecode
- Right click → **Add Node** → **latent** → **VAEDecode**
- Connect:
  - `samples` from KSampler
  - `vae` from ImageOnlyCheckpointLoader

#### Node 6: SaveImage
- Right click → **Add Node** → **image** → **SaveImage**
- Connect:
  - `images` from VAEDecode
- filename_prefix: `video_frames_`

### Step 3: Run

1. Press **Queue Prompt**
2. Wait 2-5 minutes
3. Frames appear in `output/`

### Step 4: Assemble video (manually)

```bash
cd /mnt/g/Git/GitHub/ai-platform/output
ffmpeg -framerate 6 -pattern_type glob -i 'video_frames_*.png' -c:v libx264 -pix_fmt yuv420p output_video.mp4
```

---

## ⚠️ IMPORTANT:

### ❌ DON'T use:
- CLIPLoader
- CLIPTextEncode
- CheckpointLoaderSimple (use ImageOnlyCheckpointLoader)
- Text prompts (image-to-video doesn't support them)

### ✅ ONLY use:
- ImageOnlyCheckpointLoader (for WAN models)
- SVD_img2vid_Conditioning (for video parameters)
- NO CLIP!

---

## 🎯 Available models:

```
/mnt/g/Git/GitHub/ai-platform/video_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors
/mnt/g/Git/GitHub/ai-platform/video_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
```

**WAN High Noise:** More dynamics, active motion
**WAN Low Noise:** Smoother motion, higher quality

---

## 📊 Parameters:

### motion_bucket_id:
- 50-100: Light motion
- 100-150: Moderate motion
- 150-200: Active motion

### video_frames:
- 14: ~2 seconds, faster
- 21: ~3 seconds
- 25: ~4 seconds, slower

### fps:
- 6: Slow animation
- 8: Standard
- 12: Fast

---

**After this the workflow should definitely work!** 🎬
