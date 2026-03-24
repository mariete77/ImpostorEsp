# 🎨 Guía Completa para Crear Recursos Gráficos

## 📋 Contenido
1. [Icono de la App](#1-icono-de-la-app-512x512-px)
2. [Feature Graphic](#2-feature-graphic-1024x500-px)
3. [Capturas de Pantalla](#3-capturas-de-pantalla)
4. [Herramientas Recomendadas](#4-herramientas-recomendadas)
5. [Tips de Diseño](#5-tips-de-diseño)

---

## 1. ICONO DE LA APP (512x512 px)

### 📐 Especificaciones Técnicas

| Parámetro | Valor |
|-----------|-------|
| **Dimensiones** | 512x512 píxeles exactos |
| **Formato** | PNG |
| **Transparencia** | ❌ NO permitida (fondo sólido) |
| **Escala** | 1:1 (cuadrado) |
| **Área segura** | 424x424 px (centro) |
| **Tamaño máximo** | 1024 KB |

---

### 🎨 Diseño del Icono

#### Concepto para "Impostor España"

**Elementos recomendados:**
- 🔴 Fondo rojo oscuro o negro (temática impostor)
- 👤 Silueta o figura de un personaje
- 🎭 Máscara o elemento de misterio
- 💡 Bombilla o signo de interrogación (el impostor)
- 🇪🇸 Elemento sutil español (opcional)

#### Paleta de Colores Sugerida

```css
/* Colores principales */
--fondo: #1a1a2e o #2c0a0a (rojo oscuro)
--figura: #ffffff o #e94560 (rojo vivo)
--destacado: #fcd34d (amarillo para bombilla/interrogación)
--sombra: #000000 (con opacidad 0.3)
```

---

### 🛠️ MÉTODO 1: Android Asset Studio (Más Fácil)

#### Paso 1: Ir a la Herramienta
1. Ve a: https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html
2. Es gratis y no requiere registro

#### Paso 2: Subir o Crear Imagen

**Opción A: Subir imagen**
1. Clic en "Source"
2. Sube una imagen tuya (PNG, JPG)
3. La herramienta la redimensionará automáticamente

**Opción B: Crear desde texto**
1. Clic en "Text"
2. Escribe: "IE" (Iniciales de Impostor España)
3. Configura fuente, color y fondo

#### Paso 3: Configurar

**Configuración recomendada:**
- **Foreground:** Tu imagen o texto
- **Background color:** #2c0a0a (rojo oscuro)
- **Clip Shape:** Square (cuadrado)
- **Effect:** None o subtle shadow

#### Paso 4: Descargar

1. Clic en "Download"
2. Se descargará un ZIP con todos los tamaños
3. Extrae el ZIP
4. El icono de 512x512 estará en `mipmap-xxxhdpi/ic_launcher.png`

---

### 🛠️ MÉTODO 2: Canva (Más Personalizado)

#### Paso 1: Crear Cuenta
1. Ve a https://canva.com
2. Crea cuenta gratis
3. Busca "App Icon" en plantillas

#### Paso 2: Configurar Diseño

1. **Dimensiones:** 512x512 px
2. **Fondo:**
   - Color sólido: #2c0a0a (rojo oscuro)
   - O gradiente: de #2c0a0a a #1a1a2e

3. **Elementos principales:**
   - Busca "person" o "avatar"
   - Añade silueta en el centro
   - Color: #ffffff (blanco) o #e94560 (rojo vivo)

4. **Elemento destacado:**
   - Bombilla amarilla 💡 en esquina
   - O signo de interrogación ❓
   - Color: #fcd34d (amarillo)

5. **Texto (opcional):**
   - "IE" o "IM"
   - Fuente: Bold, sans-serif
   - Color: Blanco con sombra

#### Paso 3: Ajustes Finales

1. **Contraste:** Asegúrate que se vea bien en fondo oscuro
2. **Tamaño:** Elementos ocupando 70-80% del espacio
3. **Centrado:** Todo perfectamente centrado
4. **Exportar:**
   - Formato: PNG
   - Calidad: Máxima
   - Sin fondo transparente

#### Paso 4: Exportar y Guardar

1. Clic en "Share" → "Download"
2. PNG
3. 512x512 px
4. Guardar como `icono_app.png`

---

### 🛠️ MÉTODO 3: Figma (Profesional)

#### Paso 1: Crear Nuevo Proyecto
1. Ve a https://figma.com
2. "New design file"
3. Configura frame: 512x512 px

#### Paso 2: Diseño Profesional

**Capa 1: Fondo**
- Rectangle tool (R)
- Dimensiones: 512x512
- Fill: #2c0a0a
- Stroke: Ninguno

**Capa 2: Silueta**
- Shape tools (O)
- Círculo o forma de persona
- Fill: #ffffff
- Position: Centro
- Size: 300x300 px

**Capa 3: Elemento destacado**
- Bombilla o signo de interrogación
- Fill: #fcd34d
- Position: Esquina superior derecha
- Size: 100x100 px

**Capa 4: Sombra (opcional)**
- Drop shadow
- Color: #000000
- Opacity: 0.3
- Blur: 10px

#### Paso 3: Exportar

1. Selecciona todo (Ctrl+A)
2. Panel derecho → "Export"
3. Format: PNG
4. Scale: 1x (512x512)
5. Export

---

### ✅ VERIFICACIÓN FINAL

Antes de usar el icono:

```bash
# Verificar dimensiones
# En Windows: Clic derecho → Propiedades → Detalles
# Debe decir: 512 x 512 píxeles

# Verificar formato
# Debe ser PNG

# Verificar transparencia
# Abre en Paint o similar
# El fondo debe ser sólido, no transparente
```

**Checklist del icono:**
- [ ] 512x512 píxeles exactos
- [ ] Formato PNG
- [ ] Sin transparencia
- [ ] Contraste suficiente
- [ ] Legible a tamaño pequeño
- [ ] Centrado correctamente
- [ ] Menos de 1024 KB

---

## 2. FEATURE GRAPHIC (1024x500 px)

### 📐 Especificaciones Técnicas

| Parámetro | Valor |
|-----------|-------|
| **Dimensiones** | 1024x500 píxeles exactos |
| **Formato** | JPG o PNG (24-bit) |
| **Transparencia** | ❌ NO permitida |
| **Escala** | 2:1 (aproximadamente) |
| **Tamaño máximo** | 1 MB |

---

### 🎨 Diseño del Feature Graphic

#### Propósito
Es la imagen grande que aparece en la parte superior de la página de tu app en Play Store. Debe:
- ✅ Mostrar el juego en acción
- ✅ Ser atractivo visualmente
- ✅ Incluir el nombre de la app
- ✅ Tener texto legible

#### Elementos Recomendados

**1. Fondo**
- Gradiente: #2c0a0a a #1a1a2e (rojo oscuro a negro)
- O imagen de fondo (sombreado con overlay)

**2. Captura del juego**
- Screenshot de la app en el centro
- Añadir borde o sombra
- Tamaño: ~600x350 px

**3. Nombre de la app**
- Texto grande: "IMPOSTOR ESPAÑA"
- Fuente: Bold, sans-serif
- Color: #ffffff
- Posición: Arriba o superpuesto

**4. Elementos decorativos**
- Iconos de juego (👤, 🎭, 💡)
- Efectos de luz o degradados
- Estrellas o destellos

**5. Texto de llamada**
- "Descubre al impostor"
- "Juego de palabras español"
- Opcional, pero recomendado

---

### 🛠️ MÉTODO 1: Canva (Recomendado)

#### Paso 1: Plantilla Base

1. Ve a https://canva.com
2. Busca "Google Play Feature Graphic"
3. O crea diseño personalizado: 1024x500 px

#### Paso 2: Diseñar Capas

**Capa 1: Fondo**
- Color sólido: #2c0a0a
- O gradiente: de #2c0a0a a #1a1a2e
- Añadir textura sutil (opcional)

**Capa 2: Captura del juego**
- Toma screenshot de tu app
- Redimensiona a: 600x350 px
- Añade sombra: Drop shadow
- Centra horizontalmente
- Posición vertical: ligeramente abajo del centro

**Capa 3: Overlay (sobre la captura)**
- Gradiente oscuro en la parte superior
- Opacidad: 30-50%
- Hace que el texto sea legible

**Capa 4: Texto principal**
- "IMPOSTOR ESPAÑA"
- Fuente: Montserrat o Poppins (Bold, 60-80px)
- Color: #ffffff
- Posición: Centro-arriba
- Sombra: Drop shadow suave

**Capa 5: Texto secundario**
- "Descubre quién es el impostor"
- Fuente: Medium, 30-40px
- Color: #fcd34d (amarillo)
- Posición: Debajo del texto principal

**Capa 6: Elementos decorativos**
- Iconos pequeños: 👤 🎭 💡 ❓
- Colores: #ffffff con baja opacidad
- Dispersos por el diseño

#### Paso 3: Ajustes Finales

1. **Contraste:** Verifica que el texto sea legible
2. **Balance:** Elementos distribuidos equitativamente
3. **Jerarquía:** Nombre de app más prominente
4. **Colores:** Paleta coherente con el icono

#### Paso 4: Exportar

1. "Share" → "Download"
2. Formato: JPG (mejor para fotos) o PNG
3. Calidad: Máxima
4. 1024x500 px

---

### 🛠️ MÉTODO 2: Adobe Express

#### Paso 1: Crear Proyecto

1. Ve a https://express.adobe.com
2. "Custom size"
3. 1024x500 px

#### Paso 2: Usar Plantilla de Google Play

1. Busca "Google Play Store graphic"
2. Elige plantilla similar
3. Personaliza con tu branding

#### Paso 3: Añadir Tu Captura

1. "Upload" → "Media"
2. Sube screenshot de tu app
3. Ajusta posición y tamaño
4. Añade efectos (sombra, borde)

#### Paso 4: Personalizar Texto

1. Clic en texto de plantilla
2. Cambia a "IMPOSTOR ESPAÑA"
3. Ajusta fuente, tamaño, color
4. Añade texto secundario

#### Paso 5: Exportar

- "Download"
- JPG o PNG
- Máxima calidad

---

### ✅ VERIFICACIÓN FINAL

**Checklist del feature graphic:**
- [ ] 1024x500 píxeles exactos
- [ ] Formato JPG o PNG
- [ ] Sin transparencia
- [ ] Texto legible y centrado
- [ ] Captura del juego visible
- [ ] Colores coherentes con el icono
- [ ] Menos de 1 MB
- [ ] Nombre de la app visible

---

## 3. CAPTURAS DE PANTALLA

### 📱 Especificaciones Técnicas

| Parámetro | Valor |
|-----------|-------|
| **Mínimo** | 2 capturas |
| **Máximo** | 8 capturas |
| **Ancho** | 320-3840 píxeles |
| **Alto** | 320-3840 píxeles |
| **Formato** | JPG o PNG |
| **Barras de estado** | ❌ NO permitidas |

---

### 🎯 Qué Capturas Tomar (Orden Recomendado)

1. **Pantalla de inicio** - Muestra el título y logo
2. **Selección de jugadores** - Muestra el número de jugadores
3. **Pantalla del juego** - Muestra jugadores en acción
4. **Sistema de votación** - Muestra la mecánica de votación
5. **Revelación del impostor** - Momento clave del juego
6. **Configuración** - Muestra opciones disponibles

---

### 🛠️ MÉTODO 1: Emulador Android (Recomendado)

#### Paso 1: Configurar Emulador

1. Abre Android Studio
2. "AVD Manager"
3. Crea o selecciona emulador
4. Configura:
   - Device: Pixel 5 o similar
   - Android: 10+ (Android 10 o superior)
   - RAM: 4GB+ (mejor rendimiento)

#### Paso 2: Ejecutar App

```bash
# En el proyecto
flutter run -d <device_id>
```

O desde Android Studio:
- Clic en "Run" botón verde
- Elige el emulador

#### Paso 3: Quitar Barras de Estado

**Opción A: Comando ADB (Más permanente)**
```bash
# Modo inmersivo (quita barra de estado)
adb shell settings put global policy_control immersive.full=*

# Verificar que funciona
# La barra de estado debería desaparecer
```

**Opción B: Desde Emulador (Más rápido)**
1. En el emulador: Ctrl+Shift+P
2. Esto oculta la barra de herramientas
3. A veces también oculta barra de estado

**Opción C: Editar Captura Después**
1. Toma la captura con barra de estado
2. Recorta la parte superior (~40px)
3. En Paint, Photoshop, o similar

#### Paso 4: Navegar por la App y Capturar

**Captura 1: Pantalla de Inicio**
```bash
# En emulador
# Asegúrate de que la app esté en pantalla de inicio

# Tomar captura
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png captura_1_inicio.png
```

**Captura 2: Selección de Jugadores**
```bash
# Navega a pantalla de selección de jugadores
# Selecciona 5 jugadores como ejemplo

# Tomar captura
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png captura_2_jugadores.png
```

**Captura 3: Pantalla de Juego**
```bash
# Inicia una partida
# Espera a que cargue
# Asegúrate de mostrar varios jugadores

# Tomar captura
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png captura_3_juego.png
```

**Captura 4: Votación**
```bash
# Navega a pantalla de votación
# Muestra jugadores votando

# Tomar captura
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png captura_4_votacion.png
```

**Captura 5: Revelación**
```bash
# Muestra pantalla de revelación del impostor
# Este es un momento clave del juego

# Tomar captura
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png captura_5_revelacion.png
```

#### Paso 5: Restaurar Barras de Estado

```bash
# Opcional: Restaurar barras de estado
adb shell settings put global policy_control null
```

---

### 🛠️ MÉTODO 2: Dispositivo Físico

#### Paso 1: Preparar Dispositivo

1. Conecta dispositivo por USB
2. Activa "Depuración USB" en:
   - Ajustes → Información del teléfono
   - Tocar "Número de compilación" 7 veces
   - Volver a Ajustes → Opciones de desarrollador
   - Activa "Depuración USB"

3. Verificar conexión:
```bash
adb devices
# Debería mostrar tu dispositivo
```

#### Paso 2: Ejecutar App

```bash
flutter run
```

#### Paso 3: Tomar Capturas

**Opción A: Desde dispositivo**
1. Presiona Vol- + Power simultáneamente
2. Las capturas se guardan en Galería
3. Transfiere al PC

**Opción B: Desde PC (Recomendado)**
```bash
# Igual que en emulador
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png captura.png
```

#### Paso 4: Editar Capturas

1. Abre cada captura en editor de imágenes
2. **Recorta** la barra de estado (top 40px)
3. **Recorta** la barra de navegación (bottom 60px)
4. **Ajusta** al tamaño deseado
5. Guarda como JPG o PNG

---

### 🛠️ MÉTODO 3: Editar Capturas Post-Producción

#### Paso 1: Usar Figma o Canva

**En Canva:**
1. Crea nuevo diseño: 1080x1920 (portrait) o 1920x1080 (landscape)
2. Sube tu captura
3. Añade:
   - Marco o borde (opcional)
   - Texto descriptivo (opcional)
   - Flechas o indicadores (opcional)

**En Figma:**
1. Nuevo frame: 1080x1920
2. Drag & drop captura
3. Añade capas adicionales:
   - Texto explicativo
   - Efectos visuales
   - Overlay con branding

#### Paso 2: Mejorar Calidad

**Ajustes en Photoshop/GIMP/Paint.NET:**

1. **Brillo y Contraste:**
   - Aumenta contraste ligeramente (+10%)
   - Ajusta brillo si es necesario

2. **Nitidez:**
   - Aplica "Sharpen" o "Unsharp mask"
   - Cantidad: 50-100%

3. **Color:**
   - Satura colores ligeramente (+5-10%)
   - Corrige balance de blancos si es necesario

4. **Recorte:**
   - Elimina barras de estado
   - Elimina barras de navegación
   - Asegura dimensiones correctas

---

### ✅ VERIFICACIÓN FINAL

**Checklist de capturas:**
- [ ] Mínimo 2, máximo 8 capturas
- [ ] Ancho: 320-3840 píxeles
- [ ] Alto: 320-3840 píxeles
- [ ] Formato JPG o PNG
- [ ] Sin barras de estado
- [ ] Sin barras de navegación
- [ ] Texto legible
- [ ] Interfaz de la app visible
- [ ] Cada captura muestra diferente aspecto del juego
- [ ] Orden lógico (inicio → juego → votación → revelación)

---

## 4. HERRAMIENTAS RECOMENDADAS

### 🎨 Para Diseño Gráfico

| Herramienta | Costo | Nivel | Link |
|-------------|-------|-------|------|
| **Canva** | Gratis/Pago | Principiante | canva.com |
| **Android Asset Studio** | Gratis | Principiante | romannurik.github.io/AndroidAssetStudio |
| **Figma** | Gratis/Pago | Intermedio | figma.com |
| **Adobe Express** | Gratis/Pago | Intermedio | express.adobe.com |
| **GIMP** | Gratis | Avanzado | gimp.org |
| **Paint.NET** | Gratis | Intermedio | getpaint.net |
| **Adobe Photoshop** | Pago | Avanzado | adobe.com/photoshop |

### 📱 Para Capturas de Pantalla

| Herramienta | Costo | Uso |
|-------------|-------|-----|
| **ADB** | Gratis | Comando línea |
| **Scrcpy** | Gratis | Mirroring y capturas |
| **DroidCam** | Gratis/Pago | Webcam móvil |
| **Android Studio** | Gratis | Capturas integradas |

### 🖼️ Para Editar Capturas

| Herramienta | Costo | Características |
|-------------|-------|----------------|
| **Paint** | Gratis (Windows) | Básico |
| **Paint.NET** | Gratis | Intermedio |
| **GIMP** | Gratis | Avanzado |
| **Photoshop** | Pago | Profesional |
| **Figma** | Gratis | Web, colaborativo |
| **Canva** | Gratis/Pago | Plantillas |

---

## 5. TIPS DE DISEÑO

### 🎨 Principios Generales

1. **Consistencia:**
   - Mismos colores en icono, feature graphic y capturas
   - Misma tipografía si es posible
   - Mismo estilo visual

2. **Contraste:**
   - Texto siempre legible
   - Fondo oscuro → Texto claro
   - Fondo claro → Texto oscuro

3. **Simplicidad:**
   - Menos es más
   - Evita saturar el diseño
   - Elementos esenciales solo

4. **Jerarquía Visual:**
   - Elemento más importante = más grande/brillante
   - Secuencia visual clara
   - Guía el ojo del usuario

### 📱 Para Iconos

- ✅ Usa 2-3 colores máximo
- ✅ Elementos grandes y simples
- ✅ Centrado perfecto
- ✅ Sin texto (símbolos mejor)
- ❌ Sin detalles finos (se pierden)
- ❌ Sin bordes cortados
- ❌ Sin fotos (usa gráficos)

### 🖼️ Para Feature Graphic

- ✅ Nombre de la app visible
- ✅ Captura del juego clara
- ✅ Colores coherentes con el icono
- ✅ Texto legible sobre la captura
- ❌ Sin texto demasiado largo
- ❌ Sin capturas borrosas
- ❌ Sin exceso de elementos

### 📸 Para Capturas

- ✅ Muestra la app en acción
- ✅ Interfaz clara y visible
- ✅ Múltiples pantallas diferentes
- ✅ Sin barras de estado/navegación
- ✅ Alta calidad/nitidez
- ❌ Sin capturas vacías
- ❌ Sin capturas borrosas
- ❌ Sin barras de estado visibles

---

## 📝 CHECKLIST FINAL

### Antes de Subir a Play Console:

**Icono (512x512):**
- [ ] Dimensiones correctas
- [ ] PNG sin transparencia
- [ ] Contrastante y legible
- [ ] Centrado perfectamente

**Feature Graphic (1024x500):**
- [ ] Dimensiones correctas
- [ ] JPG o PNG
- [ ] Nombre de la app visible
- [ ] Captura del juego clara
- [ ] Texto legible

**Capturas de Pantalla (2-8):**
- [ ] Mínimo 2 capturas
- [ ] Sin barras de estado
- [ ] Diferentes pantallas del juego
- [ ] Alta calidad
- [ ] JPG o PNG

---

## 🚀 RECURSOS ADICIONALES

### Guías Oficiales:
- [Google Play Store Listing Guidelines](https://support.google.com/googleplay/android-developer/answer/10787469)
- [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/)

### Inspiración:
- Busca apps similares en Play Store
- Analiza sus iconos y capturas
- Identifica qué funciona bien

### Plantillas:
- Canva → "Google Play" → Plantillas
- Figma Community → "App Store" → Plantillas
- Android Asset Studio → Icon Launcher

---

**¡Con esta guía tendrás recursos gráficos profesionales en poco tiempo! 🎨📱**