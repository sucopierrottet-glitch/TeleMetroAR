import os
from PIL import Image, ImageDraw, ImageFont


def create_app_icon():
    size = 1024
    img = Image.new("RGBA", (size, size), (11, 15, 25, 255))
    draw = ImageDraw.Draw(img)

    # Outer precision bezel
    margin = 84
    draw.rounded_rectangle(
        [margin, margin, size - margin, size - margin],
        radius=190,
        fill=(22, 31, 48, 255),
        outline=(0, 230, 118, 255),
        width=18,
    )

    center = size // 2

    # Concentric radar rings
    for r, col, w in [
        (320, (0, 229, 255, 110), 8),
        (220, (0, 230, 118, 180), 10),
        (110, (255, 179, 0, 220), 10),
    ]:
        draw.ellipse(
            [center - r, center - r, center + r, center + r],
            outline=col,
            width=w,
        )

    # Crosshair optical axes
    draw.line([center - 360, center, center - 60, center], fill=(0, 230, 118, 255), width=14)
    draw.line([center + 60, center, center + 360, center], fill=(0, 230, 118, 255), width=14)
    draw.line([center, center - 360, center, center - 60], fill=(0, 230, 118, 255), width=14)
    draw.line([center, center + 60, center, center + 360], fill=(0, 230, 118, 255), width=14)

    # Trigonometric laser triangle overlay
    pts = [(center - 200, center + 160), (center + 210, center + 160), (center + 210, center - 190)]
    draw.polygon(pts, outline=(0, 229, 255, 255), width=12)

    # Center bullseye dot
    draw.ellipse([center - 24, center - 24, center + 24, center + 24], fill=(0, 230, 118, 255))

    os.makedirs("assets/icon", exist_ok=True)
    out_path = os.path.join("assets", "icon", "app_icon.png")
    img.convert("RGB").save(out_path, "PNG")
    print(f"Saved {out_path}")


if __name__ == "__main__":
    create_app_icon()
