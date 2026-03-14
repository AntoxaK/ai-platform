# Перевірка моделей у SwarmUI

## ✅ Система перезавантажена

**Дата:** $(date +"%d.%m.%Y %H:%M")

### Стан системи:
- ✓ ComfyUI v0.11.1 — запущений (http://127.0.0.1:7821)
- ✓ SwarmUI — запущений (http://127.0.0.1:7801)
- ✓ GPU: NVIDIA RTX 4070 (12GB VRAM)
- ✓ Кеш метаданих очищено

---

## 📦 Доступні моделі (підтверджено ComfyUI API)

### Checkpoints: 8 моделей (text-to-image)

**SD 1.5 (3 моделі):**
- ✓ dreamshaper_8.safetensors
- ✓ majicmixRealistic_v7.safetensors
- ✓ realisticVisionV60B1_v51HyperVAE.safetensors

**SDXL (4 моделі):**
- ✓ hsUltrahdCG_illepic.safetensors
- ✓ juggernautXL_ragnarokBy.safetensors
- ✓ kodorail_v120.safetensors
- ✓ novaAnimeXL_ilV160.safetensors

**Flux (1 модель):**
- ✓ zImageBase_base.safetensors

### VAE: 3 моделі
- ✓ sdxl_vae.safetensors
- ✓ vae-ft-mse-840000-ema-pruned.safetensors
- ✓ pixel_space (вбудований)

### LoRA: 2 адаптери
- ✓ Hands + Feet + skin v1.1.safetensors (163 MB)
- ✓ NSFW_master_ZIT_000008766.safetensors (1.2 GB)

### Video Diffusion Models: 1 модель
- ✓ svd.safetensors (9.0 GB) — Stable Video Diffusion (image-to-video)

**Примітка:** SVD не з'являється в SwarmUI, бо використовується через ComfyUI workflows для генерації відео.
**Докладніше:** `VIDEO_GENERATION.md`

---

## 🎯 Як перевірити моделі у SwarmUI

### Крок 1: Відкрити SwarmUI
```
http://127.0.0.1:7801
```

### Крок 2: Оновити список моделей (якщо потрібно)
1. Знизу ліворуч натиснути **"Server"**
2. Вибрати **"Utilities"**
3. Натиснути **"Refresh Models"**
4. Зачекати 5-10 секунд
5. Оновити сторінку (F5)

### Крок 3: Перевірити випадаючий список
Клікнути на поле **"Model"** зверху — має з'явитися всі 8 моделей:

```
Випадаюче меню "Model":
├── dreamshaper_8
├── majicmixRealistic_v7
├── realisticVisionV60B1_v51HyperVAE
├── hsUltrahdCG_illepic
├── juggernautXL_ragnarokBy
├── kodorail_v120
├── novaAnimeXL_ilV160
└── zImageBase_base
```

**Примітка:** SVD (Stable Video Diffusion) більше не з'являється тут, бо переміщено в `models/diffusion_models/` для використання через ComfyUI workflows.

### Крок 4: Перевірити VAE
Якщо є поле **"VAE"** (може бути в Advanced settings):

```
Випадаюче меню "VAE":
├── Automatic
├── sdxl_vae
├── vae-ft-mse-840000-ema-pruned
└── pixel_space
```

### Крок 5: Перевірити LoRA
У розділі **"LoRA"** або **"Add LoRA"**:

```
Випадаюче меню "LoRA":
├── Hands + Feet + skin v1.1
└── NSFW_master_ZIT_000008766
```

---

## 🧪 Швидкий тест

### Тест 1: SD 1.5 модель
```
Model: majicmixRealistic_v7
VAE: vae-ft-mse-840000-ema-pruned
Prompt: portrait of a person
Steps: 20
```

### Тест 2: SDXL модель
```
Model: juggernautXL_ragnarokBy
VAE: sdxl_vae
Prompt: beautiful landscape
Steps: 25
```

### Тест 3: Flux модель
```
Model: zImageBase_base
VAE: automatic
Prompt: high quality photo
Steps: 20
CFG: 3.5
```

### Тест 4: SDXL + LoRA
```
Model: novaAnimeXL_ilV160
VAE: sdxl_vae
LoRA: Hands + Feet + skin v1.1 (weight: 0.8)
Prompt: anime girl, detailed hands
Steps: 28
```

---

## 🔧 Якщо моделі не видно

### 1. Оновити через UI
```
Server → Utilities → Refresh Models → Зачекати → F5
```

### 2. Перезапустити SwarmUI
```bash
cd /mnt/g/Git/GitHub/ai-platform
docker compose restart swarmui
```

### 3. Повний перезапуск
```bash
cd /mnt/g/Git/GitHub/ai-platform
./stop.sh
./start.sh
```

### 4. Очистити кеш та перезапустити
```bash
cd /mnt/g/Git/GitHub/ai-platform
rm -f data/model_metadata*.ldb
docker compose restart swarmui
```

---

## 📂 Розташування моделей

```
/mnt/g/Git/GitHub/ai-platform/models/
├── Stable-Diffusion/      → 9 checkpoint моделей
├── VAE/                   → 2 VAE файли
├── Lora/                  → 2 LoRA адаптери
└── [інші папки]
```

---

## 🎨 Готові пресети

У файлі `data/AI-Platform-Presets.json` є 9 готових пресетів:

1. **SDXL Portrait** — портрети (JuggernautXL)
2. **SDXL Landscape** — пейзажі (Kodorail)
3. **SDXL Anime** — аніме (NovaAnimeXL)
4. **SD 1.5 Fast** — швидка генерація (DreamShaper)
5. **Flux High Quality** — максимальна якість (Flux)
6. **NSFW Flux** 🔞 — дорослий контент (Flux + NSFW LoRA)
7. **Cats Realistic** 🐱 — реалістичні котики
8. **Cats SDXL** 🐱 — котики SDXL
9. **Cats Anime** 🐱 — котики аніме

**Як імпортувати:** Див. `HOW_TO_USE_PRESETS.md`

## 📥 Завантаження нових моделей

**Детальний довідник:** `CIVITAI_GUIDE.md`

Швидкий старт:
1. Відкрити https://civitai.com/models
2. Фільтри:
   - Format: `SafeTensor` ✓
   - Base Model: `SDXL 1.0` (рекомендовано для RTX 4070)
   - Model Type: `Checkpoint`, `LoRA`, `VAE`, etc.
3. Завантажити у відповідну папку (див. CIVITAI_GUIDE.md)
4. SwarmUI → Server → Utilities → Refresh Models

---

## ✅ Контрольний список

- [x] ComfyUI запущений і бачить 8 text-to-image checkpoints
- [x] ComfyUI бачить 1 video diffusion model (SVD)
- [x] ComfyUI бачить 3 VAE
- [x] ComfyUI бачить 2 LoRA
- [x] SwarmUI запущений
- [x] Кеш метаданих очищено
- [x] Система готова до роботи

**Якщо всі моделі не відображаються у SwarmUI:**
→ Використайте **Server → Utilities → Refresh Models** у веб-інтерфейсі
→ Або перезапустіть: `docker compose restart swarmui`

---

**Система готова! Відкрийте http://127.0.0.1:7801 та почніть генерувати!** 🎨✨
