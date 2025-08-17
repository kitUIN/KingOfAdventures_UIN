
# 将当前文件夹下的所有图片裁去最右边的10px
import os
from PIL import Image

# 获取当前文件夹路径
current_dir = os.path.dirname(os.path.abspath(__file__))

# 支持的图片格式
img_exts = ['.png', '.jpg', '.jpeg', '.bmp', '.gif']

for filename in os.listdir(current_dir):
    if any(filename.lower().endswith(ext) for ext in img_exts):
        img_path = os.path.join(current_dir, filename)
        try:
            with Image.open(img_path) as img:
                w, h = img.size
                if w > 10:
                    # 裁剪最右边的10px
                    cropped = img.crop((0, 0, w - 6, h))
                    cropped.save(img_path)
        except Exception as e:
            print(f"处理文件 {filename} 时出错: {e}")
