# Guía de Publicación en Tiendas — TeleMetro AR Pro

**Aplicación:** TeleMetro AR Pro  
**Package ID / Bundle ID:** `com.simpleappspg.telemetroar`  
**Versión:** `1.0.0+1` (`versionCode: 1`, `versionName: "1.0.0"`)  
**Modelo de Monetización:** Camino 1 — App de Pago (100% Pro Desbloqueada, sin anuncios ni compras integradas, 100% Offline).

---

## 1. Requisitos Técnicos Verificados

- **Android SDK:** `minSdk = 21`, `targetSdk = 34`, `compileSdk = 34`.
- **Firma de Producción:** Configurada en `android/key.properties` y `android/app/upload-keystore.jks`.
- **Idiomas incluidos (1-Tap Switcher):** Español (`es`), Inglés (`en`), Portugués (`pt`).
- **Artefactos Visuales Generados (`store_assets/`):**
  - `icon_512x512.png` (512x512 px)
  - `feature_graphic_1024x500.png` (1024x500 px)
  - `screenshot_1_rangefinder_hud.png` (1080x1920 px)
  - `screenshot_2_clinometer_360.png` (1080x1920 px)
  - `screenshot_3_pdf_logbook.png` (1080x1920 px)
  - `screenshot_4_trilingual_pro.png` (1080x1920 px)

---

## 2. Textos para Google Play Console / Apple App Store

### Español (ES)
- **Título (30 car. máx):** TeleMetro AR Pro: Nivel y Medir
- **Descripción Corta (80 car. máx):** Telémetro óptico trigonométrico, nivel de burbuja 360°, clinómetro e informes PDF.
- **Descripción Completa:**
  TeleMetro AR Pro es un instrumento técnico de precisión 100% Offline diseñado para ingenieros, arquitectos, topógrafos y constructores.
  - **Telémetro Trigonométrico HUD:** Calcula la distancia horizontal ($D = h_{eye} / \tan(|\theta_{base}|)$) y la altura total del objetivo ($H = h_{eye} + D \cdot \tan(\theta_{top})$) fijando el ángulo hacia la base y la cima.
  - **Nivel de Burbuja 360° y Clinómetro:** Medición en doble eje (Pitch y Roll), función de Tara a 0.0°, pendiente en porcentaje (%), pitch de techo (X:12), brújula magnética y altímetro barométrico.
  - **Bitácora e Informes PDF con Firma Digital:** Guarda tus levantamientos en memoria local y exporta reportes técnicos en formato A4 PDF con la firma manuscrita del operador.
  - **100% Pro Desbloqueado y Privado:** Sin suscripciones, sin anuncios y sin conexión a internet requerida.

### English (EN)
- **Title:** TeleMetro AR Pro: Range & Level
- **Short Description:** Trigonometric optical rangefinder, 360° bubble level, clinometer & signed PDF reports.

### Português (PT)
- **Título:** TeleMetro AR Pro: Nível e Medir
- **Descrição Curta:** Telêmetro óptico trigonométrico, nível de bolha 360°, clinômetro e relatórios PDF.

---

## 3. Comandos de Compilación de Producción

```powershell
# Ejecutar análisis estático y pruebas
C:\flutter\bin\flutter.bat analyze
C:\flutter\bin\flutter.bat test

# Generar Android App Bundle (.aab) para Google Play Store
C:\flutter\bin\flutter.bat build appbundle --release

# Generar APK de distribución directa
C:\flutter\bin\flutter.bat build apk --release
```

---

## 4. Declaración de Seguridad de Datos (Data Safety)
- **¿Recopila o comparte datos del usuario?** No.
- **¿Requiere cuenta de usuario?** No.
- **Política de Privacidad:** Incluida en `privacy_policy.html`.
