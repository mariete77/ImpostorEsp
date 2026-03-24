# Guía Completa para Publicar en Google Play Store

## 📋 Índice
1. [Configuración del Keystore](#1-configuración-del-keystore)
2. [Generar el AAB (Android App Bundle)](#2-generar-el-aab-android-app-bundle)
3. [Requisitos para Play Store](#3-requisitos-para-play-store)
4. [Preparar Recursos Gráficos](#4-preparar-recursos-gráficos)
5. [Descripciones de la Aplicación](#5-descripciones-de-la-aplicación)
6. [Política de Privacidad y Términos](#6-política-de-privacidad-y-términos)
7. [Proceso de Publicación](#7-proceso-de-publicación)

---

## 1. Configuración del Keystore

### 1.1 Crear el Keystore

El keystore es necesario para firmar tu aplicación. Solo necesitas crearlo una vez.

**Usando keytool (viene con Java):**

```bash
keytool -genkey -v -keystore ~/keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias impostoresp
```

**En Windows:**
```bash
keytool -genkey -v -keystore C:\Users\TU_USUARIO\keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias impostoresp
```

**Importante:**
- Guarda este archivo `.jks` en un lugar seguro. Si lo pierdes, NO podrás actualizar la app
- La validez de 10000 días (aprox. 27 años) es lo recomendado
- Guárdalo en la carpeta `android/` del proyecto

### 1.2 Configurar key.properties

Edita el archivo `android/key.properties` que ya he creado:

```properties
storePassword=TU_CONTRASEÑA_KEYSTORE
keyPassword=TU_CONTRASEÑA_LLAVE
keyAlias=impostoresp
storeFile=../keystore.jks
```

**⚠️ MUY IMPORTANTE:**
- Este archivo ya está en `.gitignore` para que no se suba al repositorio
- GUARDA ESTAS CONTRASEÑAS en un lugar seguro (gestor de contraseñas)
- Sin estas contraseñas no podrás actualizar la app en el futuro

---

## 2. Generar el AAB (Android App Bundle)

### 2.1 Limpiar build previo

```bash
flutter clean
flutter pub get
```

### 2.2 Generar el AAB de Release

```bash
flutter build appbundle --release
```

El archivo generado estará en:
```
build/app/outputs/bundle/release/app-release.aab
```

### 2.3 Probar el AAB (Opcional pero recomendado)

Para verificar que el AAB es válido:
```bash
java -jar bundletool.jar build-apks --bundle=app-release.aab --output=app.apks
java -jar bundletool.jar install-apks --apks=app.apks
```

---

## 3. Requisitos para Play Store

### 3.1 Cuenta de Desarrollador

- [x] Cuenta de Google
- [ ] Cuenta de Google Play Console ($25 USD pago único)
- [ ] Verificar identidad (pasaporte/DNI)

### 3.2 Requisitos Técnicos Cumplidos ✅

- [x] Application ID único: `com.impostoresp.impostor_espana`
- [x] Versión: 1.0.0+1 (versionCode: 1, versionName: 1.0.0)
- [x] Target SDK actualizado
- [x] Permisos mínimos y justificados
- [x] Orientación de pantalla fija (portrait)
- [x] Soporte RTL (Right-to-Left)
- [x] No usa cleartext traffic (seguridad)
- [x] Firma del keystore configurada

### 3.3 Políticas de Play Store

Tu aplicación DEBE cumplir:
- [ ] **Política de contenido**: No contenido inapropiado (tu app es un juego de rol, cumple)
- [ ] **Permisos**: Solo usa WAKE_LOCK, INTERNET y ACCESS_NETWORK_STATE (justificados)
- [ ] **Privacidad**: Debes proporcionar una política de privacidad (ver sección 6)
- [ ] **Target API**: Target SDK debe ser de los últimos 2 años (comprueba en build.gradle)

---

## 4. Preparar Recursos Gráficos

### 4.1 Iconos de la Aplicación

**Tamaños requeridos:**
- Icono de la app: 512x512 px (PNG sin transparencia)
- Feature graphic: 1024x500 px (JPG o PNG)

**Iconos para Store Listing:**
- High-res icon: 512x512 px (PNG sin transparencia, esquinas redondeadas)
- Phone screenshots: mínimo 2, máximo 8 screenshots (320-3840px ancho, sin barras de estado)
- 7-inch tablet screenshots: 0-8 (opcional)
- 10-inch tablet screenshots: 0-8 (opcional)

### 4.2 Banner (Promo Art)

**Tamaño:** 180x120 px (JPG o 24-bit PNG sin transparencia)

---

## 5. Descripciones de la Aplicación

### 5.1 Título Corto (Máx. 30 caracteres)
```
El Impostor
```

### 5.2 Título Completo (Máx. 50 caracteres)
```
El Impostor - Juego de Rol
```

### 5.3 Descripción Corta (Máx. 80 caracteres)
```
¡Descubre quién es el impostor en este juego de rol español!
```

### 5.4 Descripción Completa (Máx. 4000 caracteres)

```
🎭 ¿Listo para descubrir al impostor?

El Impostor es un emocionante juego de rol inspirado en Among Us, diseñado para jugar con amigos y familia. Perfecto para fiestas, reuniones y noches de juego.

🎮 **CÓMO JUGAR:**
1. Reúne un grupo de 4-15 jugadores
2. Cada uno recibe un rol secreto: ¡alguien es el impostor!
3. El impostor debe engañar a los demás sin ser descubierto
4. Los jugadores deben discutir y votar quién es el impostor
5. ¡El impostor gana si no es descubiert!

🌟 **CARACTERÍSTICAS:**
• Roles secretos con palabras temáticas españolas
• Música de ambiente inmersiva
• Interfaz intuitiva y fácil de usar
• Diseño atractivo y moderno
• No requiere conexión a internet constante
• Juego ideal para todo tipo de grupos

🎯 **PARA QUIÉN ES:**
• Amigos que buscan un juego divertido
• Familias en reuniones
• Fiestas y eventos sociales
• Grupos de trabajo (team building)
• Cualquier persona que disfrute de los juegos de deducción

🎨 **TEMÁTICA ESPAÑOLA:**
Todas las palabras y roles están diseñados con elementos de la cultura española, haciendo el juego aún más entretenido y cercano.

💡 **CONSEJOS:**
• Observa bien el comportamiento de todos
• Haz preguntas estratégicas
• No confíes demasiado rápido
• ¡Diviértete y disfruta del misterio!

📝 **NOTA:**
Este es un juego de rol local. Todos los jugadores deben estar en el mismo lugar para jugar. Requiere comunicación entre jugadores.

¿Eres capaz de descubrir al impostor antes de que sea demasiado tarde? ¡Descarga El Impostor y descúbrelo!

🔥 ¡Descubre quién es el impostor entre tus amigos!
```

### 5.5 Palabras Clave (Tags)
```
impostor, juego de rol, misterio, deducción, amigos, familia, fiesta, juego social, Among Us español, juego de mesa, adivina quién, rol, detectives, juego de grupo
```

---

## 6. Política de Privacidad y Términos

### 6.1 Política de Privacidad (URL requerida)

Crea un archivo `privacy_policy.html` y súbelo a tu sitio web o usa GitHub Pages:

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Política de Privacidad - El Impostor</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1 { color: #333; }
        h2 { color: #555; margin-top: 30px; }
    </style>
</head>
<body>
    <h1>Política de Privacidad - El Impostor</h1>
    <p>Última actualización: 20 de marzo de 2026</p>
    
    <h2>1. Introducción</h2>
    <p>En "El Impostor", respetamos tu privacidad y estamos comprometidos a protegerla. Esta política de privacidad explica cómo recopilamos, usamos y protegemos tu información.</p>
    
    <h2>2. Información que Recopilamos</h2>
    <p>Nuestra aplicación es un juego local que no recopila datos personales sensibles. La única información que podemos almacenar localmente incluye:</p>
    <ul>
        <li>Preferencias de juego (guardadas en el dispositivo)</li>
        <li>Estadísticas de partidas jugadas (opcional, guardadas localmente)</li>
    </ul>
    
    <h2>3. Uso de la Información</h2>
    <p>Toda la información se utiliza únicamente para mejorar la experiencia de juego dentro de la aplicación:</p>
    <ul>
        <li>Guardar preferencias del usuario</li>
        <li>Mantener estadísticas de juego</li>
        <li>Mejorar la funcionalidad de la aplicación</li>
    </ul>
    
    <h2>4. No Recopilamos Datos Personales</h2>
    <p>Nuestra aplicación:</p>
    <ul>
        <li>NO recopila nombre, email, teléfono ni otros datos personales</li>
        <li>NO envía datos a servidores externos</li>
        <li>NO utiliza análisis de terceros</li>
        <li>NO muestra publicidad personalizada</li>
    </ul>
    
    <h2>5. Permisos de la Aplicación</h2>
    <p>La aplicación solicita los siguientes permisos con estos propósitos:</p>
    <ul>
        <li><strong>INTERNET:</strong> No utilizado actualmente (reservado para posibles futuras funcionalidades)</li>
        <li><strong>ACCESS_NETWORK_STATE:</strong> Para verificar conectividad (opcional)</li>
        <li><strong>WAKE_LOCK:</strong> Para mantener la pantalla encendida durante el juego</li>
    </ul>
    
    <h2>6. Datos del Niño</h2>
    <p>Nuestra aplicación no recopila información personal de niños menores de 13 años. No requerimos registro ni cuenta para jugar.</p>
    
    <h2>7. Almacenamiento de Datos</h2>
    <p>Todos los datos se almacenan localmente en el dispositivo del usuario. El usuario puede eliminarlos desinstalando la aplicación o mediante las opciones de configuración de la app.</p>
    
    <h2>8. Contacto</h2>
    <p>Si tienes preguntas sobre esta política de privacidad, contáctanos en: [tu_email@ejemplo.com]</p>
    
    <h2>9. Cambios en esta Política</h2>
    <p>Podemos actualizar esta política de privacidad ocasionalmente. Te notificaremos de cualquier cambio significativo mediante una notificación en la aplicación.</p>
</body>
</html>
```

### 6.2 Términos de Servicio (Opcional pero recomendado)

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Términos de Servicio - El Impostor</title>
</head>
<body>
    <h1>Términos de Servicio - El Impostor</h1>
    
    <h2>1. Aceptación de Términos</h2>
    <p>Al usar esta aplicación, aceptas estos términos de servicio.</p>
    
    <h2>2. Uso Permitido</h2>
    <p>Puedes usar esta aplicación para fines personales y de entretenimiento. No está permitido:</p>
    <ul>
        <li>Usar la aplicación para fines ilegales</li>
        <li>Modificar o distribuir copias sin autorización</li>
    </ul>
    
    <h2>3. Propiedad Intelectual</h2>
    <p>Todo el contenido de la aplicación es propiedad de [Tu Nombre/Empresa].</p>
    
    <h2>4. Responsabilidad</h2>
    <p>La aplicación se proporciona "tal cual" sin garantías de ningún tipo.</p>
</body>
</html>
```

---

## 7. Proceso de Publicación

### 7.1 Pasos en Google Play Console

1. **Crear la aplicación**
   - Ve a https://play.google.com/console
   - Clic en "Crear app"
   - Ingresa el nombre: "El Impostor - Juego de Rol"
   - Selecciona "Juegos" como categoría
   - Completa la información básica

2. **Datos principales de la app**
   - Título: "El Impostor - Juego de Rol"
   - Descripción corta: (de la sección 5.3)
   - Descripción completa: (de la sección 5.4)
   - URL de política de privacidad: (paso 6.1)

3. **Información de la tienda**
   - Sube el icono (512x512)
   - Sube el feature graphic (1024x500)
   - Sube las capturas de pantalla (mínimo 2)
   - Añade las palabras clave

4. **Clasificación de contenido**
   - Completa el cuestionario de clasificación
   - Tu app probablemente será "Para todos" o "Adolescentes"

5. **Público objetivo**
   - Define tu público (jóvenes, adultos, etc.)

6. **Información de contacto**
   - Tu email de soporte
   - Dirección física (opcional)

7. **Lanzamiento en fase de pruebas (Opcional)**
   - Puedes hacer un lanzamiento cerrado primero
   - Añade emails de testers
   - Prueba la app con usuarios reales

8. **Producción**
   - Sube el AAB que generaste
   - Completa todos los formularios
   - Revisa toda la información
   - ¡Publica!

### 7.2 Tiempos de Aprobación

- **Revisión inicial**: 1-3 días hábiles
- **Actualizaciones**: 1-2 días hábiles
- **Rechazos**: Si hay problemas, te notificarán

### 7.3 Después de Publicar

- Monitorea los crashes en Firebase Crashlytics
- Responde a las reseñas de usuarios
- Actualiza la app según feedback
- Mantén las políticas de privacidad actualizadas

---

## 8. Checklist Final de Publicación

Antes de publicar, verifica:

- [ ] Keystore creado y guardado en lugar seguro
- [ ] key.properties configurado correctamente
- [ ] AAB generado con `flutter build appbundle --release`
- [ ] Iconos y gráficos preparados (tamaños correctos)
- [ ] Capturas de pantalla de alta calidad (mínimo 2)
- [ ] Descripción corta y completa preparadas
- [ ] Política de privacidad en línea (URL)
- [ ] Categoría correcta seleccionada (Juegos)
- [ ] Clasificación de contenido completada
- [ ] Permisos justificados y documentados
- [ ] Versión correcta (1.0.0+1)
- [ ] Toda la información en español
- [ ] Contacto de soporte configurado
- [ ] Datos de desarrollador completados

---

## 9. Recursos Útiles

- [Google Play Console](https://play.google.com/console)
- [Guía de preparación de Play Store](https://developer.android.com/guide/play-app-bundle/test)
- [Política de contenido de Google Play](https://play.google.com/developer/content-policy)
- [Firebase Crashlytics](https://firebase.google.com/docs/crashlytics)
- [Herramienta de diseño de iconos](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html)

---

## 10. Comandos Útiles

```bash
# Limpiar build
flutter clean

# Obtener dependencias
flutter pub get

# Probar en release
flutter run --release

# Generar APK (para pruebas manuales)
flutter build apk --release

# Generar AAB (para Play Store)
flutter build appbundle --release

# Verificar versión
flutter --version
```

---

## 11. Problemas Comunes y Soluciones

### Error: "Keystore file not found"
**Solución:** Verifica que `key.properties` apunte a la ruta correcta del archivo `.jks`

### Error: "key.properties not found"
**Solución:** El archivo debe estar en la carpeta `android/` del proyecto

### Error: "Password incorrect"
**Solución:** Verifica las contraseñas en `key.properties`. Si olvidaste la contraseña, no hay forma de recuperarla

### Warning: "MinSdk version too low"
**Solución:** Actualiza `minSdk` en `build.gradle.kts` a al menos 21

### Error: "Target SDK version must be updated"
**Solución:** Actualiza `targetSdk` a la versión más reciente disponible

---

## 12. Futuras Actualizaciones

Para actualizar la app en Play Store:

1. **Incrementar versión en `pubspec.yaml`:**
   ```
   version: 1.0.1+2  # Incrementa versionCode y versionName
   ```

2. **Generar nuevo AAB:**
   ```bash
   flutter build appbundle --release
   ```

3. **Subir a Play Console** como nuevo release

**IMPORTANTE:** Siempre usa el MISMO keystore. Si usas uno diferente, tendrás que publicar como una nueva app.

---

## 13. Tips de Éxito

- ✅ **Prueba exhaustivamente** antes de publicar
- ✅ **Lee las reseñas** de apps similares
- ✅ **Responde rápido** a los comentarios
- ✅ **Actualiza regularmente** con mejoras
- ✅ **Mantén las políticas** de privacidad actualizadas
- ✅ **Usa analytics** (opcional) para entender el comportamiento
- ✅ **Prepara marketing** antes del lanzamiento
- ✅ **Pide feedback** a amigos y familia

---

## 14. Soporte

Si tienes problemas durante el proceso:

1. Revisa esta guía completa
2. Consulta la documentación oficial de Google Play
3. Busca en Stack Overflow
4. Verifica los logs de Flutter: `flutter doctor`

---

**¡Mucha suerte con tu publicación en Play Store! 🚀**

Si sigues esta guía paso a paso, tendrás tu aplicación publicada sin problemas. Recuerda que lo más importante es tener bien guardado el keystore y cumplir con las políticas de Google Play.