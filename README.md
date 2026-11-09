# TeleMetro AR Pro (`com.simpleappspg.telemetroar`)

**TeleMetro AR Pro** es una herramienta de ingeniería y topografía ligera **100% Offline-First** perteneciente a la suite **SimpleAppsPG**. Combina un **Telémetro Óptico Trigonométrico HUD**, un **Nivel de Burbuja 360° y Clinómetro de Doble Eje**, y un **Generador de Informes Técnicos PDF con Firma Digital**.

## Características Principales

1. **Telémetro Trigonométrico HUD (`RangefinderScreen`):**
   - Distancia horizontal: $D = \frac{h_{\text{eye}}}{\tan(|\theta_{\text{base}}|)}$
   - Altura de estructura: $H = h_{\text{eye}} + D \cdot \tan(\theta_{\text{top}})$
   - Distancia de línea visual directa (hipotenusa LOS), pendiente en `%` y relación de techo `X:12`.
   - Visor HUD con horizonte artificial, retícula óptica y triángulo trigonométrico renderizado mediante `CustomPainter`.

2. **Nivel de Burbuja 360° y Clinómetro (`ClinometerLevelScreen`):**
   - Lectura de sensores nativos Android (`MethodChannel('com.simpleappspg.sensors/data')`) con modo de simulación manual integrado para calibración o pruebas de escritorio.
   - Función de **Tara Cero (`0.0°`)**, rumbo magnético y altitud barométrica estimada.

3. **Bitácora Local e Informes PDF Firmados (`SavedMeasurementsScreen`):**
   - Almacenamiento persistente en `SharedPreferences`.
   - Captura de firma manuscrita del operador (`signature`) y exportación a documento A4 (`pdf` + `printing`).

4. **Interfaz Trilingüe Instantánea (`es`, `en`, `pt`):**
   - Cambio en 1 toque desde la pantalla de bienvenida o Ajustes.
   - Estética industrial **SimpleAppsPG Obsidian Dark** (`#0B0F19`, `#161F30`, `#00E676`).

## Comandos de Desarrollo

```powershell
C:\flutter\bin\flutter.bat analyze
C:\flutter\bin\flutter.bat test
```
