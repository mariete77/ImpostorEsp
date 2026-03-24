# 📋 Pasos Finales para Publicar en Play Store

## 🎯 RESUMEN: Lo que falta completar

Basado en el análisis del proyecto, estos son los pasos pendientes para subir la app al Play Store:

---

## ✅ LO QUE YA ESTÁ COMPLETO

- [x] Keystore configurado
- [x] Firma de la app configurada
- [x] Política de privacidad creada (`privacy_policy.html`)
- [x] Iconos básicos de la app (ic_launcher.png en todas las resoluciones)
- [x] Configuración de build.gradle
- [x] Permisos justificados
- [x] Orientación de pantalla fija
- [x] Guías completas creadas

---

## ❌ LO QUE FALTA COMPLETAR

### 1. 🖼️ ICONO DE LA APP (512x512)

**Estado:** Tienes los iconos básicos pero necesitas verificar si tienes el de 512x512

**Qué hacer:**
1. **Verificar si ya tienes el icono de 512x512:**
   - Revisa en `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`
   - Este debería ser de 512x512 px

2. **Si NO lo tienes o quieres uno personalizado:**
   - Sigue la guía: `GUIA_RECURSOS_GRAFICOS.md` → Sección 1
   - **Referencia rápida:**
     - Ir a: https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html
     - Subir una imagen o crear desde texto ("IE" para Impostor España)
     - Configurar fondo: #2c0a0a (rojo oscuro)
     - Descargar el ZIP
     - Extraer y usar `mipmap-xxxhdpi/ic_launcher.png`

3. **Especificaciones requeridas:**
   - Dimensiones: 512x512 px exactos
   - Formato: PNG
   - Sin transparencia (fondo sólido)
   - Máximo: 1024 KB

---

### 2. 🎨 FEATURE GRAPHIC (1024x500)

**Estado:** NO EXISTE - Debes crearlo desde cero

**Qué hacer:**
1. **Sigue la guía:** `GUIA_RECURSOS_GRAFICOS.md` → Sección 2

2. **Referencias rápidas:**
   - **Herramienta recomendada:** https://canva.com
   - **Dimensiones:** 1024x500 px exactos
   - **Formato:** JPG o PNG
   - **Contenido sugerido:**
     - Fondo: Gradiente de rojo oscuro (#2c0a0a) a negro (#1a1a2e)
     - Captura de la app en el centro (~600x350 px)
     - Texto grande: "IMPOSTOR ESPAÑA"
     - Texto secundario: "Descubre quién es el impostor"
     - Elementos decorativos: 👤 🎭 💡 ❓

3. **Pasos en Canva:**
   - Crear diseño personalizado: 1024x500 px
   - Añadir fondo con degradado
   - Tomar screenshot de la app y subirlo
   - Añadir texto con el nombre de la app
   - Exportar como JPG o PNG

---

### 3. 📸 CAPTURAS DE PANTALLA (Mínimo 2)

**Estado:** NO EXISTEN - Debes tomarlas

**Qué hacer:**
1. **Sigue la guía:** `GUIA_RECURSOS_GRAFICOS.md` → Sección 3

2. **Referencias rápidas:**
   - **Mínimo:** 2 capturas
   - **Máximo:** 8 capturas
   - **Dimensiones:** 320-3840 px de ancho/alto
   - **Formato:** JPG o PNG
   - **IMPORTANTE:** Sin barras de estado ni navegación

3. **Capturas recomendadas (en orden):**
   - **Captura 1:** Pantalla de inicio (título y logo)
   - **Captura 2:** Selección de jugadores (número de jugadores)
   - **Captura 3:** Pantalla del juego (jugadores en acción)
   - **Captura 4:** Sistema de votación
   - **Captura 5:** Revelación del impostor

4. **Cómo tomarlas (Opción más fácil):**
   ```bash
   # 1. Ejecutar la app en emulador
   flutter run -d <device_id>
   
   # 2. Navegar a la pantalla deseada
   
   # 3. Ocultar barra de estado (opcional, puedes recortar después)
   # En emulador: Ctrl+Shift+P
   
   # 4. Tomar captura
   adb shell screencap -p /sdcard/screen.png
   adb pull /sdcard/screen.png captura_1_inicio.png
   ```

5. **Recortar barras:**
   - Abre cada captura en Paint, Paint.NET, o similar
   - Recorta la barra superior (~40px)
   - Recorta la barra inferior (~60px)
   - Guarda como JPG o PNG

---

### 4. 📝 DESCRIPCIONES DE LA APP

**Estado:** Ya preparadas en `GUIA_PUBLICACION_PLAY_STORE.md`

**Referencias:**
- **Título corto (máx. 30 caracteres):** "El Impostor"
- **Título completo (máx. 50 caracteres):** "El Impostor - Juego de Rol"
- **Descripción corta (máx. 80 caracteres):** "¡Descubre quién es el impostor en este juego de rol español!"
- **Descripción completa:** Ver sección 5.4 en `GUIA_PUBLICACION_PLAY_STORE.md`
- **Palabras clave:** impostor, juego de rol, misterio, deducción, amigos, familia, fiesta, juego social, Among Us español, juego de mesa, adivina quién, rol, detectives, juego de grupo

---

### 5. 🌐 POLÍTICA DE PRIVACIDAD

**Estado:** ✅ YA CREADA (`privacy_policy.html`)

**Qué falta:**
- Subir este archivo a un sitio web para tener una URL pública
- **Opción 1 (Más fácil):** Subir a GitHub Pages
- **Opción 2:** Subir a cualquier hosting gratuito

**Pasos para GitHub Pages:**
1. Sube `privacy_policy.html` a tu repositorio de GitHub
2. Ve a Settings → Pages
3. Activa GitHub Pages desde la rama main
4. Copia la URL generada (ej: https://mariete77.github.io/ImpostorEsp/privacy_policy.html)
5. Usa esta URL en Play Console

---

### 6. 🚀 GENERAR EL AAB FINAL

**Estado:** Pendiente de generación final

**Qué hacer:**
1. **Limpiar build previo:**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Generar AAB de release:**
   ```bash
   flutter build appbundle --release
   ```

3. **Verificar que se generó:**
   - El archivo estará en: `build/app/outputs/bundle/release/app-release.aab`
   - Debería pesar aproximadamente 10-15 MB

---

### 7. 📱 PUBLICAR EN PLAY CONSOLE

**Estado:** Pendiente de subir

**Pasos:**

1. **Ir a Play Console:**
   - https://play.google.com/console
   - Iniciar sesión con tu cuenta de desarrollador

2. **Crear nueva aplicación:**
   - Clic en "Crear app"
   - Nombre: "El Impostor - Juego de Rol"
   - Categoría: Juegos
   - Gratis/De pago: Gratis

3. **Completar datos principales:**
   - Título: "El Impostor - Juego de Rol"
   - Descripción corta: (de sección 4)
   - Descripción completa: (de sección 4)
   - URL de política de privacidad: (la URL de GitHub Pages)

4. **Subir recursos gráficos:**
   - Icono de la app: Subir archivo de 512x512
   - Feature graphic: Subir archivo de 1024x500
   - Capturas de pantalla: Subir mínimo 2 capturas
   - Banner (promocional): Opcional, 180x120 px

5. **Clasificación de contenido:**
   - Completa el cuestionario
   - Tu app probablemente será "Para todos"

6. **Público objetivo:**
   - Define tu público (jóvenes +13, adultos, etc.)

7. **Subir el AAB:**
   - Sección "Paquetes de producción"
   - Subir el archivo `app-release.aab`
   - Esperar a que se procese

8. **Revisar y publicar:**
   - Verifica toda la información
   - Clic en "Publicar"
   - Esperar aprobación (1-3 días hábiles)

---

## 📋 CHECKLIST COMPLETO

### Antes de empezar:
- [ ] Cuenta de Google Play Console activa ($25 USD)
- [ ] Identidad verificada en Play Console

### Recursos gráficos:
- [ ] Icono de la app (512x512, PNG sin transparencia)
- [ ] Feature graphic (1024x500, JPG/PNG)
- [ ] Mínimo 2 capturas de pantalla (sin barras)
- [ ] Banner opcional (180x120)

### Contenido:
- [ ] Título corto: "El Impostor"
- [ ] Título completo: "El Impostor - Juego de Rol"
- [ ] Descripción corta: "¡Descubre quién es el impostor en este juego de rol español!"
- [ ] Descripción completa: Copiada de guía
- [ ] Palabras clave: Configuradas

### Documentos:
- [ ] Política de privacidad en línea (URL pública)

### Build:
- [ ] AAB generado con `flutter build appbundle --release`
- [ ] AAB verificado y probado

### Publicación:
- [ ] App creada en Play Console
- [ ] Todos los formularios completados
- [ ] Recursos gráficos subidos
- [ ] AAB subido
- [ ] Revisión final completada
- [ ] ¡Publicado!

---

## 🎯 PRIORIDAD DE ACCIÓN

### Fase 1: Recursos gráficos (2-3 horas)
1. Crear icono de 512x512 (30 min)
2. Crear feature graphic de 1024x500 (1 hora)
3. Tomar 2-5 capturas de pantalla (30 min - 1 hora)

### Fase 2: Documentos (30 min)
1. Subir política de privacidad a GitHub Pages (30 min)

### Fase 3: Build y publicación (30 min)
1. Generar AAB final (10 min)
2. Subir todo a Play Console (20 min)

**Tiempo total estimado:** 3-4 horas

---

## 🔗 REFERENCIAS RÁPIDAS

### Para crear icono:
- Android Asset Studio: https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html
- Guía completa: `GUIA_RECURSOS_GRAFICOS.md` → Sección 1

### Para crear feature graphic:
- Canva: https://canva.com
- Guía completa: `GUIA_RECURSOS_GRAFICOS.md` → Sección 2

### Para capturas:
- Guía completa: `GUIA_RECURSOS_GRAFICOS.md` → Sección 3

### Para publicación:
- Play Console: https://play.google.com/console
- Guía completa: `GUIA_PUBLICACION_PLAY_STORE.md`

### Para política de privacidad:
- GitHub Pages: https://pages.github.com/
- Archivo existente: `privacy_policy.html`

---

## 💡 TIPS IMPORTANTES

1. **El icono es lo más importante:** Es lo primero que ve el usuario. Invierte tiempo en hacerlo bien.

2. **Las capturas deben ser de calidad:** Tómalas en un dispositivo real o emulador de alta resolución.

3. **Feature graphic:** Esta imagen es la primera que aparece en Play Store. Hazla atractiva.

4. **Guarda el keystore:** Sin el keystore, no podrás actualizar la app. Guárdalo en lugar seguro.

5. **Lee las políticas:** Antes de publicar, lee las políticas de Google Play para evitar rechazos.

6. **Prueba la app:** Antes de publicar, prueba exhaustivamente la app en diferentes dispositivos.

---

## 🆘 SI NECESITAS AYUDA

Si tienes problemas en algún paso:

1. Revisa las guías completas:
   - `GUIA_RECURSOS_GRAFICOS.md`
   - `GUIA_PUBLICACION_PLAY_STORE.md`

2. Consulta la documentación oficial:
   - [Google Play Console Help](https://support.google.com/googleplay/android-developer)
   - [Flutter Publishing](https://docs.flutter.dev/deployment/android)

3. Verifica los logs:
   ```bash
   flutter doctor
   flutter build appbundle --release --verbose
   ```

---

**¡Mucha suerte con la publicación! 🚀**

Una vez completados estos pasos, tu app estará disponible en Google Play Store para que cualquiera la descargue.