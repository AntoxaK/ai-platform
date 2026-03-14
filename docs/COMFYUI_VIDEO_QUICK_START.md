# ComfyUI Image-to-Video — Швидкий старт

## ❌ Проблема: CLIPLoader помилка

Якщо ви бачите помилку:
```
CLIPLoader
Internal: src/sentencepiece_processor.cc(237) [model_proto->ParseFromArray...]
```

**Причина:** Ви використовуєте **text-to-image** workflow замість **image-to-video** workflow.

**Рішення:** Image-to-video моделі (SVD, WAN) **НЕ використовують CLIP** — їм не потрібні текстові промпти!

---

## ✅ Правильний спосіб використання I2V моделей

### Крок 1: Відкрити ComfyUI
```
http://127.0.0.1:7821
```

### Крок 2: Завантажити готовий workflow

#### Опція A: Використати мій workflow (рекомендовано)

1. У ComfyUI натиснути **"Load"** (внизу справа)
2. Клікнути **"Upload"** або перетягнути файл:
   ```
   /mnt/g/Git/GitHub/ai-platform/video_workflow_basic.json
   ```
3. Workflow завантажиться автоматично

#### Опція B: Створити вручну

Якщо файл не працює, створіть workflow з наступних нод:

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

### Крок 3: Налаштувати параметри

#### У ноді "ImageOnlyCheckpointLoader":

Вибрати модель:
- **SVD:** `video_models/svd.safetensors`
- **WAN High:** `video_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors`
- **WAN Low:** `video_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors`

#### У ноді "LoadImage":

1. Клікнути **"Choose File"**
2. Вибрати зображення (1024x576 рекомендовано)
3. Формат: PNG, JPG

#### У ноді "SVD_img2vid_Conditioning":

**Для SVD або швидкого тесту:**
```
width: 1024
height: 576
video_frames: 14
motion_bucket_id: 127
fps: 6
augmentation_level: 0
```

**Для WAN High Noise (динамічні рухи):**
```
width: 1024
height: 576
video_frames: 25
motion_bucket_id: 180
fps: 8
augmentation_level: 0
```

**Для WAN Low Noise (плавні рухи):**
```
width: 1024
height: 576
video_frames: 25
motion_bucket_id: 100
fps: 6
augmentation_level: 0
```

#### У ноді "KSampler":

```
seed: (будь-яке число або "randomize")
steps: 20
cfg: 2.5
sampler_name: euler
scheduler: karras
denoise: 1.0
```

#### У ноді "VHS_VideoCombine":

```
frame_rate: 6 (або 8)
format: h264-mp4
filename_prefix: video_output
```

### Крок 4: Запустити генерацію

1. Натиснути **"Queue Prompt"** (праворуч вгорі)
2. Чекати 2-10 хвилин (залежно від моделі)
3. Відео збережеться в: `output/`

---

## 🎯 Параметри детально

### motion_bucket_id (Кількість руху)

| Значення | Ефект | Використання |
|----------|-------|--------------|
| **0-50** | Майже статичне | Дуже легкі рухи (дихання, моргання) |
| **50-100** | Легкий рух | Вітер, хмари, легкі жести |
| **100-150** | Помірний рух | Ходьба, звичайні рухи |
| **150-200** | Активний рух | Біг, танці, активні дії |
| **200-255** | Дуже динамічно | Швидкі рухи, спорт |

### video_frames (Кількість кадрів)

| Значення | Тривалість @ 6fps | Тривалість @ 8fps | VRAM | Час генерації |
|----------|-------------------|-------------------|------|---------------|
| **14** | ~2.3 сек | ~1.75 сек | ~10 GB | 2-5 хв |
| **21** | ~3.5 сек | ~2.6 сек | ~11 GB | 4-7 хв |
| **25** | ~4.2 сек | ~3.1 сек | ~12 GB | 5-10 хв |

### fps (Кадрів на секунду)

| Значення | Ефект |
|----------|-------|
| **6** | Повільна, плавна анімація |
| **8** | Стандартна швидкість |
| **12** | Швидка, динамічна анімація |

### augmentation_level (Рівень аугментації)

| Значення | Ефект |
|----------|-------|
| **0.0** | Без змін (рекомендовано) |
| **0.1-0.3** | Легкі варіації |
| **0.5+** | Сильні зміни (може бути хаотично) |

---

## 📋 Типові помилки та рішення

### Помилка 1: CLIPLoader sentencepiece error

**Причина:** Використовується text-to-image workflow

**Рішення:** Видалити всі ноди **CLIPLoader** та **CLIPTextEncode** з workflow. I2V моделі їх не потребують!

### Помилка 2: Model not found

**Причина:** Неправильний шлях до моделі

**Рішення:** У ноді "ImageOnlyCheckpointLoader" вкажіть:
```
video_models/svd.safetensors
video_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors
video_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
```

### Помилка 3: Out of memory (CUDA)

**Причина:** VRAM переповнений

**Рішення:**
1. Зменшити `video_frames` до 14
2. Зменшити роздільність (768x576 замість 1024x576)
3. Закрити SwarmUI під час генерації відео
4. Використати SVD замість WAN (менше VRAM)

### Помилка 4: VHS_VideoCombine not found

**Причина:** Custom nodes не встановлені

**Рішення:**
```bash
cd /mnt/g/Git/GitHub/ai-platform/dlbackend/ComfyUI/custom_nodes
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
# Перезапустити ComfyUI
```

---

## 🎨 Приклади використання

### Приклад 1: Портрет з легким рухом (SVD)

**Модель:** `video_models/svd.safetensors`

**Параметри:**
```
width: 1024
height: 576
video_frames: 14
motion_bucket_id: 80
fps: 6
```

**Результат:** Моргання, легкий рух волосся, дихання

### Приклад 2: Пейзаж з рухом хмар (WAN Low)

**Модель:** `video_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors`

**Параметри:**
```
width: 1024
height: 576
video_frames: 25
motion_bucket_id: 100
fps: 6
```

**Результат:** Плавний рух хмар, легке коливання дерев

### Приклад 3: Людина що йде (WAN High)

**Модель:** `video_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors`

**Параметри:**
```
width: 1024
height: 576
video_frames: 25
motion_bucket_id: 180
fps: 8
```

**Результат:** Активна ходьба, рух одягу, природна анімація

---

## 🔧 Швидкі команди

```bash
# Перевірити чи ComfyUI запущений
curl -s http://127.0.0.1:7821/system_stats

# Переглянути доступні відео моделі
ls -lh /mnt/g/Git/GitHub/ai-platform/video_models/

# Переглянути згенеровані відео
ls -lht /mnt/g/Git/GitHub/ai-platform/output/ | head -10

# Відкрити папку output
cd /mnt/g/Git/GitHub/ai-platform/output
```

---

## ✅ Контрольний список

Перед генерацією переконайтесь:

- [ ] Використовуєте **ImageOnlyCheckpointLoader** (НЕ CheckpointLoaderSimple)
- [ ] У workflow **НЕМАЄ** нод CLIPLoader або CLIPTextEncode
- [ ] Вибрана правильна модель (`video_models/...`)
- [ ] Завантажене вхідне зображення (1024x576)
- [ ] Налаштовані параметри (motion_bucket_id, fps, video_frames)
- [ ] ComfyUI запущений (http://127.0.0.1:7821)
- [ ] Є вільний VRAM (~10-12 GB)

---

**Готово! Тепер ви можете генерувати відео з будь-якої з трьох моделей!** 🎬✨

**Швидкий старт:**
1. Відкрити ComfyUI: http://127.0.0.1:7821
2. Завантажити workflow: `video_workflow_basic.json`
3. Вибрати модель: `video_models/svd.safetensors`
4. Завантажити зображення
5. Queue Prompt!
