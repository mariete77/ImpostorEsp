# Instrucciones para Android Studio

## 📱 Abrir el proyecto en Android Studio

### Opción 1: Desde Flutter (Recomendado)
```bash
flutter build apk --debug
```
Después ejecuta:
```bash
flutter open -a
```
Esto abrirá automáticamente el proyecto en Android Studio.

### Opción 2: Manual
1. Abre Android Studio
2. Ve a **File** → **Open**
3. Navega a: `D:\Repos\ImpostorEspV2`
4. Selecciona la carpeta y haz clic en **OK**

## 🔧 Configuración del proyecto en Android Studio

### Verificar Gradle
Android Studio descargará automáticamente las dependencias de Gradle cuando abras el proyecto.

### Ejecutar la app desde Android Studio
1. Conecta un dispositivo Android o abre un emulador
2. Selecciona el dispositivo en el menú desplegable de dispositivos
3. Haz clic en el botón **Run** (▶️) verde o presiona `Shift + F10`

## 📦 Generar APK para compartir

### APK Debug (Para pruebas)
```bash
flutter build apk --debug
```
El APK se guardará en: `build\app\outputs\flutter-apk\app-debug.apk`

### APK Release (Para distribución)
```bash
flutter build apk --release
```
El APK se guardará en: `build\app\outputs\flutter-apk\app-release.apk`

### App Bundle (Para Google Play Store)
```bash
flutter build appbundle --release
```
El AAB se guardará en: `build\app\outputs\bundle\release\app-release.aab`

## 🎯 Configuración actual del proyecto

| Propiedad | Valor |
|-----------|-------|
| **Package Name** | `com.impostoresp.impostor_espana` |
| **Nombre de la app** | El Impostor |
| **Versión** | 1.0.0 (build 1) |
| **minSdk** | 21 (Android 5.0+) |
| **targetSdk** | 34 (Android 14) |
| **compileSdk** | 34 |

## 🔒 Firmar el APK Release (Para distribución)

Para crear un APK firmado para la Play Store:

1. **Generar keystore** (una sola vez):
   ```bash
   keytool -genkey -v -keystore ~/impostor_espana.jks -keyalg RSA -keysize 2048 -validity 10000 -alias impostor_espana
   ```

2. **Crear archivo `key.properties`** en `android/`:
   ```properties
   storePassword=your_password
   keyPassword=your_key_password
   keyAlias=impostor_espana
   storeFile=path/to/impostor_espana.jks
   ```

3. **Actualizar `android/app/build.gradle.kts`** con la configuración de firma

4. **Generar APK firmado**:
   ```bash
   flutter build apk --release
   ```

## 🎨 Personalización

### Cambiar el icono de la app
Los iconos actuales son los por defecto de Flutter. Para cambiarlos:

1. Usa una herramienta como [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons)
2. Instala el paquete: `flutter pub get`
3. Configura en `pubspec.yaml`:
   ```yaml
   flutter_launcher_icons:
     android: "ic_launcher"
     image_path: "assets/icon/app_icon.png"
   ```
4. Ejecuta: `flutter pub run flutter_launcher_icons`

### Cambiar el nombre de la app
Edita: `android/app/src/main/res/values/strings.xml`
```xml
<string name="app_name">Tu Nombre Aquí</string>
```

## 🐛 Solución de problemas comunes

### Error: "Dependency requires at least JVM runtime version 11"
El proyecto necesita Java 11 o superior. Solución:

**Opción 1: Configurar JAVA_HOME**
```bash
# Verificar versiones instaladas
java -version

# Si tienes Java 11+ instalado, configurar JAVA_HOME
set JAVA_HOME=C:\Program Files\Java\jdk-17

# Verificar
echo %JAVA_HOME%
```

**Opción 2: Actualizar gradle.properties**
Edita `android/gradle.properties` y agrega:
```properties
org.gradle.java.home=C:\\Program Files\\Java\\jdk-17
```

**Opción 3: Desde Android Studio**
1. File → Settings → Build, Execution, Deployment → Build Tools → Gradle
2. En "Gradle JDK", selecciona Java 11 o superior
3. Aplica los cambios y sincroniza

### Gradle sync falla
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Error de dependencias
```bash
flutter pub cache repair
flutter pub get
```

### Emulador no aparece
- Asegúrate de tener Android SDK instalado
- Crea un emulador desde AVD Manager en Android Studio
- O usa un dispositivo físico con USB debugging habilitado

## 📱 Características de la app implementadas

✅ Sistema de selección de jugadores (2-10)
✅ Configuración de impostores con recomendación visual
✅ Asignación de roles y palabra secreta
✅ Revelación de roles uno por uno
✅ Ronda de juego con temporizador
✅ Sistema de votación
✅ Pantalla de resultados
✅ Música de fondo con control de volumen
✅ Tema oscuro con efectos de neón
✅ Interfaz en español

## 🚀 Próximos pasos recomendados

1. **Probar la app** en diferentes dispositivos Android
2. **Crear icono personalizado** para la app
3. **Generar APK firmado** para pruebas beta
4. **Configurar Analytics** (opcional)
5. **Preparar para Play Store**:
   - Capturas de pantalla
   - Descripción en español
   - Política de privacidad
   - Clasificación de contenido

## 📞 Recursos útiles

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Android Studio Guide](https://developer.android.com/studio)
- [Google Play Console](https://play.google.com/console)