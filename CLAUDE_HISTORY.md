# AI Platform — Історія змін

---

## 02.02_18:00-23:11 — Налаштування відео генерації (WAN 2.2)

### Задача:
Налаштувати систему для генерації відео з зображень використовуючи WAN 2.2 та SVD моделі

### Статус: ⚠️ ЧАСТКОВО ВИКОНАНО
- ✅ Text-to-image моделі працюють (8 checkpoints в SwarmUI)
- ✅ WAN 2.2 моделі встановлені та налаштовані
- ✅ ComfyUI запущений і працює
- ❌ **Відео генерація НЕ ПРАЦЮЄ** (workflow потребує налагодження)
- ✅ **Картинки генеруються успішно**

### Виконані роботи:

#### 1. Виправлення SVD помилок
**Проблема:** SVD модель спричиняла помилки в SwarmUI (CLIPLoader errors)
**Рішення:**
- Видалено `diffusion_models` з `extra_model_paths.yaml`
- SVD переміщено в окрему папку `video_models/`
- SwarmUI більше не намагається завантажити відео моделі

**Файли:**
- `dlbackend/ComfyUI/extra_model_paths.yaml` — видалено diffusion_models

#### 2. Встановлення WAN 2.2 моделей
**Що встановлено:**
- ✅ `umt5_xxl_fp8_e4m3fn_scaled.safetensors` (6.7 GB) — WAN text encoder
- ✅ `wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors` (14 GB)
- ✅ `wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors` (14 GB)
- ✅ `wan_2.1_vae.safetensors` (243 MB)
- ✅ `wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors` (1.2 GB)
- ✅ `wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors` (1.2 GB)

**Розташування:**
```
models/
├── text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors
├── VAE/wan_2.1_vae.safetensors
├── diffusion_models/
│   ├── wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors
│   ├── wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
│   └── svd.safetensors
└── Lora/
    ├── wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors
    └── wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors
```

#### 3. Встановлення VideoHelperSuite
**Компоненти:**
- ✅ ComfyUI-VideoHelperSuite (custom nodes)
- ✅ opencv-python
- ✅ imageio-ffmpeg
- ✅ VHS_VideoCombine нода доступна

**Розташування:**
- `dlbackend/ComfyUI/custom_nodes/ComfyUI-VideoHelperSuite/`

#### 4. Створена документація

**Нові файли:**

1. **WAN_QUICK_START.md** (2.4 KB)
   - Повний гайд по використанню WAN 2.2
   - Порівняння моделей (High Noise vs Low Noise)
   - Приклади промптів (китайською та англійською)
   - Інструкції з використання LightX2V LoRA

2. **WAN_OPTIMIZATION.md** (5.1 KB)
   - Оптимізація для RTX 4070 12GB
   - Конфігурації (швидка/баланс/якість)
   - Troubleshooting та екстрена допомога
   - Порівняння ресурсів різних моделей

3. **VIDEO_GENERATION.md** (оновлено)
   - Додано інформацію про WAN 2.2 моделі
   - Порівняння SVD vs WAN High vs WAN Low
   - Таблиця вибору моделі за задачею

4. **CIVITAI_GUIDE.md** (оновлено)
   - Додано FAQ про SVD та відео генерацію
   - Оновлено структуру папок

5. **ERRORS_EXPLAINED.md** (3.2 KB)
   - Пояснення помилок CLIPLoader для SVD/WAN
   - Інструкції з вирішення типових проблем
   - Діагностичні команди

6. **COMFYUI_VIDEO_QUICK_START.md** (4.8 KB)
   - Покрокова інструкція для I2V моделей
   - Детальні таблиці параметрів
   - 3 приклади workflow

7. **SIMPLE_VIDEO_WORKFLOW.md** (2.1 KB)
   - Мінімальний workflow без CLIPLoader
   - Альтернатива з SaveImage замість VHS

8. **WAN_WORKFLOW.json** (47 KB)
   - Офіційний workflow від Comfy Org
   - Завантажено з GitHub

9. **WAN_SIMPLE_OPTIMIZED.json** (створено, але не протестовано)
   - Спрощений оптимізований workflow
   - Налаштовано для RTX 4070
   - 768x768, 14 frames, 4 steps з LoRA

**Оновлені файли:**
- `CLAUDE.md` — додано інформацію про відео моделі
- `MODELS_CHECK.md` — оновлено список моделей

#### 5. Оптимізація системи

**Для зменшення VRAM:**
- SwarmUI можна закривати під час відео генерації: `docker compose stop swarmui`
- Рекомендовані параметри: 768x768, 14 frames, 4 steps
- LightX2V LoRA дає 5x прискорення

**Конфігурація для RTX 4070 (швидка):**
```
Model: wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
LoRA: wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors
Resolution: 768x768
Frames: 14
Steps: 4
VRAM: ~8-9 GB
Час: 2-3 хвилини
```

### Проблеми та обмеження:

#### ❌ Відео генерація не працює
**Симптоми:**
- Workflow зависає під час генерації
- Можливо VRAM overflow
- Точна причина невідома

**Що працює:**
- ✅ ComfyUI запущений (http://127.0.0.1:7821)
- ✅ Всі моделі розпізнані
- ✅ Text-to-image генерація працює
- ✅ **Картинки генеруються успішно**

**Наступні кроки:**
- Налагодити WAN workflow
- Протестувати з мінімальними параметрами
- Перевірити логи на помилки
- Можливо спробувати SVD замість WAN

#### Поточний стан ресурсів:
- VRAM використано: ~2.5 GB з 12 GB
- RAM використано: ~1.4 GB з 23 GB
- SwarmUI: закритий (для економії VRAM)
- ComfyUI: запущений на порту 7821

### Статистика:

**Моделі:**
- Text-to-image: 8 checkpoints (SD 1.5, SDXL, Flux)
- Video diffusion: 2 моделі WAN + 1 SVD
- Text encoders: 3 файли (Flux CLIP-L, T5-XXL, WAN UMT5)
- VAE: 5 файлів
- LoRA: 4 адаптери
- **Всього:** ~47 GB відео моделей + 17 файлів для text-to-image

**Workflows:**
- WAN_WORKFLOW.json (офіційний, 47 KB)
- WAN_SIMPLE_OPTIMIZED.json (створений, не протестований)
- video_workflow_basic.json (базовий)

**Документація:**
- 9 нових MD файлів
- 2 JSON workflows
- Повна інструкція з встановлення та оптимізації

### Технічні деталі:

**Архітектура WAN 2.2:**
- 14 мільярдів параметрів (14B)
- FP8 квантизація для економії VRAM
- TEXT + IMAGE → VIDEO (не просто I2V як SVD!)
- Потребує спеціальний UMT5-XXL text encoder
- Підтримує китайські промпти (краща якість)

**Відмінності WAN від SVD:**
- WAN: Text + Image → Video (промпти покращують результат)
- SVD: Image → Video (тільки image-to-video)
- WAN: 14 GB vs SVD: 9 GB
- WAN: Краща якість, але повільніше

### Файли змінені:

```
Створено:
- WAN_QUICK_START.md
- WAN_OPTIMIZATION.md
- WAN_WORKFLOW.json
- WAN_SIMPLE_OPTIMIZED.json
- ERRORS_EXPLAINED.md
- COMFYUI_VIDEO_QUICK_START.md
- SIMPLE_VIDEO_WORKFLOW.md
- CLAUDE_HISTORY.md

Оновлено:
- VIDEO_GENERATION.md
- CIVITAI_GUIDE.md
- CLAUDE.md
- MODELS_CHECK.md
- dlbackend/ComfyUI/extra_model_paths.yaml

Встановлено:
- ComfyUI-VideoHelperSuite
- opencv-python
- imageio-ffmpeg
- umt5_xxl text encoder (6.7 GB)
```

### Наступні завдання (Етап 2):

1. **Налагодити відео генерацію:**
   - Протестувати WAN_SIMPLE_OPTIMIZED.json workflow
   - Виявити причину зависання
   - Оптимізувати параметри під RTX 4070

2. **Перевірити працездатність:**
   - Генерація з мінімальними параметрами (512x512, 10 frames)
   - Тест з/без LoRA
   - Порівняння WAN vs SVD

3. **Документувати робочу конфігурацію:**
   - Записати точні параметри що працюють
   - Створити покроковий гайд з скріншотами
   - Оновити troubleshooting секцію

---

## Посилання:

- ComfyUI: http://127.0.0.1:7821
- SwarmUI: http://127.0.0.1:7801 (зараз закритий)
- Workflows: `/mnt/g/Git/GitHub/ai-platform/*.json`
- Документація: `/mnt/g/Git/GitHub/ai-platform/*.md`

---

**Продовжимо роботу після переходу до Етапу 2** 🚀
