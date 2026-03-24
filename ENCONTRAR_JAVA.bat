@echo off
echo ========================================
echo BUSCANDO INSTALACIONES DE JAVA
echo ========================================
echo.

echo [1] Buscando en C:\Program Files\Java...
if exist "C:\Program Files\Java" (
    dir "C:\Program Files\Java" /B /A:D
) else (
    echo    No encontrado
)
echo.

echo [2] Buscando en C:\Program Files\Eclipse Adoptium...
if exist "C:\Program Files\Eclipse Adoptium" (
    dir "C:\Program Files\Eclipse Adoptium" /B /A:D
) else (
    echo    No encontrado
)
echo.

echo [3] Buscando en C:\Program Files (x86)\Java...
if exist "C:\Program Files (x86)\Java" (
    dir "C:\Program Files (x86)\Java" /B /A:D
) else (
    echo    No encontrado
)
echo.

echo [4] Buscando archivos java.exe en C:\Program Files...
where /R "C:\Program Files" java.exe 2>nul
echo.

echo [5] Buscando archivos java.exe en C:\Program Files (x86)...
where /R "C:\Program Files (x86)" java.exe 2>nul
echo.

echo [6] Buscando archivos java.exe en C:\Users\%USERNAME%...
where /R "C:\Users\%USERNAME%" java.exe 2>nul
echo.

echo ========================================
echo INSTRUCCIONES:
echo ========================================
echo.
echo Si encuentras carpetas con "17" o "jdk-17", copia la ruta completa.
echo Ejemplo: C:\Program Files\Eclipse Adoptium\jdk-17.0.12.7-hotspot
echo.
echo Si NO encuentras Java 17, necesitas instalarlo:
echo 1. Ve a: https://adoptium.net/temurin/releases/?version=17
echo 2. Descarga JDK 17 para Windows x64
echo 3. Ejecuta el instalador
echo.
echo ========================================
echo.
pause