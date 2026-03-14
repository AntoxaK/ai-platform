# Довідник Civitai для AI Platform

Швидкий довідник для завантаження моделей з https://civitai.com

---

## 🎯 Швидкий старт

### Крок 1: Відкрити Civitai
```
https://civitai.com/models
```

### Крок 2: Застосувати фільтри

**Обов'язкові фільтри:**
1. **Format**: `SafeTensor` ✓ (завжди безпечніше)
2. **Base Model**: Виберіть одну з таблиці нижче ↓
3. **Model Type**: Виберіть тип (Checkpoint, LoRA, etc.)

### Крок 3: Завантажити у правильну папку

| Civitai Model Type | Папка на диску |
|-------------------|----------------|
| Checkpoint | `G:\Git\GitHub\ai-platform\models\Stable-Diffusion\` |
| LoRA, LoCon, LoHa | `G:\Git\GitHub\ai-platform\models\Lora\` |
| VAE | `G:\Git\GitHub\ai-platform\models\VAE\` |
| Embedding, Textual Inversion | `G:\Git\GitHub\ai-platform\models\Embeddings\` |
| ControlNet, Controlnet (T2I) | `G:\Git\GitHub\ai-platform\models\ControlNet\` |

### Крок 4: Оновити SwarmUI
```
http://127.0.0.1:7801
→ Server → Utilities → Refresh Models
```

---

## 📊 Фільтр Base Model — що обирати?

### Для RTX 4070 (12GB VRAM)

| Civitai Base Model | VRAM | Швидкість | Якість | Рекомендація |
|-------------------|------|-----------|--------|--------------|
| **SD 1.5** | ~4 GB ✓ | ⚡⚡⚡ Дуже швидко | ⭐⭐⭐ Добре | Для тестів, швидкої генерації |
| **SDXL 1.0** | ~6-8 GB ✓ | ⚡⚡ Середньо | ⭐⭐⭐⭐ Відмінно | **🏆 РЕКОМЕНДОВАНО** — найкращий баланс |
| **SDXL Turbo** | ~6 GB ✓ | ⚡⚡⚡ Швидко | ⭐⭐⭐⭐ Відмінно | Для швидкої якісної генерації |
| **SDXL Lightning** | ~6 GB ✓ | ⚡⚡⚡ Швидко | ⭐⭐⭐⭐ Відмінно | 1-4 кроки, дуже швидко |
| **Pony** | ~6-8 GB ✓ | ⚡⚡ Середньо | ⭐⭐⭐⭐ Відмінно | Для аніме, furry, стилізації |
| **Flux.1 S** | ~10 GB ✓ | ⚡⚡ Швидко | ⭐⭐⭐⭐⭐ Найкраще | **🏆 Найвища якість**, 4 кроки |
| **Flux.1 D** | ~12 GB ⚠ | ⚡ Повільно | ⭐⭐⭐⭐⭐ Найкраще | Максимальна якість (FP8!) |
| **SD 3.5 Large** | ~12 GB ⚠ | ⚡ Повільно | ⭐⭐⭐⭐⭐ Найкраще | Нова архітектура |
| **SD 3.5 Medium** | ~5 GB ✓ | ⚡⚡ Середньо | ⭐⭐⭐⭐ Відмінно | Легша версія SD 3.5 |

**Легенда:**
- ✓ — Працює комфортно на RTX 4070 12GB
- ⚠ — Працює, але потребує FP8 або offloading

---

## 🎨 Популярні моделі за категоріями

### Реалістичні фото (SDXL)

**Фільтри Civitai:**
- Base Model: `SDXL 1.0`
- Model Type: `Checkpoint`
- Tags: `realistic`, `photorealistic`

**Рекомендовані моделі:**
- Juggernaut XL ✓ (вже є)
- RealVisXL
- DreamshaperXL
- ProteusV0.4
- CopaxTimelessxlSDXL1

### Аніме (SDXL/Pony)

**Фільтри Civitai:**
- Base Model: `SDXL 1.0` або `Pony`
- Model Type: `Checkpoint`
- Tags: `anime`, `illustration`

**Рекомендовані моделі:**
- NovaAnimeXL ✓ (вже є)
- AnimagineXL
- Pony Diffusion V6
- AutismMix (Pony)
- AnythingXL

### Пейзажі та локації (SDXL)

**Фільтри Civitai:**
- Base Model: `SDXL 1.0`
- Model Type: `Checkpoint`
- Tags: `landscape`, `scenery`

**Рекомендовані моделі:**
- Kodorail ✓ (вже є)
- RealitiesEdgeXL
- Copax Turbo

### Швидка генерація (SD 1.5)

**Фільтри Civitai:**
- Base Model: `SD 1.5`
- Model Type: `Checkpoint`

**Рекомендовані моделі:**
- DreamShaper 8 ✓ (вже є)
- Realistic Vision V6.0 ✓ (вже є)
- MajicMix Realistic ✓ (вже є)

### Найвища якість (Flux)

**Фільтри Civitai:**
- Base Model: `Flux.1 D` або `Flux.1 S`
- Model Type: `Checkpoint` або `LoRA`

**Рекомендовані моделі:**
- zImageBase ✓ (вже є — Flux Schnell)
- Flux.1 Dev (офіційна, потребує FP8)
- Flux Realism LoRA
- Flux Uncensored LoRA

---

## 🔧 Додаткові типи моделей

### LoRA (адаптери стилю)

**Що таке:** Малі файли (10-200 MB), що модифікують стиль checkpoint моделі

**Фільтри Civitai:**
- Model Type: `LoRA`
- Base Model: Той же, що у вашого checkpoint (SD 1.5, SDXL, Pony, Flux)

**Популярні категорії:**
- **Style LoRA**: Арт стилі (акварель, олія, аніме)
- **Character LoRA**: Конкретні персонажі (з аніме, фільмів, ігор)
- **Detail LoRA**: Покращення деталей (руки, обличчя, текстури)
- **Clothing LoRA**: Одяг, костюми
- **NSFW LoRA**: 🔞 Дорослий контент

**Приклади:**
- `Detail Tweaker LoRA` (покращення деталей)
- `Add More Details` (різкість, деталізація)
- `Anime Lineart LoRA` (контури)
- Hands + Feet + skin v1.1 ✓ (вже є)
- NSFW_master_ZIT ✓ (вже є)

**Папка:** `models/Lora/`

### VAE (декодер зображень)

**Що таке:** Файл, що перетворює латентний простір у фінальне зображення (кольори, різкість)

**Популярні:**
- `sdxl_vae.safetensors` ✓ (вже є) — для SDXL
- `vae-ft-mse-840000-ema-pruned.safetensors` ✓ (вже є) — для SD 1.5

**Примітка:** Багато моделей мають вбудований VAE ("baked-in VAE"), тому окремий не потрібен

**Папка:** `models/VAE/`

### Embeddings (текстові інверсії)

**Що таке:** Малі файли (10-100 KB), що додають концепти через ключові слова

**Фільтри Civitai:**
- Model Type: `Embedding` або `Textual Inversion`

**Популярні (для негативних промптів):**
- `EasyNegative`
- `BadDream`
- `UnrealisticDream`
- `FastNegative`

**Використання:** Додайте назву у промпт, наприклад: `EasyNegative` у Negative Prompt

**Папка:** `models/Embeddings/`

### ControlNet (контроль композиції)

**Що таке:** Моделі для точного контролю композиції через референсні зображення

**Фільтри Civitai:**
- Model Type: `ControlNet`
- Base Model: Той же, що у checkpoint

**Типи ControlNet:**
- **Canny** — контури об'єктів
- **Depth** — карта глибини
- **OpenPose** — скелет людини (пози)
- **Scribble** — малюнки від руки
- **Normal map** — напрямки освітлення
- **Lineart** — лінійні малюнки

**Папка:** `models/ControlNet/`

---

## 📂 Всі папки для моделей

```
G:\Git\GitHub\ai-platform\models\
│
├── Stable-Diffusion\       ← Checkpoint моделі (основні)
│   ├── dreamshaper_8.safetensors (SD 1.5) ✓
│   ├── majicmixRealistic_v7.safetensors (SD 1.5) ✓
│   ├── realisticVisionV60B1_v51HyperVAE.safetensors (SD 1.5) ✓
│   ├── hsUltrahdCG_illepic.safetensors (SDXL) ✓
│   ├── juggernautXL_ragnarokBy.safetensors (SDXL) ✓
│   ├── kodorail_v120.safetensors (SDXL) ✓
│   ├── novaAnimeXL_ilV160.safetensors (SDXL) ✓
│   ├── zImageBase_base.safetensors (Flux) ✓
│   └── svd.safetensors (Video) ✓
│
├── Lora\                   ← LoRA, LoCon, LoHa адаптери
│   ├── Hands + Feet + skin v1.1.safetensors ✓
│   └── NSFW_master_ZIT_000008766.safetensors ✓
│
├── VAE\                    ← VAE декодери
│   ├── sdxl_vae.safetensors ✓
│   └── vae-ft-mse-840000-ema-pruned.safetensors ✓
│
├── Embeddings\             ← Textual inversions
│   └── (додавайте сюди)
│
├── ControlNet\             ← ControlNet моделі
│   └── (додавайте сюди)
│
├── text_encoders\          ← Text encoders для Flux/SD3
│   ├── clip_l.safetensors ✓
│   └── t5xxl_fp8_e4m3fn.safetensors ✓
│
├── clip_vision\            ← CLIP Vision для IP-Adapter
│   └── (автоматично завантажується)
│
├── upscale_models\         ← Upscaler моделі (ESRGAN)
│   └── (додавайте з OpenModelDB)
│
├── ipadapter\              ← IP-Adapter моделі
│   └── (додавайте сюди)
│
├── animatediff_models\     ← AnimateDiff motion modules
│   └── (для відео генерації)
│
├── animatediff_motion_lora\ ← AnimateDiff LoRA
│   └── (для відео генерації)
│
└── diffusion_models\       ← Спеціалізовані diffusion моделі
    └── svd.safetensors ✓   (Stable Video Diffusion, 9.0 GB)
```

**Позначка ✓** = вже встановлено

---

## ⚙️ Після завантаження моделі

### Варіант 1: Через веб-інтерфейс (РЕКОМЕНДОВАНО)

1. Відкрити SwarmUI:
   ```
   http://127.0.0.1:7801
   ```

2. Внизу зліва натиснути **"Server"**

3. Вибрати **"Utilities"**

4. Натиснути **"Refresh Models"**

5. Зачекати 5-10 секунд

6. Оновити сторінку (F5)

### Варіант 2: Через Docker

```bash
cd /mnt/g/Git/GitHub/ai-platform
docker compose restart swarmui
```

**Примітка:** ComfyUI перезапускати НЕ потрібно — він автоматично бачить нові файли.

---

## 🎓 Приклади фільтрів Civitai

### Приклад 1: Реалістичний портрет (SDXL)

**Фільтри:**
- Base Model: `SDXL 1.0` ✓
- Model Type: `Checkpoint` ✓
- Tags: `realistic`, `portrait`, `photorealistic`
- Format: `SafeTensor` ✓

**Результат:** Знайде моделі типу JuggernautXL, RealVisXL

**Папка:** `models/Stable-Diffusion/`

### Приклад 2: Аніме LoRA для SDXL

**Фільтри:**
- Base Model: `SDXL 1.0` ✓
- Model Type: `LoRA` ✓
- Tags: `anime`, `style`
- Format: `SafeTensor` ✓

**Результат:** Знайде LoRA для аніме стилізації

**Папка:** `models/Lora/`

### Приклад 3: ControlNet для поз (SDXL)

**Фільтри:**
- Base Model: `SDXL 1.0` ✓
- Model Type: `ControlNet` ✓
- Tags: `openpose`, `pose`
- Format: `SafeTensor` ✓

**Результат:** Знайде OpenPose ControlNet для SDXL

**Папка:** `models/ControlNet/`

### Приклад 4: Негативні embeddings

**Фільтри:**
- Base Model: `SD 1.5` або `SDXL 1.0` ✓
- Model Type: `Embedding` або `Textual Inversion` ✓
- Tags: `negative`, `quality`

**Результат:** Знайде EasyNegative, BadDream, etc.

**Папка:** `models/Embeddings/`

### Приклад 5: Flux LoRA для реалізму

**Фільтри:**
- Base Model: `Flux.1 D` або `Flux.1 S` ✓
- Model Type: `LoRA` ✓
- Tags: `realism`, `photography`
- Format: `SafeTensor` ✓

**Результат:** Знайде Flux Realism, Flux Uncensored, etc.

**Папка:** `models/Lora/`

---

## ❓ Часті питання

### Питання: Скільки моделей можна встановити?

**Відповідь:** Необмежено! Checkpoint моделі займають 2-12 GB кожна, LoRA — 10-200 MB. У вас є 1.2 TB вільного місця.

### Питання: Чи можна використовувати SD 1.5 LoRA з SDXL моделями?

**Відповідь:** Ні. LoRA повинна відповідати Base Model checkpoint моделі:
- SD 1.5 LoRA → тільки для SD 1.5 моделей
- SDXL LoRA → тільки для SDXL моделей
- Flux LoRA → тільки для Flux моделей

### Питання: Що таке "baked-in VAE"?

**Відповідь:** Це означає, що модель вже містить VAE всередині. Не потрібно завантажувати окремий VAE файл.

### Питання: Навіщо потрібен окремий VAE?

**Відповідь:** VAE покращує кольори та різкість. Якщо модель не має baked-in VAE, або ви хочете експериментувати з різними VAE — завантажте окремий.

### Питання: Що краще — Checkpoint чи LoRA?

**Відповідь:**
- **Checkpoint** = основна модель (обов'язково потрібна)
- **LoRA** = модифікатор (додається до checkpoint)
- Використовуйте: 1 checkpoint + 0-5 LoRA одночасно

### Питання: Чому Flux моделі такі великі?

**Відповідь:** Flux модульний:
- Main model: ~10 GB
- CLIP-L: 235 MB ✓ (вже є)
- T5-XXL (FP8): 4.6 GB ✓ (вже є)
- VAE: ~335 MB
- **Всього: ~15 GB**

Але якість найвища!

### Питання: Що таке FP8 квантизація?

**Відповідь:** Зменшення точності (Float Point 8-bit замість 16-bit) для економії VRAM:
- FP16: 9.8 GB (повна точність)
- FP8: 4.6 GB (мінімальна втрата якості)
- Для RTX 4070 12GB використовуйте FP8!

### Питання: Де шукати Upscaler моделі?

**Відповідь:**
- OpenModelDB: https://openmodeldb.info
- Hugging Face: https://huggingface.co/models?pipeline_tag=image-to-image

Популярні: RealESRGAN, ESRGAN, SwinIR, UltraSharp

**Папка:** `models/upscale_models/`

### Питання: Чому SVD не з'являється в списку моделей SwarmUI?

**Відповідь:** SVD (Stable Video Diffusion) - це **image-to-video** модель, яка НЕ підтримує text-to-image генерацію. Вона:
- Не має text encoder (CLIP)
- Використовується тільки через ComfyUI workflows
- Генерує відео з одного зображення
- Розташована в `models/diffusion_models/`

**Докладніше:** Див. `VIDEO_GENERATION.md`

### Питання: Як генерувати відео?

**Відповідь:** Є два варіанти:

**Варіант 1: SVD (image-to-video)**
- Використовує одне зображення як вхід
- Генерує 14-25 кадрів (~2-3 секунди)
- Найвища якість
- Див. `VIDEO_GENERATION.md`

**Варіант 2: AnimateDiff (text-to-video)**
- Використовує текстовий промпт
- Працює з SD 1.5 / SDXL моделями
- Можна додавати LoRA
- Завантажте motion modules з Civitai

---

## 🔗 Корисні посилання

- **Civitai**: https://civitai.com/models
- **Hugging Face**: https://huggingface.co/models?pipeline_tag=text-to-image
- **OpenModelDB** (upscalers): https://openmodeldb.info
- **SwarmUI Docs**: https://github.com/mcmonkeyprojects/SwarmUI/tree/master/docs

---

## ✅ Контрольний список перед завантаженням

- [ ] Перевірив Base Model (SD 1.5, SDXL, Flux, etc.)
- [ ] Перевірив Model Type (Checkpoint, LoRA, VAE, etc.)
- [ ] Обрав формат `.safetensors` (НЕ .ckpt, НЕ .pt)
- [ ] Перевірив розмір файлу (чи вистачить місця)
- [ ] Знаю куди класти файл (Stable-Diffusion, Lora, VAE, etc.)
- [ ] Знаю як оновити список моделей (Server → Utilities → Refresh Models)

---

**Готово! Тепер ви можете завантажувати моделі з Civitai з впевненістю!** 🎨✨
