# WAN 2.2 Image-to-Video — Готово до використання! 🎬

## ✅ Всі моделі встановлені:

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

**Всього:** ~47 GB моделей для відео генерації

---

## 🚀 Як використовувати (3 кроки):

### Крок 1: Відкрити ComfyUI
```
http://127.0.0.1:7821
```

### Крок 2: Завантажити офіційний WAN workflow

**Варіант A:** Перетягнути файл
- Перетягніть файл на ComfyUI:
  ```
  /mnt/g/Git/GitHub/ai-platform/WAN_WORKFLOW.json
  ```
- Або у Windows:
  ```
  G:\Git\GitHub\ai-platform\WAN_WORKFLOW.json
  ```

**Варіант B:** Load через UI
1. Натиснути **Load** (праворуч внизу)
2. Клікнути **Upload**
3. Вибрати `WAN_WORKFLOW.json`

### Крок 3: Налаштувати і запустити

#### У workflow з'являться ноди:
1. **CLIPLoader** → umt5_xxl_fp8_e4m3fn_scaled.safetensors ✓
2. **CLIPTextEncode (Positive)** → ваш промпт китайською
3. **CLIPTextEncode (Negative)** → негативний промпт
4. **LoadImage** → завантажте зображення
5. **DiffusionModelLoader** → wan2.2_i2v_high_noise або low_noise
6. **VAELoader** → wan_2.1_vae.safetensors
7. **KSampler** → генерація
8. **VHS_VideoCombine** → збереження відео

#### Що змінити:

**1. Завантажити зображення:**
- Нода **LoadImage** → Choose File
- Роздільність: 768x768 або 1024x576

**2. Вибрати модель:**
- Нода **DiffusionModelLoader**:
  - `wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors` — динамічні рухи
  - `wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors` — плавні рухи

**3. Написати промпт (китайською!):**
- Workflow використовує китайські промпти
- Приклад: `一只可爱的猫咪在走路` (кіт що йде)
- Або англійською, але якість гірша

**4. Налаштувати параметри:**
- `num_frames`: 14-25 (кількість кадрів)
- `motion_strength`: 0.5-1.0 (сила руху)
- `fps`: 6-8 (швидкість відео)

**5. Queue Prompt:**
- Натиснути **Queue Prompt**
- Чекати 5-15 хвилин
- Відео з'явиться в `output/`

---

## 📊 Порівняння моделей:

| Модель | Використання | VRAM | Швидкість |
|--------|--------------|------|-----------|
| **High Noise** | Активні рухи, динамічні сцени | ~12 GB | 5-10 хв |
| **Low Noise** | Плавні рухи, статичні об'єкти | ~12 GB | 5-10 хв |
| **+ LightX2V LoRA** | Швидка генерація (4 кроки) | ~12 GB | 2-5 хв |

---

## 🎯 Приклади промптів:

### Китайською (краща якість):

**Кіт що йде:**
```
正面: 一只可爱的猫咪在草地上慢慢走路，阳光明媚，高质量，4k
负面: 色调艳丽，过曝，静态，模糊，低质量
```

**Людина:**
```
正面: 一个女孩在海滩上奔跑，长发飘扬，自然光线，专业摄影
负面: 静止不动，模糊，变形，低质量
```

**Пейзаж:**
```
正面: 美丽的山景，云朵移动，树叶轻轻摇曳，高质量视频
负面: 静态，过曝，模糊
```

### Англійською (працює, але гірше):

**Cat walking:**
```
Positive: a cute cat walking on grass, sunny day, high quality, detailed
Negative: static, blurry, low quality, deformed
```

---

## 🔧 Додаткові можливості:

### Використання LightX2V LoRA (швидша генерація):

У workflow є нода **LoraLoader**:
1. Вибрати LoRA:
   - `wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors`
   - `wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors`
2. Встановити weight: 0.8-1.0
3. У KSampler змінити steps на 4 (замість 20)

**Результат:** Генерація за 2-5 хвилин замість 5-10!

---

## 📝 Параметри KSampler:

| Параметр | Рекомендоване | Опис |
|----------|---------------|------|
| **steps** | 20 (або 4 з LoRA) | Кількість кроків |
| **cfg** | 2.5-3.5 | CFG scale |
| **sampler_name** | euler | Семплер |
| **scheduler** | normal | Планувальник |
| **denoise** | 1.0 | Денойзинг |

---

## ⚠️ Важливо:

### ✅ ТАК використовувати:
- CLIPLoader з umt5_xxl (це WAN text encoder!)
- CLIPTextEncode для промптів
- Китайські промпти для кращої якості
- 14-25 кадрів для відео

### ❌ НЕ використовувати:
- Звичайний CLIP для SD моделей
- Надто довгі промпти (>512 токенів)
- Занадто високу роздільність (>1024x1024)

---

## 🎬 Результат:

Після генерації отримаєте:
- MP4 відео у `output/`
- Тривалість: ~2-4 секунди
- FPS: 6-8
- Роздільність: така ж як вхідне зображення

---

## 🔍 Troubleshooting:

### Помилка: "CUDA out of memory"
**Рішення:**
- Зменшити `num_frames` до 14
- Закрити SwarmUI
- Використати LightX2V LoRA

### Помилка: "Model not found"
**Рішення:**
- Перевірити шляхи до моделей
- Перезапустити ComfyUI: `bash start.sh`

### Відео статичне (немає руху)
**Рішення:**
- Збільшити `motion_strength` до 0.8-1.0
- Використати `high_noise` модель
- Покращити промпт (додати дієслова руху)

---

## 📖 Офіційна документація:

- **Comfy Docs:** https://docs.comfy.org/tutorials/video/wan/wan2_2
- **WAN 2.2 GitHub:** https://github.com/ali-vilab/VGen
- **Workflow Template:** https://github.com/Comfy-Org/workflow_templates

---

**Готово! Відкрийте ComfyUI і завантажте workflow!** 🎬✨

**Швидкий старт:**
```bash
# 1. ComfyUI вже запущений на http://127.0.0.1:7821
# 2. Перетягніть WAN_WORKFLOW.json
# 3. Завантажте зображення
# 4. Queue Prompt!
```
