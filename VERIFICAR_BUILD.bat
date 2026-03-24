@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║       📦 VERIFICAR BUILD GENERADO - Impostor España 📦           ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

set aab_found=0
set apk_found=0

:: Verificar AAB
if exist "build\app\outputs\bundle\release\app-release.aab" (
    set aab_found=1
    echo ╔════════════════════════════════════════════════════════════════╗
    echo ║              ✅ AAB GENERADO EXITOSAMENTE!                      ║
    echo ╚════════════════════════════════════════════════════════════════╝
    echo.
    echo 📍 Ubicación:
    echo    build\app\outputs\bundle\release\app-release.aab
    echo.
    echo 📦 Tamaño:
    for %%A in ("build\app\outputs\bundle\release\app-release.aab") do (
        set /a size_mb=%%~zA/1048576
        echo    !size_mb! MB
    )
    echo.
    echo ⭐ RECOMENDADO PARA PLAY STORE
    echo.
) else (
    echo ╔════════════════════════════════════════════════════════════════╗
    echo ║                   ❌ AAB NO GENERADO                             ║
    echo ╚════════════════════════════════════════════════════════════════╝
    echo.
    echo 📍 Ubicación esperada:
    echo    build\app\outputs\bundle\release\app-release.aab
    echo.
    echo 💡 Para generar el AAB desde Android Studio:
    echo    Consulta GENERAR_AAB_ANDROID_STUDIO.md
    echo.
)

:: Verificar APK
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    set apk_found=1
    echo ╔════════════════════════════════════════════════════════════════╗
    echo ║              ✅ APK GENERADO EXITOSAMENTE!                      ║
    echo ╚════════════════════════════════════════════════════════════════╝
    echo.
    echo 📍 Ubicación:
    echo    build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo 📦 Tamaño:
    for %%A in ("build\app\outputs\flutter-apk\app-release.apk") do (
        set /a size_mb=%%~zA/1048576
        echo    !size_mb! MB
    )
    echo.
    echo ℹ️  El APK también se puede subir a Play Store
    echo    (pero AAB es más recomendado)
    echo.
) else (
    echo ╔════════════════════════════════════════════════════════════════╗
    echo ║                   ❌ APK NO GENERADO                             ║
    echo ╚════════════════════════════════════════════════════════════════╝
    echo.
    echo 💡 Para generar el APK, ejecuta:
    echo    flutter build apk --release
    echo.
)

:: Resumen final
echo ══════════════════════════════════════════════════════════════════
echo 📊 RESUMEN:
echo.
if %aab_found%==1 (
    echo    ✅ AAB disponible para subir a Play Store
)
if %apk_found%==1 (
    echo    ✅ APK disponible para pruebas o Play Store
)
if %aab_found%==0 (
    if %apk_found%==0 (
        echo    ❌ No hay builds generados
    )
)
echo.

:: Recomendación
if %aab_found%==1 (
    echo ⭐ RECOMENDACIÓN:
    echo    Sube el AAB a Play Store para mejores resultados
    echo.
    echo 📖 Instrucciones:
    echo    - Consulta GUIA_PUBLICACION_PLAY_STORE.md
    echo    - Sube: build\app\outputs\bundle\release\app-release.aab
    echo.
) else if %apk_found%==1 (
    echo ⭐ RECOMENDACIÓN:
    echo    Sube el APK a Play Store o genera un AAB desde Android Studio
    echo.
    echo 📖 Para generar AAB:
    echo    - Consulta GENERAR_AAB_ANDROID_STUDIO.md
    echo    - O usa el APK actual
    echo.
)

:: Recordatorio crítico
echo ╔════════════════════════════════════════════════════════════════╗
echo ║           ⚠️  NO OLVIDES GUARDAR EL KEYSTORE! ⚠️                  ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.
echo Archivos críticos:
echo    - android\keystore.jks
echo    - android\key.properties
echo.
echo Sin estos NO podrás actualizar la app en el futuro!
echo.

pause
exit /b