@echo off
echo Abriendo el proyecto en Android Studio...
echo.

REM Buscar Android Studio en rutas comunes
set ANDROID_STUDIO_PATH="C:\Program Files\Android\Android Studio\bin\studio64.exe"

IF EXIST %ANDROID_STUDIO_PATH% (
    start "" %ANDROID_STUDIO_PATH% "D:\Repos\ImpostorEspV2"
    echo.
    echo ✓ Android Studio se está abriendo...
    echo.
    echo Si no se abre, abrelo manualmente:
    echo 1. File ^> Open
    echo 2. Navega a: D:\Repos\ImpostorEspV2
    echo 3. Haz clic en OK
) ELSE (
    echo.
    echo ✗ No se encontró Android Studio en la ruta por defecto.
    echo.
    echo Instrucciones manuales:
    echo 1. Abre Android Studio
    echo 2. Ve a File ^> Open
    echo 3. Navega a: D:\Repos\ImpostorEspV2
    echo 4. Haz clic en OK
    echo.
    echo O verifica donde está instalado Android Studio y actualiza este script.
)

pause