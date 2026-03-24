@echo off
echo ========================================
echo VERIFICANDO AAB GENERADO
echo ========================================
echo.

if exist "build\app\outputs\bundle\release\app-release.aab" (
    echo ✅ AAB GENERADO EXITOSAMENTE!
    echo.
    echo 📍 Ubicación: build\app\outputs\bundle\release\app-release.aab
    echo.
    
    for %%I in ("build\app\outputs\bundle\release\app-release.aab") do (
        echo 📦 Tamaño: %%~zI bytes
    )
    echo.
    echo 🎉 ¡Listo para subir a Play Store!
    echo.
    echo ========================================
    echo PASOS SIGUIENTES:
    echo ========================================
    echo.
    echo 1. Configurar Java 17 permanentemente:
    echo    - Abre CONFIGURAR_JAVA_PERMANENTE.md
    echo.
    echo 2. Preparar recursos gráficos:
    echo    - Icono (512x512 px)
    echo    - Feature graphic (1024x500 px)
    echo    - Capturas de pantalla (mínimo 2)
    echo.
    echo 3. Subir política de privacidad:
    echo    - Archivo: privacy_policy.html
    echo    - Hospédalo en GitHub Pages, Netlify o tu web
    echo.
    echo 4. Crear cuenta en Play Console:
    echo    - Ve a: https://play.google.com/console
    echo    - Paga $25 USD
    echo.
    echo 5. Completar información en Play Console:
    echo    - Sube el AAB
    echo    - Completa descripciones
    echo    - Sube recursos gráficos
    echo    - Envia para revisión
    echo.
    echo ========================================
    echo DOCUMENTACIÓN DISPONIBLE:
    echo ========================================
    echo.
    echo - RESUMEN_FINAL.md (Resumen completo)
    echo - GUIA_PUBLICACION_PLAY_STORE.md (Guía detallada)
    echo - PASOS_PUBLICACION.txt (Pasos paso a paso)
    echo - CONFIGURAR_JAVA_PERMANENTE.md (Configurar Java 17)
    echo.
    echo ========================================
    echo ⚠️ ADVERTENCIAS CRÍTICAS:
    echo ========================================
    echo.
    echo 1. GUARDA EL KEYSTORE:
    echo    - android\keystore.jks
    echo    - android\key.properties
    echo    - Las contraseñas
    echo.
    echo 2. HAZ COPIAS DE SEGURIDAD:
    echo    - USB externo
    echo    - Nube encriptada
    echo    - Múltiples ubicaciones
    echo.
    echo 3. NUNCA SUBAS A GIT:
    echo    - keystore.jks
    echo    - key.properties
    echo.
    echo 4. USA EL MISMO KEYSTORE:
    echo    - Para futuras actualizaciones
    echo    - Para corregir bugs
    echo.
    echo ========================================
    echo.
    pause
) else (
    echo ❌ AAB NO ENCONTRADO
    echo.
    echo El build aún está en progreso o falló.
    echo.
    echo Para verificar el estado del build:
    echo 1. Abre otra terminal
    echo 2. Ejecuta: flutter build appbundle --release
    echo.
    echo Tiempo estimado de compilación: 5-15 minutos
    echo.
    pause
)