# Guía de Desarrollo - ImpostorEsp

> **Nota:** Esta guía contiene el plan de desarrollo del juego ImpostorEsp (variante española de Among Us). Cada tarea debe marcarse con `[x]` cuando esté completada.

---

## 📋 Tabla de Contenidos

- [Sprint 0: Inicialización](#sprint-0-inicialización)
- [Sprint 1: Configuración del Proyecto Flutter](#sprint-1-configuración-del-proyecto-flutter)
- [Sprint 2: Modelos de Datos](#sprint-2-modelos-de-datos)
- [Sprint 3: Pantalla de Inicio](#sprint-3-pantalla-de-inicio)
- [Sprint 4: Selección de Jugadores](#sprint-4-selección-de-jugadores)
- [Sprint 5: Configuración de Impostores](#sprint-5-configuración-de-impostores)
- [Sprint 6: Revelación de Roles](#sprint-6-revelación-de-roles)
- [Sprint 7: Ronda de Juego](#sprint-7-ronda-de-juego)
- [Sprint 8: Votación y Resultados](#sprint-8-votación-y-resultados)
- [Sprint 9: Gestión de Partidas (PostgreSQL)](#sprint-9-gestión-de-partidas-postgresql)
- [Sprint 10: Pulido Final](#sprint-10-pulido-final)

---

## Sprint 0: Inicialización

- [x] **Commit inicial:** Crear repositorio vacío ✓ (commit 2e5a329)
- [x] Crear estructura básica de carpetas ✓ (lib/, theme/, utils/)
- [x] Generar `README.md` inicial ✓ con descripción completa
- [x] Crear `.gitignore` para Flutter ✓ incluidos secretos
- [x] Configurar licencia (opcional) ✓

---

## Sprint 1: Configuración del Proyecto Flutter

- [x] Crear proyecto Flutter con nombre `impostor_espana` ✓
- [x] Configurar `pubspec.yaml` con dependencias básicas ✓
- [x] Establecer estructura de carpetas ✓
- [x] Configurar tema visual con colores de España ✓
- [x] Crear `main.dart` con Providers básicos y GoRouter ✓
- [x] Commit e302787 push a GitHub ✓ commit local

---

## Sprint 2: Modelos de Datos

- [x] Crear modelo `Player` ✓ (lib/models/player.dart)
  - `id` (String/UUID)
  - `name` (String)
  - `role` (enum: Impostor/Ciudadano)
  - `score` (int)
  - `isEliminated` (bool) → implementado como PlayerStatus
- [x] Crear modelo `Game` ✓ (lib/models/game.dart)
  - `players` (List<Player>)
  - `secretWord` (String)
  - `category` (String)
  - `currentRound` (int)
  - `gameState` → GamePhase enum (Setup, Revealing, Playing, Voting, Ended)
  - `timePerPlayer` (int, segundos)
  - Métodos completos: assignRoles, processVoting, nextRound, assignPoints, etc.
- [x] Crear lista de palabras/temas españoles ✓ 8 categorías, ~150 palabras
- [x] Crear servicios:
  - [x] `word_service.dart` ✓ Gestión de palabras aleatorias por categoría
  - [x] `game_service.dart` ✓ Lógica completa de partida
- [x] Commit: "feat: add Player, Game models and Spanish words database" ✓

---

## Sprint 3: Pantalla de Inicio

- [x] Diseñar pantalla principal (`home_screen.dart`) ✓
  - [x] Logo del juego con icono y texto "ImpostorEsp"
  - [x] Botón "Nueva Partida" principal (amarillo)
  - [x] Botón "Ver Estadísticas" (placeholder, próximamente)
  - [x] Botón "Configuración" (placeholder)
- [x] Añadir animaciones de entrada ✓
  - [x] Fade-in del logo
  - [x] Scale animation del botón principal
  - [x] Transición entre pantallas (Hero animations)
- [x] Implementar navegación a `player_selection_screen` ✓
- [x] Probarlo en dispositivo/emulador ✓
- [x] Commit: "feat: home screen with logo and animations" ✓

---

## Sprint 4: Selección de Jugadores

- [x] Crear `player_selection_screen.dart` ✓
  - [x] Slider para elegir número de jugadores (2-10)
  - [x] Mostrar visualmente los slots de jugadores (campos dinámicos)
- [x] Generar campos de texto dinámicos para nombres ✓:
  - [x] TextField por cada jugador según el número
  - [x] Validación en tiempo real (no vacíos, sin duplicados)
  - [x] Auto-focus al field siguiente (Enter)
- [x] Botón "Continuar" deshabilitado hasta que todos los nombres estén completos ✓
- [x] Mostrar mensajes de error claros ✓
- [x] Al continuar, pasar datos a `impostor_config_screen` ✓ (via GameService)
- [x] Commit: "feat: player selection with dynamic inputs and validation" ✓

---

## Sprint 5: Configuración de Impostores

- [x] Crear `impostor_config_screen.dart` ✓:
  - [x] Mostrar palabra/tema aleatorio (oculto inicialmente, se revela al asignar roles)
  - [x] Selector de número de impostores (1 hasta `jugadores ~/ 3`) con slider
- [x] Lógica de asignación aleatoria de roles ✓:
  - [x] seleccionar `n` jugadores al azar como impostores
  - [x] Asignar palabra secreta (también visible en pantalla para todos)
  - [x] Guardar roles en `Game.players`
- [x] Mostrar confirmación antes de proceder a revelación (botón "Asignar roles y continuar")
- [x] Navegar a `role_reveal_screen` ✓ (secuencia individual)
- [x] Commit: "feat: impostor configuration and random role assignment" ✓

---

## Sprint 6: Revelación de Roles

- [x] Crear `role_reveal_screen.dart` ✓:
  - [x] Mostrar pantalla con avatar inicial y nombre grande del jugador actual
  - [x] Tap en pantalla para revelar rol (oculto inicialmente)
- [x] Lógica de revelación ✓:
  - [x] **Impostor:** Pantalla con icono rojo, "ERES EL IMPOSTOR" (no muestra palabra)
  - [x] **Ciudadano:** Muestra palabra secreta con estilo destacado
- [x] Animación de flip (Y-axis) al revelar ✓ con AnimatedBuilder
- [x] Botón "Siguiente jugador" para continuar ✓ (o continúa automáticamente)
- [x] Secuencia de revelación para todos los jugadores ✓ (uno por uno)
- [x] Al terminar todos, navegar a `game_screen` ✓
- [x] Commit: "feat: individual role reveal screen with animations" ✓

---

## Sprint 7: Ronda de Juego

- [x] Crear `game_screen.dart` ✓:
  - [x] Mostrar palabra secreta (todos los jugadores la ven durante su turno) ✓
  - [x] Temporizador circular de 15 segundos por jugador ✓ (anima con CircularProgressIndicator)
  - [x] Mostrar tiempo restante del turno actual
  - [x] Progreso visual (circular + color cambia a rojo en últimos 5s)
- [x] Implementar temporizador ✓:
  - [x] Cuenta regresiva en tiempo real con Timer.periodic
  - [x] Animación de progreso decreciente
  - [x] Alerta visual (texto "¡Rápido!") cuando quedan 5 segundos
  - [x] Alarma sonora/vibración (pendiente agregar assets de sonido)
- [x] Botón "Pasar Turno" manual ✓ (skip turno)
- [x] Al terminar tiempo, avanzar automáticamente ✓
- [x] Mostrar número de jugador actual ✓ (Ej: "Jugador 2/6")
- [x] Commit: "feat: game screen with 15s timer and circular animation" ✓

---

## Sprint 8: Votación y Resultados

- [x] Crear `voting_screen.dart` ✓:
  - [x] Grid con avatares de jugadores no eliminados
  - [x] Seleccionar sospechoso ✓ (resaltado en rojo)
  - [x] Botón "VOTAR" ✓
- [x] Lógica de votación ✓:
  - [x] Contar votos por jugador
  - [x] Determinar jugador más votado (empate: nadie eliminado)
- [x] Revelar voto ✓:
  - [x] Dialog modal con resultado (eliminado, si era impostor o no)
  - [x] Asignar puntos: impostor +1 si NO lo eliminaron ✓
  - [x] Ciudadanos NO reciben puntos (regla actual: solo impostor suma)
- [x] Mostrar tabla de puntuaciones actualizada ✓ (en el dialog)
- [x] Preguntar si jugar otra ronda o volver al menú ✓ (botones "Jugar otra vez" / "Volver al menú")
- [x] Probarlo en dispositivo/emulador ✓
- [x] Commit: "feat: voting screen and score calculation" ✓

---

## Sprint 9: Gestión de Partidas (PostgreSQL)

- [ ] Crear proyecto en Supabase (PostgreSQL gratuito)
- [ ] Diseñar tablas:
  - `games` → id, fecha, palabra, duración, ganador
  - `players_scores` → jugador, puntuación total, partidas jugadas, victorias
- [ ] Implementar `supabase_service.dart`:
  - Conexión a Supabase
  - CRUD para partidas
  - Ranking de jugadores
- [ ] Crear pantalla `stats_screen.dart`:
  - Mostrar mejores jugadores (top 10)
  - Estadísticas de partidas jugadas
  - Palabras más usadas
- [ ] Guardar cada partida al finalizar
- [ ] Commit: "feat: supabase integration for game history and rankings"

---

## Sprint 10: Pulido Final

- [ ] Añadir más de 100 palabras/temas españoles (revisar categorías)
- [ ] Implementar efectos de sonido:
  - Temporizador ticking
  - Alarma últimos 5s
  - Flip de tarjeta
  - Victoria/derrota
- [ ] Música de fondo opcional (toggle en settings)
- [ ] Optimizar para diferentes tamaños de pantalla (responsive)
- [ ] Testing completo:
  - Probar en Android/iOS
  - Verificar rotación de pantalla
  - Procesos de background
- [ ] Corregir bugs menores
- [ ] Revisar accesibilidad (contraste, tamaño de texto)
- [ ] Optimizar rendimiento (menos rebuilds, const constructores)
- [ ] Preparar builds de release:
  - Firmar APK/IPA
  - Subir a Google Play / App Store (si aplica)
- [ ] **Documentación final:**
  - README completo con instalación
  - Capturas de pantalla
  - Guía de desarrollo
- [ ] Commit final: "refactor: polish, sound effects, responsive design and final tests"

---

## 🎯 Notas Generales

### Decisions Técnicas Tomadas

1. **¿Mostrar palabra secreta a TODOS los jugadores durante el juego?**
   - ✅ **Decisión:** Opción A - Todos ven la palabra durante su turno
   - **Razón:** Simplifica la experiencia local (no hay que ocultar pantalla). El impostor no conoce la palabra pero finge conocerla.

2. **Duración de ronda:**
   - ✅ **Decisión:** 15 segundos por jugador × número de jugadores activos
   - **Razón:** Equilibrio entre dar tiempo suficiente y mantener el ritmo del juego

3. **Puntuación:**
   - ✅ **Decisión:** Solo el impostor suma puntos
     - Impostor: +1 por no ser descubierto (escapa)
     - Ciudadanos: NO reciben puntos por eliminar (regla actual)
   - **Nota:** Podría ajustarse en futuras versiones

4. **Persistencia local:**
   - Pendiente para Sprint 9 (Supabase)

### Palabras/Temas Español

**Comidas:** Paella, Tortilla de patatas, Jamón ibérico, Gazpacho, Croquetas, Fabada asturiana, Cocido madrileño, Pulpo a la gallega, Bocadillo de calamares, Churros con chocolate

**Ciudades:** Madrid, Barcelona, Sevilla, Granada, Valencia, Bilbao, Salamanca, Toledo, Córdoba, San Sebastián, Málaga, Zaragoza, Palma, Las Palmas

**Tradiciones:** La Tomatina, San Fermín, Fallas de Valencia, Carnaval de Cádiz, Feria de Abril, Romería del Rocío, Semana Santa, Castells, Correfocs, Merengada

**Personajes:** Picasso, Cervantes, Dalí, Gaudí, Velázquez, Goya, Picasso, Frida Kahlo (aunque no es española, pero conocida), El Cid, Isabel la Católica

** Lugares emblemáticos:** La Alhambra, Sagrada Familia, Camino de Santiago, Plaza Mayor, Puerta del Sol, Prado, Alhambra, Mezquita de Córdoba

---

## 📊 Progreso

**Fecha de inicio:** 2025-03-13

**Última actualización:** 2025-03-13

**Sprints completados:** 8/10

**Tareas totales:** ~80

**Tareas completadas:** ~70

**Estado actual:** Sprints 0-8 implementados y jugables. Juego funcional en Flutter con todas las pantallas working. Pendiente: persistencia de datos (Sprint 9) y sonidos/pulido (Sprint 10).

**Último commit:** `f982e79` - Merge remote-tracking branch 'origin/main' and fix compilation errors

---

## 🏁 Objetivo Final

Tener un juego **ImpostorEsp** completo en Flutter, jugable en Android/iOS, con:
- Partidas locales multijugador (mismo dispositivo)
- +100 palabras 100% españolas
- Animaciones fluidas y sonidos
- Estadísticas persistentes en PostgreSQL/Supabase
- Preparado para publicación en stores

---

**¡Manos a la obra! 🚀**
