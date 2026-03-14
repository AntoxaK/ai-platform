# Як використовувати пресети у SwarmUI

## 📖 Важлива різниця

### ❌ Examples (те, що ви бачили) ≠ Presets

**"Examples/Basic SDXL"** на вашому скріншоті - це:
- Демонстраційні зображення (з готовими результатами)
- Вбудовані в SwarmUI
- НЕ можна додати свої

**"Presets"** (те, що потрібно) - це:
- Збережені налаштування параметрів
- Можна створювати, імпортувати, експортувати
- Знаходяться в окремій вкладці

---

## 🎯 Метод 1: Імпорт готових пресетів (РЕКОМЕНДОВАНО)

### Крок 1: Відкрити SwarmUI
```
http://127.0.0.1:7801
```

### Крок 2: Знайти вкладку "Presets"

**Варіант A:** Внизу екрану є вкладки:
```
Simple | Generate | Comfy Workflow | Utilities | User | Server
```
Шукайте вкладку **"Presets"** (може бути у меню **"User"** або окремо)

**Варіант B:** Біля поля Model може бути кнопка **"💾"** або **"Presets"**

### Крок 3: Імпортувати пресети

1. Натиснути кнопку **"Import Presets"** або **"📁 Import"**
2. Вибрати файл:
   ```
   /mnt/g/Git/GitHub/ai-platform/data/AI-Platform-Presets.json
   ```
   (або у Windows: `G:\Git\GitHub\ai-platform\data\AI-Platform-Presets.json`)
3. Натиснути **"Import"**
4. Закрити діалог

### Крок 4: Використовувати пресети

Тепер у списку пресетів з'являться всі 9 пресетів:
- ✓ SDXL Portrait
- ✓ SDXL Landscape
- ✓ SDXL Anime
- ✓ SD 1.5 Fast
- ✓ Flux High Quality
- ✓ 🔞 NSFW Flux
- ✓ 🐱 Cats Realistic
- ✓ 🐱 Cats SDXL
- ✓ 🐱 Cats Anime

Клікніть на пресет → параметри застосуються автоматично!

---

## 🎯 Метод 2: Якщо не знайдете вкладку Presets

Можливо, у вашій версії SwarmUI UI трохи інший. Ось альтернативні способи:

### Спосіб A: Через Generate вкладку

1. Відкрити вкладку **"Generate"**
2. Шукати кнопку **"💾 Presets"** або **"📂 Load Preset"**
3. Клікнути → з'явиться меню з пресетами
4. Знайти **"Import"** або **"+"**

### Спосіб B: Через User налаштування

1. Вкладка **"User"** зверху
2. Шукати розділ **"Presets"**
3. Кнопка **"Import Presets"**

### Спосіб C: Ручне копіювання файлу

Якщо імпорт не працює, скопіюйте файл напряму:

```bash
cp /mnt/g/Git/GitHub/ai-platform/data/AI-Platform-Presets.json \
   /mnt/g/Git/GitHub/ai-platform/data/
```

Потім перезапустіть SwarmUI:
```bash
docker compose restart swarmui
```

---

## 🎯 Метод 3: Створити пресети вручну через UI

Якщо імпорт не працює, створіть пресети вручну:

### Приклад: Створюємо "Cats SDXL"

1. **Налаштувати параметри:**
   - Model: `juggernautXL_ragnarokBy`
   - VAE: `sdxl_vae`
   - Steps: `30`
   - CFG: `7.0`
   - Sampler: `DPM++ 2M Karras`
   - Size: `1024x1024`
   - Prompt: `beautiful cat, highly detailed fur texture...`

2. **Зберегти:**
   - Шукати кнопку **"💾 Save Preset"**
   - Або **"..."** → **"Save as Preset"**
   - Ввести назву: `Cats SDXL`
   - Зберегти

3. **Повторити** для всіх 9 пресетів з файлу `AI-Platform-Presets.json`

---

## 📋 Список усіх пресетів

### 1. SDXL Portrait
```
Model: juggernautXL_ragnarokBy
Size: 1024x1344 (портрет)
Use: Реалістичні портрети людей
```

### 2. SDXL Landscape
```
Model: kodorail_v120
Size: 1344x768 (ландшафт)
Use: Пейзажі, локації, панорами
```

### 3. SDXL Anime
```
Model: novaAnimeXL_ilV160
Size: 1024x1024
Use: Аніме персонажі, ілюстрації
```

### 4. SD 1.5 Fast
```
Model: dreamshaper_8
Size: 512x512
Use: Швидкі тести (3-5 сек)
```

### 5. Flux High Quality
```
Model: zImageBase_base
Size: 1024x1024
Use: Максимальна якість
```

### 6. 🔞 NSFW Flux
```
Model: zImageBase_base + NSFW LoRA
Size: 1024x1344
Use: Дорослий контент (18+)
```

### 7. 🐱 Cats Realistic
```
Model: majicmixRealistic_v7
Size: 768x768
Use: Фотореалістичні котики
```

### 8. 🐱 Cats SDXL
```
Model: juggernautXL_ragnarokBy
Size: 1024x1024
Use: Котики у високій якості
```

### 9. 🐱 Cats Anime
```
Model: novaAnimeXL_ilV160
Size: 1024x1024
Use: Котики в аніме стилі
```

---

## 🔍 Де шукати кнопки у SwarmUI?

### Можливі розташування кнопки "Presets":

```
┌────────────────────────────────────────┐
│ SwarmUI                          [⚙️] │  ← Може бути тут
├────────────────────────────────────────┤
│ Model: [juggernautXL ▼]  [💾] [📂]   │  ← Або тут
│                                        │
│ Prompt: [________________]             │
│                                        │
│ [Advanced ▼]                           │  ← Або у Advanced
│   - Presets                            │
│                                        │
│ [Generate]                             │
├────────────────────────────────────────┤
│ Simple | Generate | User | Server     │  ← Або окрема вкладка
│                           └─ Presets   │
└────────────────────────────────────────┘
```

**Шукайте іконки:**
- 💾 (дискета) = Save Preset
- 📂 (папка) = Load Preset
- ⚙️ (шестерня) = Settings → Presets
- ... (три крапки) = More → Presets

---

## 📖 Корисні команди

```bash
# Переглянути JSON файл з пресетами
cat /mnt/g/Git/GitHub/ai-platform/data/AI-Platform-Presets.json

# Скопіювати у Windows шлях (якщо потрібно)
# G:\Git\GitHub\ai-platform\data\AI-Platform-Presets.json

# Перезапустити SwarmUI після змін
docker compose restart swarmui
```

---

## ❓ Troubleshooting

### Проблема: "Не знаходжу вкладку Presets"

**Рішення:**
1. Оновіть сторінку (F5)
2. Перевірте меню "User" або "Utilities"
3. Використайте Ctrl+F і шукайте слово "preset" на сторінці

### Проблема: "Імпорт не працює"

**Рішення:**
1. Переконайтеся, що файл JSON правильний
2. Спробуйте створити пресети вручну (Метод 3)
3. Перевірте логи: `docker compose logs swarmui | grep -i preset`

### Проблема: "Пресет не застосовує модель"

**Рішення:**
1. Перевірте, чи модель існує у списку моделей
2. Спробуйте вибрати модель вручну після завантаження пресету
3. Оновіть список моделей: Server → Utilities → Refresh Models

---

**Готово! Тепер у вас є 9 готових пресетів для будь-якої задачі!** 🎨✨
