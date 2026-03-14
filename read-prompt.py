#!/usr/bin/env python3
"""
Витягування промптів та параметрів з PNG файлів SwarmUI
"""
import sys
import struct
import json

def read_png_metadata(filename):
    """Читає tEXt chunks з PNG файлу"""
    metadata = {}

    with open(filename, 'rb') as f:
        # Перевірка PNG signature
        signature = f.read(8)
        if signature != b'\x89PNG\r\n\x1a\n':
            print(f"❌ {filename} не є PNG файлом")
            return None

        # Читаємо chunks
        while True:
            try:
                # Довжина chunk
                length_data = f.read(4)
                if len(length_data) < 4:
                    break
                length = struct.unpack('>I', length_data)[0]

                # Тип chunk
                chunk_type = f.read(4).decode('ascii')

                # Дані chunk
                chunk_data = f.read(length)

                # CRC (пропускаємо)
                f.read(4)

                # Якщо це tEXt chunk - читаємо метадані
                if chunk_type == 'tEXt':
                    # tEXt формат: keyword\0text
                    null_pos = chunk_data.find(b'\x00')
                    if null_pos != -1:
                        keyword = chunk_data[:null_pos].decode('latin-1')
                        text = chunk_data[null_pos+1:].decode('utf-8', errors='ignore')
                        metadata[keyword] = text

                # IEND означає кінець файлу
                if chunk_type == 'IEND':
                    break

            except Exception as e:
                break

    return metadata

def print_metadata(filename):
    """Виводить метадані у читабельному форматі"""
    print(f"\n{'='*70}")
    print(f"📄 {filename}")
    print(f"{'='*70}")

    metadata = read_png_metadata(filename)

    if not metadata:
        print("⚠️  Метадані не знайдено")
        return

    # Парсимо parameters (JSON)
    if 'parameters' in metadata:
        try:
            data = json.loads(metadata['parameters'])

            # SwarmUI зберігає параметри в sui_image_params
            params = data.get('sui_image_params', data)
            extra = data.get('sui_extra_data', {})

            print("\n✨ ПРОМПТ:")
            print(f"   {params.get('prompt', 'N/A')}")

            if params.get('negativeprompt'):
                print("\n🚫 НЕГАТИВНИЙ ПРОМПТ:")
                print(f"   {params['negativeprompt']}")

            print("\n⚙️  ПАРАМЕТРИ:")
            print(f"   Model:       {params.get('model', 'N/A')}")
            print(f"   Seed:        {params.get('seed', 'N/A')}")
            print(f"   Steps:       {params.get('steps', 'N/A')}")
            print(f"   CFG Scale:   {params.get('cfgscale', 'N/A')}")
            print(f"   Sampler:     {params.get('sampler', 'N/A')}")
            print(f"   Size:        {params.get('width', 'N/A')}×{params.get('height', 'N/A')}")

            if extra:
                print("\n⏱️  СТАТИСТИКА:")
                print(f"   Дата:        {extra.get('date', 'N/A')}")
                print(f"   Підготовка:  {extra.get('prep_time', 'N/A')}")
                print(f"   Генерація:   {extra.get('generation_time', 'N/A')}")

        except json.JSONDecodeError:
            print("\n📝 RAW PARAMETERS:")
            print(metadata['parameters'])

    # Інші метадані
    other_keys = [k for k in metadata.keys() if k != 'parameters']
    if other_keys:
        print("\n📊 ІНШІ МЕТАДАНІ:")
        for key in other_keys:
            value = metadata[key]
            if len(value) > 100:
                value = value[:100] + "..."
            print(f"   {key}: {value}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Використання: python3 read-prompt.py <PNG файл>")
        print("\nПриклад:")
        print("  python3 read-prompt.py output/local/raw/2026-02-01/1724001-*.png")
        sys.exit(1)

    for filename in sys.argv[1:]:
        try:
            print_metadata(filename)
        except FileNotFoundError:
            print(f"\n❌ Файл не знайдено: {filename}")
        except Exception as e:
            print(f"\n❌ Помилка читання {filename}: {e}")
