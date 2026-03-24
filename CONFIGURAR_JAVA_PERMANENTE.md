# 🔧 CONFIGURAR JAVA 17 PERMANENTEMENTE

## RUTA DE JAVA 17 ENCONTRADA

Java 17 está instalado en:
```
C:\Program Files (x86)\Android\openjdk\jdk-17.0.14
```

## CONFIGURACIÓN PERMANENTE (RECOMENDADO)

Para que Java 17 se use siempre sin tener que configurarlo cada vez:

### PASO 1: Configurar JAVA_HOME

1. Presiona `Win + R`
2. Escribe: `sysdm.cpl` y presiona Enter
3. Ve a la pestaña **"Avanzado"**
4. Haz clic en **"Variables de entorno"**
5. En **"Variables del sistema"**, haz clic en **"Nuevo..."**
6. Ingresa:
   - **Nombre de variable:** `JAVA_HOME`
   - **Valor de variable:** `C:\Program Files (x86)\Android\openjdk\jdk-17.0.14`
7. Haz clic en **"Aceptar"**

### PASO 2: Actualizar el PATH

1. En la misma ventana de Variables de entorno
2. En **"Variables del sistema"**, encuentra la variable **"Path"**
3. Selecciónala y haz clic en **"Editar..."**
4. Haz clic en **"Nuevo"**
5. Añade: `%JAVA_HOME%\bin`
6. **IMPORTANTE:** Si hay otras entradas de Java en el Path, muévalas después de `%JAVA_HOME%\bin` usando las flechas
7. Haz clic en **"Aceptar"** en todas las ventanas

### PASO 3: Verificar

1. **Cierra TODAS las ventanas de terminal**
2. Abre una NUEVA terminal
3. Ejecuta:
```powershell
java -version
```

Debería mostrar:
```
openjdk version "17.0.14" 2025-01-21 LTS
```

### PASO 4: Verificar JAVA_HOME

```powershell
echo $env:JAVA_HOME
```

Debería mostrar:
```
C:\Program Files (x86)\Android\openjdk\jdk-17.0.14
```

## CONFIGURACIÓN TEMPORAL (SOLO SESIÓN ACTUAL)

Si solo quieres usarlo en esta sesión (sin configurar permanentemente):

```powershell
$env:JAVA_HOME = "C:\Program Files (x86)\Android\openjdk\jdk-17.0.14"
$env:PATH = "$env:JAVA_HOME\bin;" + $env:PATH
```

**Nota:** Tendrás que ejecutar esto cada vez que abras una nueva terminal.

## POR QUÉ CONFIGURAR JAVA 17 PERMANENTEMENTE

✅ Siempre usará la versión correcta de Java
✅ No tendrás que configurarlo cada vez que compiles
✅ Flutter y Android Studio detectarán automáticamente Java 17
✅ Evitarás conflictos con versiones antiguas de Java

## VERIFICACIÓN FINAL DE FLUTTER

Después de configurar, ejecuta:

```powershell
flutter doctor
```

Debería mostrar:
- ✓ Android toolchain - desarrollado para Android (version xx.xx.xx)
- ✓ Java version at C:\Program Files (x86)\Android\openjdk\jdk-17.0.14

## GENERAR AAB

Una vez configurado Java 17, genera el AAB:

```powershell
cd D:\Repos\ImpostorEspV2
flutter clean
flutter pub get
flutter build appbundle --release
```

El archivo estará en: `build\app\outputs\bundle\release\app-release.aab`

---

**¿Ya configuraste JAVA_HOME permanentemente?**