import os
from PIL import Image, ImageDraw, ImageFont


def get_font(size):
    for name in ["arialbd.ttf", "segoeui.ttf", "arial.ttf"]:
        try:
            return ImageFont.truetype(name, size)
        except Exception:
            pass
    return ImageFont.load_default()


def create_feature_graphic(out_dir):
    w, h = 1024, 500
    img = Image.new("RGB", (w, h), (11, 15, 25))
    draw = ImageDraw.Draw(img)

    # Grid lines
    for x in range(0, w, 64):
        draw.line([(x, 0), (x, h)], fill=(22, 35, 56), width=1)
    for y in range(0, h, 64):
        draw.line([(0, y), (w, y)], fill=(22, 35, 56), width=1)

    # Right side radar reticle graphic
    cx, cy = 780, 250
    for r, col in [(180, (0, 230, 118)), (120, (0, 229, 255)), (60, (255, 179, 0))]:
        draw.ellipse([cx - r, cy - r, cx + r, cy + r], outline=col, width=5)
    draw.line([cx - 210, cy, cx + 210, cy], fill=(0, 230, 118), width=4)
    draw.line([cx, cy - 210, cx, cy + 210], fill=(0, 230, 118), width=4)

    # Text block
    f_title = get_font(54)
    f_sub = get_font(26)
    f_badge = get_font(20)

    draw.rounded_rectangle([48, 52, 470, 96], radius=12, fill=(22, 31, 48), outline=(0, 230, 118), width=2)
    draw.text((66, 63), "100% PRO UNLOCKED • OFFLINE", fill=(0, 230, 118), font=f_badge)

    draw.text((48, 130), "TeleMetro AR Pro", fill=(248, 250, 252), font=f_title)
    draw.text((48, 205), "Telémetro Óptico Trigonométrico", fill=(0, 229, 255), font=f_sub)
    draw.text((48, 245), "& Nivel Clínico 360° + Informes PDF", fill=(148, 163, 184), font=f_sub)

    draw.rounded_rectangle([48, 330, 520, 420], radius=14, fill=(22, 31, 48), outline=(40, 53, 74), width=2)
    draw.text((70, 350), "D = 14.85 m   |   H = 9.42 m", fill=(0, 230, 118), font=f_sub)
    draw.text((70, 385), "Pitch: -18.5°  •  Slope: 53.2%", fill=(255, 179, 0), font=f_badge)

    path = os.path.join(out_dir, "feature_graphic_1024x500.png")
    img.save(path, "PNG")
    print(f"Saved {path}")


def create_screenshot(out_dir, filename, title, subtitle, m1_label, m1_val, m2_label, m2_val, mode="hud"):
    w, h = 1080, 1920
    img = Image.new("RGB", (w, h), (11, 15, 25))
    draw = ImageDraw.Draw(img)

    f_h1 = get_font(56)
    f_h2 = get_font(34)
    f_val = get_font(62)
    f_lbl = get_font(28)

    # Top Header Banner
    draw.rounded_rectangle([60, 80, w - 60, 290], radius=28, fill=(22, 31, 48), outline=(0, 230, 118), width=4)
    draw.text((100, 115), title, fill=(248, 250, 252), font=f_h1)
    draw.text((100, 195), subtitle, fill=(0, 229, 255), font=f_h2)

    # Main Instrument Viewport
    draw.rounded_rectangle([60, 340, w - 60, 1120], radius=32, fill=(7, 12, 21), outline=(40, 53, 74), width=4)
    cx, cy = w // 2, 730

    if mode == "hud":
        for r in [280, 180, 90]:
            draw.ellipse([cx - r, cy - r, cx + r, cy + r], outline=(0, 230, 118), width=4)
        draw.line([cx - 340, cy, cx + 340, cy], fill=(0, 229, 255), width=4)
        draw.line([cx, cy - 340, cx, cy + 340], fill=(0, 230, 118), width=4)
        draw.polygon([(cx + 120, cy + 200), (cx + 320, cy + 200), (cx + 320, cy - 220)], outline=(255, 179, 0), width=6)
    elif mode == "level":
        for r in [300, 200, 100]:
            draw.ellipse([cx - r, cy - r, cx + r, cy + r], outline=(0, 229, 255), width=5)
        draw.ellipse([cx - 35, cy - 35, cx + 35, cy + 35], fill=(0, 230, 118))
    else:
        for i in range(4):
            y0 = 400 + i * 165
            draw.rounded_rectangle([110, y0, w - 110, y0 + 135], radius=18, fill=(22, 31, 48), outline=(0, 230, 118), width=3)
            draw.text((145, y0 + 25), f"SURVEY-PT0{i+1}  •  D = {12.4 + i*3.1:.2f} m  •  H = {6.8 + i*1.7:.2f} m", fill=(248, 250, 252), font=f_h2)
            draw.text((145, y0 + 78), "θ_base: -16.5°   |   θ_top: +28.0°   |   Slope: 53.2%", fill=(0, 230, 118), font=f_lbl)

    # Metric Cards
    draw.rounded_rectangle([60, 1170, 520, 1460], radius=24, fill=(22, 31, 48), outline=(0, 230, 118), width=3)
    draw.text((95, 1210), m1_label, fill=(148, 163, 184), font=f_lbl)
    draw.text((95, 1280), m1_val, fill=(0, 230, 118), font=f_val)

    draw.rounded_rectangle([560, 1170, w - 60, 1460], radius=24, fill=(22, 31, 48), outline=(0, 229, 255), width=3)
    draw.text((595, 1210), m2_label, fill=(148, 163, 184), font=f_lbl)
    draw.text((595, 1280), m2_val, fill=(0, 229, 255), font=f_val)

    # Bottom Pro Footer
    draw.rounded_rectangle([60, 1520, w - 60, 1820], radius=26, fill=(22, 31, 48), outline=(40, 53, 74), width=3)
    draw.text((100, 1575), "SimpleAppsPG • Obsidian Dark Engineering UI", fill=(0, 230, 118), font=f_h2)
    draw.text((100, 1645), "• D = h_eye / tan(|θ_base|)    • H = h_eye + D·tan(θ_top)", fill=(248, 250, 252), font=f_lbl)
    draw.text((100, 1710), "• Exportación PDF Firmada  • Idiomas: ES / EN / PT", fill=(255, 179, 0), font=f_lbl)

    path = os.path.join(out_dir, filename)
    img.save(path, "PNG")
    print(f"Saved {path}")


def main():
    out_dir = "store_assets"
    os.makedirs(out_dir, exist_ok=True)

    # Copy high-res icon to store_assets
    if os.path.exists("assets/icon/app_icon.png"):
        icon_img = Image.open("assets/icon/app_icon.png").resize((512, 512))
        icon_img.save(os.path.join(out_dir, "icon_512x512.png"), "PNG")

    create_feature_graphic(out_dir)
    create_screenshot(
        out_dir,
        "screenshot_1_rangefinder_hud.png",
        "Telémetro Trigonométrico HUD",
        "Cálculo óptico de Distancia (D) y Altura (H)",
        "Distancia Horizontal (D)",
        "14.85 m",
        "Altura Objetivo (H)",
        "9.42 m",
        mode="hud",
    )
    create_screenshot(
        out_dir,
        "screenshot_2_clinometer_360.png",
        "Nivel de Burbuja 360° & Clinómetro",
        "Doble eje Pitch / Roll, Pendiente % y Techo X:12",
        "Inclinación Pitch",
        "0.0° LEVEL",
        "Pendiente / Techo",
        "0.0% | 0:12",
        mode="level",
    )
    create_screenshot(
        out_dir,
        "screenshot_3_pdf_logbook.png",
        "Bitácora e Informes PDF Firmados",
        "Certificados técnicos con firma del operador",
        "Levantamientos",
        "100% Local",
        "Reporte Técnico",
        "PDF + Firma",
        mode="pdf",
    )
    create_screenshot(
        out_dir,
        "screenshot_4_trilingual_pro.png",
        "Edición 100% Pro • Trilingüe",
        "Español (ES) • English (EN) • Português (PT)",
        "Altura Lente h_eye",
        "1.65 m",
        "Barómetro / Rumbo",
        "1013 hPa",
        mode="hud",
    )


if __name__ == "__main__":
    main()
