# Оптимізація WAN 2.2 для RTX 4070 12GB

## ⚠️ Проблема: Зависання під час генерації

WAN 2.2 14B — це ДУЖЕ велика модель (14 мільярдів параметрів). Навіть у FP8 вона потребує ~12GB VRAM.

---

## 🚀 Швидкі виправлення (по черзі):

### 1. Закрити SwarmUI (звільнити 2-3 GB VRAM)

```bash
docker compose stop swarmui
```

**Ефект:** +2-3 GB вільного VRAM

### 2. Зменшити кількість кадрів

У workflow знайти параметр **num_frames** або **video_frames**:

| Було | Стало | VRAM | Швидкість |
|------|-------|------|-----------|
| 25 кадрів | **14 кадрів** | -40% | 2x швидше |
| 21 кадрів | **14 кадрів** | -30% | 1.5x швидше |

**Де змінити:**
- Нода з параметрами генерації
- Або нода **EmptyLatentVideo**
- Встановити: `frames: 14`

### 3. Зменшити роздільність зображення

| Було | Стало | VRAM | Якість |
|------|-------|------|--------|
| 1024x1024 | **768x768** | -30% | Добре |
| 1024x576 | **768x432** | -30% | Добре |
| 768x768 | **512x512** | -50% | Прийнятно |

**Як:**
1. Відкрити вхідне зображення в редакторі
2. Resize до 768x768
3. Зберегти і завантажити в ComfyUI

### 4. Використати LightX2V LoRA (4 кроки замість 20)

У workflow активувати **LoraLoader**:
- **lora_name:** `wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors`
- **strength_model:** 1.0

У **KSampler**:
- **steps:** змінити з 20 на **4**

**Ефект:**
- 5x швидше генерація
- -20% VRAM
- Трохи нижча якість, але прийнятно

### 5. Використати Low Noise модель (менше шуму = менше кроків)

Замість `wan2.2_i2v_high_noise` використати:
```
wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
```

**Ефект:** Можна зменшити steps до 15-18

---

## 🔧 Оптимальні налаштування для RTX 4070 12GB:

### Конфігурація A: Найшвидша (2-3 хвилини)

```
Model: wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
LoRA: wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors (strength 1.0)
Resolution: 768x768
Frames: 14
Steps: 4
FPS: 6
VRAM: ~8-9 GB
```

### Конфігурація B: Баланс (5-7 хвилин)

```
Model: wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
LoRA: Вимкнено
Resolution: 768x768
Frames: 14
Steps: 18
FPS: 6
VRAM: ~10-11 GB
```

### Конфігурація C: Найкраща якість (10-15 хвилин)

```
Model: wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors
LoRA: Вимкнено
Resolution: 1024x768
Frames: 21
Steps: 20
FPS: 8
VRAM: ~12 GB (максимум!)
```

---

## 📝 Покрокова оптимізація workflow:

### Крок 1: Відкрити workflow у ComfyUI

http://127.0.0.1:7821

### Крок 2: Знайти критичні ноди

**Нода 1: DiffusionModelLoader / UNETLoader**
- Змінити на: `wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors`

**Нода 2: LoraLoader (якщо є)**
- Активувати (mode: 0)
- lora_name: `wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors`
- strength_model: 1.0
- strength_clip: 1.0

**Нода 3: EmptyLatentVideo / параметри відео**
- width: 768
- height: 768
- length: 14 (кількість кадрів)
- batch_size: 1

**Нода 4: KSampler**
- steps: 4 (якщо LoRA) або 18 (без LoRA)
- cfg: 2.5
- sampler_name: euler
- scheduler: normal

**Нода 5: LoadImage**
- Завантажити зображення 768x768

### Крок 3: Queue Prompt

Генерація має зайняти 2-5 хвилин замість 10-15.

---

## 🔍 Як зрозуміти що зависло vs генерується?

### Генерується (все OK):
```bash
# Перевірити GPU
nvidia-smi

# Має показувати:
# - GPU Utilization: 90-100%
# - Memory Used: 10-12 GB
# - Temperature: 60-80°C
```

### Зависло (проблема):
```bash
nvidia-smi

# Показує:
# - GPU Utilization: 0%
# - Memory Used: 12282 MB (100%)
# - Або помилка "CUDA out of memory"
```

### Перевірити логи ComfyUI:
```bash
tail -50 /tmp/comfyui.log
```

Шукати:
- `CUDA out of memory` → Зменшити параметри
- `Killed` → RAM закінчився
- Progress bar `15%...30%...` → Генерується (чекати)

---

## 🆘 Екстрена допомога:

### Якщо зависло зараз:

**1. Перервати генерацію:**
- У ComfyUI натиснути **Interrupt** (червона кнопка)
- Або:
```bash
pkill -f "python.*main.py.*comfy"
sleep 3
./start.sh
```

**2. Звільнити VRAM:**
```bash
# Закрити SwarmUI
docker compose stop swarmui

# Перезапустити ComfyUI
pkill -f comfy && sleep 3 && ./start.sh
```

**3. Перевірити чи ComfyUI живий:**
```bash
curl http://127.0.0.1:7821/system_stats
```

### Альтернатива: Використати SVD (легша модель)

Якщо WAN занадто важкий, спробуйте SVD:

```
Model: svd.safetensors (9 GB замість 14 GB)
Resolution: 1024x576
Frames: 14
Steps: 20
VRAM: ~10 GB
Час: 3-5 хвилин
```

SVD не потребує text encoder, простіша, швидша.

---

## 📊 Порівняння ресурсів:

| Модель | VRAM | Час (14 кадрів) | Якість |
|--------|------|-----------------|--------|
| **SVD** | ~10 GB | 3-5 хв | ⭐⭐⭐ |
| **WAN + LightX2V** | ~9 GB | 2-3 хв | ⭐⭐⭐⭐ |
| **WAN Low Noise** | ~11 GB | 5-7 хв | ⭐⭐⭐⭐⭐ |
| **WAN High Noise** | ~12 GB | 7-10 хв | ⭐⭐⭐⭐⭐ |

---

## ✅ Рекомендований workflow для RTX 4070:

1. **Закрити SwarmUI:**
   ```bash
   docker compose stop swarmui
   ```

2. **Використати конфігурацію A (найшвидша):**
   - Model: low_noise
   - LoRA: lightx2v_4steps
   - Resolution: 768x768
   - Frames: 14
   - Steps: 4

3. **Після генерації — запустити SwarmUI назад:**
   ```bash
   docker compose start swarmui
   ```

---

## 🎯 Якщо нічого не допомагає:

### План Б: Використати менші параметри

```
Model: wan2.2_i2v_low_noise (ТАК ЖЕ)
LoRA: lightx2v_4steps (УВІМКНУТИ)
Resolution: 512x512 (МЕНШЕ!)
Frames: 10 (МЕНШЕ!)
Steps: 4 (МЕНШЕ!)
```

Це має працювати навіть на 8GB VRAM.

---

**Спробуйте Конфігурацію A — вона має працювати гарантовано!** 🚀
