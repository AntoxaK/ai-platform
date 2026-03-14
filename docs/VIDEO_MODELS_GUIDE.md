# 🎬 Video Models для AI Platform

## 📹 Image-to-Video моделі (працюють у SwarmUI)

### ⭐ Stable Video Diffusion (SVD) - РЕКОМЕНДОВАНО

**Що це:** Офіційна модель від Stability AI для перетворення зображень у відео

#### Версії SVD:

| Модель | Frames | Розмір | VRAM | Швидкість |
|--------|--------|--------|------|-----------|
| **SVD** | 14 frames | ~9.8 GB | ~10-12 GB | Середня |
| **SVD-XT** | 25 frames | ~9.8 GB | ~10-12 GB | Повільна |
| **SVD 1.1** | 14 frames | ~9.8 GB | ~10-12 GB | Середня (покращена якість) |

**Для RTX 4070 (12GB):** ✅ SVD або SVD 1.1 (14 frames)

---

## 📥 Де завантажити

### Hugging Face (офіційні)

#### SVD (Stable Video Diffusion)
```
https://huggingface.co/stabilityai/stable-video-diffusion-img2vid
Файл: svd.safetensors
Розмір: ~9.8 GB
```

#### SVD-XT (Extended - 25 frames)
```
https://huggingface.co/stabilityai/stable-video-diffusion-img2vid-xt
Файл: svd_xt.safetensors
Розмір: ~9.8 GB
```

#### SVD 1.1 (покращена версія)
```
https://huggingface.co/stabilityai/stable-video-diffusion-img2vid-xt-1-1
Файл: svd_xt_1_1.safetensors
Розмір: ~9.8 GB
```

### Civitai (альтернативні версії)

```
https://civitai.com/models/204418/stable-video-diffusion
```

Шукай моделі з тегами:
- **Model Type:** Video
- **Base Model:** SVD 1.0 / SVD XT

---

## 📦 Як встановити

### Крок 1: Завантаж модель

**Вибери одну:**

**Для швидкої генерації (14 frames):**
```bash
cd /mnt/g/Git/GitHub/ai-platform/models/Stable-Diffusion/

# Завантаж SVD
wget https://huggingface.co/stabilityai/stable-video-diffusion-img2vid/resolve/main/svd.safetensors
```

**Або для довших відео (25 frames):**
```bash
# Завантаж SVD-XT
wget https://huggingface.co/stabilityai/stable-video-diffusion-img2vid-xt/resolve/main/svd_xt.safetensors
```

### Крок 2: Покладіть у правильну папку

```bash
# SVD моделі йдуть в Stable-Diffusion або окрему папку
mv svd*.safetensors /mnt/g/Git/GitHub/ai-platform/models/Stable-Diffusion/
```

Альтернативно можна створити окрему папку:
```bash
mkdir -p models/video_models
mv svd*.safetensors models/video_models/
```

### Крок 3: Оновити ComfyUI шляхи (якщо використовуєш окрему папку)

Додай в `dlbackend/ComfyUI/extra_model_paths.yaml`:

```yaml
ai_platform:
    base_path: ../../models
    # ... існуючі шляхи
    video_models: |
       video_models
       Stable-Diffusion  # SVD також може бути тут
```

### Крок 4: Перезапустити систему

```bash
./stop.sh
./start.sh
```

### Крок 5: Оновити список моделей у SwarmUI

1. Відкрий http://127.0.0.1:7801
2. Внизу зліва: **Server** → **Utilities** → **Refresh Models**

---

## 🎬 Як використовувати у SwarmUI

### Налаштування для Video Generation:

1. **Model:** Вибери SVD модель з dropdown
2. **Input Image:** Завантаж зображення (рекомендовано 1024×576 або 576×1024)
3. **Video Settings:**
   - **Frames:** 14 (SVD) або 25 (SVD-XT)
   - **FPS:** 6-8 (стандарт для SVD)
   - **Motion Bucket:** 127 (більше = більше руху)
   - **Augmentation Level:** 0.0-0.3

4. **Generation:**
   - Натисни **Generate**
   - Зачекай ~2-5 хвилин (залежно від frames)

---

## ⚙️ Рекомендовані налаштування для RTX 4070

### SVD (14 frames):
```
Resolution: 1024×576
Frames: 14
FPS: 7
Motion Bucket: 127
Steps: 20-25
Cfg Scale: 2.5
```

**Час генерації:** ~2-3 хвилини
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

**Час генерації:** ~4-5 хвилин
**VRAM:** ~11-12 GB ⚠️ (майже повністю використає 12GB)

---

## 🔧 Альтернативні моделі (якщо SVD не підходить)

### AnimateDiff (для SD1.5 моделей)

**Що це:** Додає анімацію до існуючих SD1.5 моделей

**Завантаження:**
```
https://huggingface.co/guoyww/animatediff/tree/main
Файл: mm_sd_v15_v2.ckpt
Розмір: ~1.7 GB
```

**Папка:** `models/animatediff_models/`

**Переваги:**
- ✅ Менше VRAM (~6-8 GB)
- ✅ Швидше генерує
- ✅ Працює з твоїми SD1.5 моделями

**Недоліки:**
- ❌ Гірша якість ніж SVD
- ❌ Потребує додаткові налаштування

---

## 📊 Порівняння моделей

| Модель | Якість | VRAM | Швидкість | Рекомендація |
|--------|--------|------|-----------|--------------|
| **SVD** | ⭐⭐⭐⭐⭐ | 10-11 GB | Середня | ✅ Найкраще для RTX 4070 |
| **SVD-XT** | ⭐⭐⭐⭐⭐ | 11-12 GB | Повільна | ⚠️ Використовує майже всю VRAM |
| **SVD 1.1** | ⭐⭐⭐⭐⭐ | 10-11 GB | Середня | ✅ Покращена версія SVD |
| **AnimateDiff** | ⭐⭐⭐☆☆ | 6-8 GB | Швидка | ✅ Якщо мало VRAM |

---

## ❌ Що НЕ працює (text-to-video)

Ці моделі **не підтримуються** у SwarmUI для прямої text-to-video генерації:

- ❌ **ModelScope** (text-to-video)
- ❌ **ZeroScope** (text-to-video)
- ❌ **Show-1** (text-to-video)
- ❌ **CogVideo** (text-to-video)

**Чому:** SwarmUI фокусується на image-to-video workflow через SVD.

**Обхід:** Спочатку згенеруй зображення (SDXL/SD1.5), потім конвертуй у відео через SVD.

---

## 🚀 Швидкий старт (команди)

### Завантаження SVD:

```bash
cd /mnt/g/Git/GitHub/ai-platform/models/Stable-Diffusion/

# SVD (14 frames) - рекомендовано
wget -O svd.safetensors https://huggingface.co/stabilityai/stable-video-diffusion-img2vid/resolve/main/svd.safetensors

# Або SVD 1.1 (покращена)
wget -O svd_1_1.safetensors https://huggingface.co/stabilityai/stable-video-diffusion-img2vid-xt-1-1/resolve/main/svd_xt_1_1.safetensors

# Перезапуск
cd /mnt/g/Git/GitHub/ai-platform
docker compose restart swarmui
```

### Оновлення списку моделей:

1. Відкрий http://127.0.0.1:7801
2. **Server** → **Utilities** → **Refresh Models**

---

## 💡 Поради

### Для кращої якості відео:

1. **Використовуй високоякісні вхідні зображення**
   - Рекомендовано: 1024×576 або вище
   - Без артефактів та шуму

2. **Motion Bucket налаштування:**
   - 0-50: Мінімальний рух
   - 50-127: Помірний рух (рекомендовано)
   - 127-255: Інтенсивний рух

3. **FPS:**
   - 6 FPS: Cinematic look
   - 8 FPS: Стандарт
   - 12 FPS: Плавніше (потребує більше frames)

4. **Augmentation Level:**
   - 0.0: Точно слідує вхідному зображенню
   - 0.3: Дозволяє більше креативності

---

## 📝 Приклад workflow

1. **Згенеруй зображення** (SDXL):
   ```
   Prompt: "beautiful landscape with sunset, mountains"
   Model: juggernautXL
   Resolution: 1024×576
   ```

2. **Конвертуй у відео** (SVD):
   ```
   Model: svd.safetensors
   Input: згенероване зображення
   Frames: 14
   FPS: 7
   Motion Bucket: 127
   ```

3. **Результат:**
   - 14-frame відео (~2 секунди при 7 FPS)
   - Розмір: 1024×576
   - Плавна анімація сцени

---

## ✅ Готово!

Після завантаження SVD моделі ти зможеш:
- ✅ Конвертувати зображення у короткі відео
- ✅ Анімувати статичні сцени
- ✅ Створювати cinematic loops

**Час генерації відео на RTX 4070:** ~2-3 хвилини (14 frames) 🎬✨
