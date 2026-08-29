import os
import sys

try:
    from PIL import Image
    src_path = r'e:\smart\assets\images\app_logo.jpg'
    img = Image.open(src_path)

    sizes = {
        'mipmap-mdpi': (48, 48),
        'mipmap-hdpi': (72, 72),
        'mipmap-xhdpi': (96, 96),
        'mipmap-xxhdpi': (144, 144),
        'mipmap-xxxhdpi': (192, 192),
    }

    base_dir = r'e:\smart\android\app\src\main\res'

    for folder, size in sizes.items():
        out_dir = os.path.join(base_dir, folder)
        os.makedirs(out_dir, exist_ok=True)
        out_path = os.path.join(out_dir, 'ic_launcher.png')
        resized = img.resize(size, Image.Resampling.LANCZOS)
        resized.save(out_path, 'PNG')
        print(f"Successfully saved {out_path} ({size[0]}x{size[1]})")

except Exception as e:
    print(f"Error: {e}")
