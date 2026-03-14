# 📝 Як читати промпти з згенерованих зображень

## ✅ Так! Всі параметри зберігаються всередині PNG

SwarmUI зберігає **всі дані генерації** всередині PNG файлу:
- ✅ Промпт
- ✅ Негативний промпт
- ✅ Модель
- ✅ Seed (для відтворення)
- ✅ Steps, CFG Scale
- ✅ Розмір зображення
- ✅ Час генерації
- ✅ Дата створення

---

## 🎯 Способи читання

### 1️⃣ Через SwarmUI (найпростіший) ⭐

1. Відкрий http://127.0.0.1:7801
2. **Image History** (іконка годинника зліва)
3. Клікни на зображення
4. Побачиш **всі параметри** внизу
5. **Reuse Parameters** → скопіює все для повторної генерації!

**Переваги:**
- ✅ Візуальний інтерфейс
- ✅ Одна кнопка для копіювання параметрів
- ✅ Історія всіх генерацій

---

### 2️⃣ Через Python скрипт (для командного рядку)

**У проекті є готовий скрипт:**
```bash
python3 read-prompt.py output/local/raw/2026-02-01/1724001-*.png
```

**Вивід:**
```
✨ ПРОМПТ:
   beautiful sunset over mountains, 8k, detailed

⚙️  ПАРАМЕТРИ:
   Model:       dreamshaper_8
   Seed:        675311893
   Steps:       20
   CFG Scale:   7.0
   Size:        512×512

⏱️  СТАТИСТИКА:
   Дата:        2026-02-01
   Генерація:   2.72 sec
```

**Для всіх файлів у папці:**
```bash
python3 read-prompt.py output/local/raw/2026-02-01/*.png
```

---

### 3️⃣ Через ExifTool (якщо встановлено)

**Встановлення:**
```bash
sudo apt install libimage-exiftool-perl
```

**Читання метаданих:**
```bash
exiftool "output/local/raw/2026-02-01/1724001-*.png"
```

**Тільки параметри:**
```bash
exiftool -parameters "output/local/raw/2026-02-01/1724001-*.png" | jq
```

---

### 4️⃣ Через strings (швидко, але некрасиво)

```bash
strings "output/local/raw/2026-02-01/1724001-*.png" | grep -A 20 "prompt"
```

---

## 🔄 Як відтворити зображення

### Спосіб 1: Через SwarmUI GUI

1. **Image History** → клікни на зображення
2. **Reuse Parameters** (кнопка внизу)
3. **Generate** → буде використано той самий seed та параметри

**Результат:** Точна копія оригіналу ✅

---

### Спосіб 2: Вручну скопіюй параметри

```bash
# Витягни промпт та seed
python3 read-prompt.py output/local/raw/2026-02-01/1724001-*.png

# Використай ці параметри:
Prompt: "beautiful sunset over mountains, 8k, detailed"
Model: dreamshaper_8
Seed: 675311893
Steps: 20
CFG Scale: 7.0
Size: 512×512
```

У SwarmUI:
1. Вибери модель `dreamshaper_8`
2. Введи промпт
3. Встав seed: `675311893`
4. Натисни **Generate**

---

## 📊 Структура метаданих (JSON)

```json
{
  "sui_image_params": {
    "prompt": "beautiful sunset over mountains, 8k, detailed",
    "negativeprompt": "",
    "model": "dreamshaper_8",
    "seed": 675311893,
    "steps": 20,
    "cfgscale": 7.0,
    "width": 512,
    "height": 512,
    "aspectratio": "1:1",
    "automaticvae": true,
    "swarm_version": "0.9.7.4"
  },
  "sui_extra_data": {
    "date": "2026-02-01",
    "prep_time": "0.01 sec",
    "generation_time": "2.72 sec"
  },
  "sui_models": [
    {
      "name": "dreamshaper_8.safetensors",
      "hash": "..."
    }
  ]
}
```

---

## 💡 Поради

### Для організації зображень:

1. **За промптом:**
   ```bash
   # Знайди всі зображення з певним промптом
   for img in output/local/raw/*/*.png; do
       python3 read-prompt.py "$img" | grep -q "sunset" && echo "$img"
   done
   ```

2. **За моделлю:**
   ```bash
   # Знайди всі зображення згенеровані на dreamshaper_8
   for img in output/local/raw/*/*.png; do
       python3 read-prompt.py "$img" | grep -q "dreamshaper_8" && echo "$img"
   done
   ```

3. **За seed (для пошуку дублікатів):**
   ```bash
   python3 read-prompt.py output/local/raw/*/*.png | grep "Seed:"
   ```

---

## 🔧 Додаткові інструменти

### Batch екс extraction (витягнути всі промпти у CSV):

```bash
#!/bin/bash
echo "Filename,Prompt,Model,Seed,Steps,Size" > prompts.csv

for img in output/local/raw/*/*.png; do
    data=$(python3 read-prompt.py "$img")
    prompt=$(echo "$data" | grep "ПРОМПТ:" -A 1 | tail -1 | xargs)
    model=$(echo "$data" | grep "Model:" | awk '{print $2}')
    seed=$(echo "$data" | grep "Seed:" | awk '{print $2}')
    steps=$(echo "$data" | grep "Steps:" | awk '{print $2}')
    size=$(echo "$data" | grep "Size:" | awk '{print $2}')

    echo "$img,$prompt,$model,$seed,$steps,$size" >> prompts.csv
done

echo "✅ Експорт завершено: prompts.csv"
```

---

## ✅ Висновок

**Твої зображення самодостатні!**
- 📦 PNG містить ВСІ дані для відтворення
- 🔄 Можеш легко відтворити будь-яке зображення
- 📝 Історія зберігається назавжди у файлах

**Ніколи не втратиш промпти!** 🎨✨
