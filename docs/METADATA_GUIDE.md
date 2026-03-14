# 📝 How to Read Prompts from Generated Images

## ✅ Yes! All parameters are saved inside PNG

SwarmUI saves **all generation data** inside PNG file:
- ✅ Prompt
- ✅ Negative prompt
- ✅ Model
- ✅ Seed (for reproduction)
- ✅ Steps, CFG Scale
- ✅ Image size
- ✅ Generation time
- ✅ Creation date

---

## 🎯 Ways to read

### 1️⃣ Via SwarmUI (simplest) ⭐

1. Open http://127.0.0.1:7801
2. **Image History** (clock icon on left)
3. Click image
4. See **all parameters** at bottom
5. **Reuse Parameters** → copies everything for re-generation!

**Advantages:**
- ✅ Visual interface
- ✅ One button to copy parameters
- ✅ History of all generations

---

### 2️⃣ Via Python script (for command line)

**Project has ready script:**
```bash
python3 read-prompt.py output/local/raw/2026-02-01/1724001-*.png
```

**Output:**
```
✨ PROMPT:
   beautiful sunset over mountains, 8k, detailed

⚙️  PARAMETERS:
   Model:       dreamshaper_8
   Seed:        675311893
   Steps:       20
   CFG Scale:   7.0
   Size:        512×512

⏱️  STATISTICS:
   Date:        2026-02-01
   Generation:  2.72 sec
```

**For all files in folder:**
```bash
python3 read-prompt.py output/local/raw/2026-02-01/*.png
```

---

### 3️⃣ Via ExifTool (if installed)

**Installation:**
```bash
sudo apt install libimage-exiftool-perl
```

**Read metadata:**
```bash
exiftool "output/local/raw/2026-02-01/1724001-*.png"
```

**Only parameters:**
```bash
exiftool -parameters "output/local/raw/2026-02-01/1724001-*.png" | jq
```

---

### 4️⃣ Via strings (fast, but ugly)

```bash
strings "output/local/raw/2026-02-01/1724001-*.png" | grep -A 20 "prompt"
```

---

## 🔄 How to reproduce image

### Method 1: Via SwarmUI GUI

1. **Image History** → click image
2. **Reuse Parameters** (button at bottom)
3. **Generate** → will use same seed and parameters

**Result:** Exact copy of original ✅

---

### Method 2: Copy parameters manually

```bash
# Extract prompt and seed
python3 read-prompt.py output/local/raw/2026-02-01/1724001-*.png

# Use these parameters:
Prompt: "beautiful sunset over mountains, 8k, detailed"
Model: dreamshaper_8
Seed: 675311893
Steps: 20
CFG Scale: 7.0
Size: 512×512
```

In SwarmUI:
1. Choose model `dreamshaper_8`
2. Enter prompt
3. Paste seed: `675311893`
4. Press **Generate**

---

## 📊 Metadata structure (JSON)

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

## 💡 Tips

### For organizing images:

1. **By prompt:**
   ```bash
   # Find all images with specific prompt
   for img in output/local/raw/*/*.png; do
       python3 read-prompt.py "$img" | grep -q "sunset" && echo "$img"
   done
   ```

2. **By model:**
   ```bash
   # Find all images generated on dreamshaper_8
   for img in output/local/raw/*/*.png; do
       python3 read-prompt.py "$img" | grep -q "dreamshaper_8" && echo "$img"
   done
   ```

3. **By seed (find duplicates):**
   ```bash
   python3 read-prompt.py output/local/raw/*/*.png | grep "Seed:"
   ```

---

## 🔧 Additional tools

### Batch extraction (export all prompts to CSV):

```bash
#!/bin/bash
echo "Filename,Prompt,Model,Seed,Steps,Size" > prompts.csv

for img in output/local/raw/*/*.png; do
    data=$(python3 read-prompt.py "$img")
    prompt=$(echo "$data" | grep "PROMPT:" -A 1 | tail -1 | xargs)
    model=$(echo "$data" | grep "Model:" | awk '{print $2}')
    seed=$(echo "$data" | grep "Seed:" | awk '{print $2}')
    steps=$(echo "$data" | grep "Steps:" | awk '{print $2}')
    size=$(echo "$data" | grep "Size:" | awk '{print $2}')

    echo "$img,$prompt,$model,$seed,$steps,$size" >> prompts.csv
done

echo "✅ Export complete: prompts.csv"
```

---

## ✅ Conclusion

**Your images are self-contained!**
- 📦 PNG contains ALL data for reproduction
- 🔄 Can easily reproduce any image
- 📝 History saved forever in files

**Never lose prompts!** 🎨✨
