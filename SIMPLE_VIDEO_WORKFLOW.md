# Простий Image-to-Video Workflow (БЕЗ CLIPLoader)

## ❌ ВИ РОБИТЕ НЕПРАВИЛЬНО:

Якщо ваш workflow виглядає так:
```
CLIPLoader → ...
```

**ЦЕ НЕПРАВИЛЬНО!** Видаліть всі CLIPLoader ноди!

---

## ✅ ПРАВИЛЬНИЙ WORKFLOW (мінімальний):

### Спосіб 1: Без VHS (найпростіший)

Створіть ці ноди вручну в ComfyUI:

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

**Результат:** 14 окремих кадрів збережені в `output/`

---

## 📋 Покрокова інструкція:

### Крок 1: Очистити ComfyUI

1. Відкрити http://127.0.0.1:7821
2. Натиснути **Clear** (очистити весь workflow)
3. Переконатись що **НЕМАЄ** нод CLIPLoader або CLIPTextEncode

### Крок 2: Додати ноди

#### Нода 1: LoadImage
- Права кнопка миші → **Add Node** → **image** → **LoadImage**
- Завантажити ваше зображення

#### Нода 2: ImageOnlyCheckpointLoader
- Права кнопка миші → **Add Node** → **loaders** → **ImageOnlyCheckpointLoader**
- У полі **ckpt_name** натиснути **Browse**
- Знайти: `/mnt/g/Git/GitHub/ai-platform/video_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors`
- Якщо не знаходить - ввести повний шлях вручну

#### Нода 3: SVD_img2vid_Conditioning
- Права кнопка миші → **Add Node** → **conditioning** → **video_models** → **SVD_img2vid_Conditioning**
- Підключити:
  - `clip_vision` від ImageOnlyCheckpointLoader
  - `init_image` від LoadImage
  - `vae` від ImageOnlyCheckpointLoader
- Налаштувати параметри:
  ```
  width: 1024
  height: 576
  video_frames: 14
  motion_bucket_id: 127
  fps: 6
  augmentation_level: 0
  ```

#### Нода 4: KSampler
- Права кнопка миші → **Add Node** → **sampling** → **KSampler**
- Підключити:
  - `model` від ImageOnlyCheckpointLoader
  - `positive` від SVD_img2vid_Conditioning
  - `negative` від SVD_img2vid_Conditioning
  - `latent_image` від SVD_img2vid_Conditioning
- Налаштувати:
  ```
  seed: random
  steps: 20
  cfg: 2.5
  sampler_name: euler
  scheduler: karras
  denoise: 1.0
  ```

#### Нода 5: VAEDecode
- Права кнопка миші → **Add Node** → **latent** → **VAEDecode**
- Підключити:
  - `samples` від KSampler
  - `vae` від ImageOnlyCheckpointLoader

#### Нода 6: SaveImage
- Права кнопка миші → **Add Node** → **image** → **SaveImage**
- Підключити:
  - `images` від VAEDecode
- filename_prefix: `video_frames_`

### Крок 3: Запустити

1. Натиснути **Queue Prompt**
2. Чекати 2-5 хвилин
3. Кадри з'являться в `output/`

### Крок 4: Зібрати відео (вручну)

```bash
cd /mnt/g/Git/GitHub/ai-platform/output
ffmpeg -framerate 6 -pattern_type glob -i 'video_frames_*.png' -c:v libx264 -pix_fmt yuv420p output_video.mp4
```

---

## ⚠️ ВАЖЛИВО:

### ❌ НЕ використовуйте:
- CLIPLoader
- CLIPTextEncode
- CheckpointLoaderSimple (використовуйте ImageOnlyCheckpointLoader)
- Текстові промпти (image-to-video їх не підтримує)

### ✅ Використовуйте тільки:
- ImageOnlyCheckpointLoader (для WAN моделей)
- SVD_img2vid_Conditioning (для параметрів відео)
- Без CLIP!

---

## 🎯 Доступні моделі:

```
/mnt/g/Git/GitHub/ai-platform/video_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors
/mnt/g/Git/GitHub/ai-platform/video_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
```

**WAN High Noise:** Більше динаміки, активні рухи
**WAN Low Noise:** Плавніші рухи, вища якість

---

## 📊 Параметри:

### motion_bucket_id:
- 50-100: Легкі рухи
- 100-150: Помірні рухи
- 150-200: Активні рухи

### video_frames:
- 14: ~2 секунди, швидше
- 21: ~3 секунди
- 25: ~4 секунди, повільніше

### fps:
- 6: Повільна анімація
- 8: Стандартна
- 12: Швидка

---

**Після цього workflow точно має працювати!** 🎬
