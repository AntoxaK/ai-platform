# How to Use Presets in SwarmUI

## 📖 Important difference

### ❌ Examples (what you saw) ≠ Presets

**"Examples/Basic SDXL"** in your screenshot is:
- Demo images (with ready results)
- Built-in to SwarmUI
- Cannot add your own

**"Presets"** (what you need) is:
- Saved parameter settings
- Can create, import, export
- Located in separate tab

---

## 🎯 Method 1: Import ready presets (RECOMMENDED)

### Step 1: Open SwarmUI
```
http://127.0.0.1:7801
```

### Step 2: Find "Presets" tab

**Option A:** At bottom of screen there are tabs:
```
Simple | Generate | Comfy Workflow | Utilities | User | Server
```
Look for **"Presets"** tab (may be in **"User"** menu or separate)

**Option B:** Near Model field there may be **"💾"** or **"Presets"** button

### Step 3: Import presets

1. Press **"Import Presets"** or **"📁 Import"** button
2. Select file:
   ```
   /mnt/g/Git/GitHub/ai-platform/data/AI-Platform-Presets.json
   ```
   (or on Windows: `G:\Git\GitHub\ai-platform\data\AI-Platform-Presets.json`)
3. Press **"Import"**
4. Close dialog

### Step 4: Use presets

Now all 9 presets appear in presets list:
- ✓ SDXL Portrait
- ✓ SDXL Landscape
- ✓ SDXL Anime
- ✓ SD 1.5 Fast
- ✓ Flux High Quality
- ✓ 🔞 NSFW Flux
- ✓ 🐱 Cats Realistic
- ✓ 🐱 Cats SDXL
- ✓ 🐱 Cats Anime

Click preset → parameters apply automatically!

---

## 🎯 Method 2: If you don't find Presets tab

Possibly your SwarmUI version has slightly different UI. Here are alternative ways:

### Way A: Via Generate tab

1. Open **"Generate"** tab
2. Look for **"💾 Presets"** or **"📂 Load Preset"** button
3. Click → menu appears with presets
4. Find **"Import"** or **"+"**

### Way B: Via User settings

1. **"User"** tab at top
2. Look for **"Presets"** section
3. **"Import Presets"** button

### Way C: Manual file copy

If import doesn't work, copy file directly:

```bash
cp /mnt/g/Git/GitHub/ai-platform/data/AI-Platform-Presets.json \
   /mnt/g/Git/GitHub/ai-platform/data/
```

Then restart SwarmUI:
```bash
docker compose restart swarmui
```

---

## 🎯 Method 3: Create presets manually via UI

If import doesn't work, create presets manually:

### Example: Creating "Cats SDXL"

1. **Configure parameters:**
   - Model: `juggernautXL_ragnarokBy`
   - VAE: `sdxl_vae`
   - Steps: `30`
   - CFG: `7.0`
   - Sampler: `DPM++ 2M Karras`
   - Size: `1024x1024`
   - Prompt: `beautiful cat, highly detailed fur texture...`

2. **Save:**
   - Look for **"💾 Save Preset"** button
   - Or **"..."** → **"Save as Preset"**
   - Enter name: `Cats SDXL`
   - Save

3. **Repeat** for all 9 presets from `AI-Platform-Presets.json` file

---

## 📋 List of all presets

### 1. SDXL Portrait
```
Model: juggernautXL_ragnarokBy
Size: 1024x1344 (portrait)
Use: Realistic human portraits
```

### 2. SDXL Landscape
```
Model: kodorail_v120
Size: 1344x768 (landscape)
Use: Landscapes, locations, panoramas
```

### 3. SDXL Anime
```
Model: novaAnimeXL_ilV160
Size: 1024x1024
Use: Anime characters, illustrations
```

### 4. SD 1.5 Fast
```
Model: dreamshaper_8
Size: 512x512
Use: Quick tests (3-5 sec)
```

### 5. Flux High Quality
```
Model: zImageBase_base
Size: 1024x1024
Use: Maximum quality
```

### 6. 🔞 NSFW Flux
```
Model: zImageBase_base + NSFW LoRA
Size: 1024x1344
Use: Adult content (18+)
```

### 7. 🐱 Cats Realistic
```
Model: majicmixRealistic_v7
Size: 768x768
Use: Photorealistic cats
```

### 8. 🐱 Cats SDXL
```
Model: juggernautXL_ragnarokBy
Size: 1024x1024
Use: High quality cats
```

### 9. 🐱 Cats Anime
```
Model: novaAnimeXL_ilV160
Size: 1024x1024
Use: Cats in anime style
```

---

## 🔍 Where to find buttons in SwarmUI?

### Possible Presets button locations:

```
┌────────────────────────────────────────┐
│ SwarmUI                          [⚙️] │  ← May be here
├────────────────────────────────────────┤
│ Model: [juggernautXL ▼]  [💾] [📂]   │  ← Or here
│                                        │
│ Prompt: [________________]             │
│                                        │
│ [Advanced ▼]                           │  ← Or in Advanced
│   - Presets                            │
│                                        │
│ [Generate]                             │
├────────────────────────────────────────┤
│ Simple | Generate | User | Server     │  ← Or separate tab
│                           └─ Presets   │
└────────────────────────────────────────┘
```

**Look for icons:**
- 💾 (floppy disk) = Save Preset
- 📂 (folder) = Load Preset
- ⚙️ (gear) = Settings → Presets
- ... (three dots) = More → Presets

---

## 📖 Useful commands

```bash
# View JSON file with presets
cat /mnt/g/Git/GitHub/ai-platform/data/AI-Platform-Presets.json

# Copy to Windows path (if needed)
# G:\Git\GitHub\ai-platform\data\AI-Platform-Presets.json

# Restart SwarmUI after changes
docker compose restart swarmui
```

---

## ❓ Troubleshooting

### Problem: "Cannot find Presets tab"

**Solution:**
1. Refresh page (F5)
2. Check "User" or "Utilities" menu
3. Use Ctrl+F and search for "preset" on page

### Problem: "Import doesn't work"

**Solution:**
1. Check JSON file is correct
2. Try creating presets manually (Method 3)
3. Check logs: `docker compose logs swarmui | grep -i preset`

### Problem: "Preset doesn't apply model"

**Solution:**
1. Check model exists in model list
2. Try selecting model manually after loading preset
3. Refresh models: Server → Utilities → Refresh Models

---

**Ready! Now you have 9 ready presets for any task!** 🎨✨
