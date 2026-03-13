# 🎭 ImpostorEsp

> Juego de detectives social al estilo Among Us, pero con sabor español.

## 📖 Descripción

ImpostorEsp es una adaptación del clásico juego de的风格 Among Us, diseñado para jugarse en un mismo dispositivo. Los jugadores deben discovers quién entre ellos es el impostor, con temas, palabras y situaciones 100% españolas.

## 🎯 Características principales

- **Multijugador local:** 2-10 jugadores en un solo dispositivo
- **Temática española:** Palabras relacionadas con comida, ciudades, tradiciones y personajes famosos de España
- **Modo revelación individual:** Cada jugador conoce su rol en secreto
- **Sistema de votación:** Decide quién es el impostor
- **Puntuación:** Gana el impostor si no lo descubren, ganan los ciudadanos si lo eliminan
- **Estadísticas persistentes:** Guarda tu historial de partidas (PostgreSQL/Supabase)

## 🚀 Empezar

### Requisitos

- Flutter SDK 3.9 o superior
- Dart 3.9 o superior
- Dispositivo/emulador Android o iOS

### Instalación

```bash
# Clonar el repositorio
git clone https://github.com/mariete77/ImpostorEsp.git
cd ImpostorEsp

# Instalar dependencias
flutter pub get

# Ejecutar en emulador/dispositivo
flutter run
```

### Desarrollo

```bash
# Generar archivos (si usamos codegen en el futuro)
flutter pub run build_runner build

# Analizar código
flutter analyze

# Tests
flutter test
```

## 📁 Estructura del proyecto

```
lib/
├── main.dart                 # Punto de entrada
├── theme/                    # Configuración visual (colores España)
│   └── app_theme.dart
├── models/                   # Modelos de datos
│   ├── player.dart
│   └── game.dart
├── screens/                  # Pantallas de la app
│   ├── home_screen.dart
│   ├── player_selection_screen.dart
│   ├── impostor_config_screen.dart
│   ├── role_reveal_screen.dart
│   ├── game_screen.dart
│   ├── voting_screen.dart
│   └── stats_screen.dart
├── services/                 # Lógica de negocio
│   ├── game_service.dart
│   ├── word_service.dart    # Base de palabras españolas
│   └── supabase_service.dart # Persistencia (fase 9)
└── widgets/                 # Componentes reutilizables
    ├── custom_button.dart
    ├── timer_widget.dart
    └── ...
```

## 🎮 Cómo jugar

1. **Configurar partida:**
   - Elegir número de jugadores (2-10)
   - Introducir nombres
   - Seleccionar número de impostores (1 aprox. 1 cada 3 jugadores)

2. **Revelación de roles:**
   - Cada jugador, uno a uno, mira la pantalla para ver su rol
   - **Impostor:** Ve "ERES EL IMPOSTOR" (no conoce la palabra)
   - **Ciudadano:** Ve la palabra secreta

3. **Ronda de juego:**
   - Cada jugador tiene ~15 segundos para "adivinar" o hacer preguntas
   - Todos ven la palabra secreta (excepto el impostor que debe fingir)
   - Al terminar el tiempo, se pasa al siguiente jugador

4. **Votación:**
   - Todos votan por quién creen que es el impostor
   - Se revela el voto
   - Si se eliminó al impostor → ganan ciudadanos
   - Si no → gana el impostor

5. **Puntuación:**
   - Impostor: +1 punto por cada ronda que no lo descubran
   - Ciudadanos: +1 punto por cada impostor eliminado

## 🎨 Palabras temáticas

El juego incluye más de 100 palabras españolas organizadas en categorías:

- **🍽️ Comidas:** Paella, Tortilla, Jamón ibérico, Gazpacho...
- **🏛️ Ciudades:** Madrid, Barcelona, Sevilla, Granada...
- **🎉 Tradiciones:** La Tomatina, San Fermín, Fallas, Carnaval...
- **👤 Personajes:** Picasso, Cervantes, Dalí, Gaudí...

## 🛠️ Stack tecnológico

- **Framework:** Flutter 3.9+
- **Lenguaje:** Dart 3.9+
- **State Management:** Provider
- **Navegación:** GoRouter
- **Tipografía:** Google Fonts
- **Base de datos:** PostgreSQL (Supabase) - *pendiente de implementación*
- **Autenticación:** Ninguna (local multiplayer)

## 📝 Roadmap

Ver [guia.md](guia.md) para el plan completo de desarrollo con 10 sprints.

**Sprints:**
1. ✅ Configuración del proyecto Flutter
2. ⏳ Modelos de datos y base de palabras
3. ⏳ Pantalla de inicio
4. ⏳ Selección de jugadores
5. ⏳ Configuración de impostores
6. ⏳ Revelación de roles
7. ⏳ Ronda de juego
8. ⏳ Votación y resultados
9. ⏳ Gestión de partidas (PostgreSQL)
10. ⏳ Pulido final

## 🤝 Contribuir

Este es un proyecto personal/educativo. Si tienes sugerencias:

1. Haz fork del repositorio
2. Crea una rama con tu feature
3. Commit y push
4. Abre un Pull Request

## 📄 Licencia

MIT - Siéntete libre de usar y modificar como quieras.

---

**¡A divertirse!** 🎉
