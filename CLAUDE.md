# Discovery Colony - Claude Code Context

## Project Overview

A Banished-style survival city-builder set in the Age of Discovery (1500s-1600s). Players lead colonists arriving by ship, balancing survival, trade, and relationships with native peoples and the Crown. Explores colonialism with historical authenticity—no sanitizing, no moralizing, just consequences.

## Tech Stack

- **Engine:** Godot 4.6
- **Language:** GDScript
- **Platforms:** macOS/Linux primary, Windows secondary

## Project Structure

```
roxbury/
├── docs/
│   └── GAME_DESIGN.md      # Full design doc (read this for game design questions)
├── game/                    # Godot project root
│   ├── project.godot
│   ├── scenes/
│   │   └── main.tscn        # Main game scene
│   ├── scripts/
│   │   ├── main.gd          # Main scene controller
│   │   ├── camera_controller.gd
│   │   ├── autoload/        # Singletons (auto-loaded)
│   │   │   ├── game_manager.gd   # Time, seasons, game state
│   │   │   └── event_bus.gd      # Decoupled signal hub
│   │   └── systems/
│   │       ├── terrain.gd        # Terrain type definitions
│   │       └── map_manager.gd    # Map rendering & generation
│   ├── assets/
│   │   ├── sprites/
│   │   ├── audio/
│   │   └── fonts/
│   └── data/                # Game data (resources, buildings, etc.)
```

## Current State

**Working:**
- Time system (days → seasons → years) with speed controls
- 64x64 tile map with 10 terrain types
- Salt water (ocean) vs fresh water (rivers) distinction
- Procedural island generation with coastlines, forests, hills, river
- Camera pan (WASD) and zoom (scroll)
- Terrain hover info UI

**Not yet implemented:**
- Colonists / entities
- Buildings
- Resources
- Fog of war
- Native peoples
- Trade / Crown relations

## Godot 4.6 Conventions

**Type strictness:** Godot 4.6 treats type inference warnings as errors.
```gdscript
# Bad - will error
var x := lerp(a, b, t)

# Good - use typed versions
var x: float = lerpf(a, b, t)
var y: float = absf(value)
```

**Avoid builtin name conflicts:**
```gdscript
# Bad - conflicts with Object.get_name()
static func get_name() -> String

# Good
static func get_display_name() -> String
```

**Static functions in class_name scripts:** Access via class name:
```gdscript
var props := Terrain.get_properties(terrain_type)
var color := Terrain.get_color(terrain_type)
```

## Key Design Decisions

1. **Salt vs Fresh Water** - Ocean for trade/fishing, freshwater for drinking. Different resources, different gameplay implications.

2. **Historical Authenticity** - Real nations (England, Spain, France), real dilemmas. Slavery exists with economic benefits AND escalating costs. Native relations shift from partnership to pressure as colonial power grows.

3. **Mirror, Not Lecture** - Show consequences through systems, not pop-ups. Let players draw their own conclusions.

4. **Visual Direction** - Period-authentic aesthetic (Dutch Golden Age, colonial cartography), not modern stylization. TBD but prototyping with colored rectangles for now.

## Running the Game

```bash
cd game
godot --editor project.godot  # Opens editor
# Then press F5 or Cmd+B to run
```

## Common Tasks

**Add a new terrain type:**
1. Add to `Terrain.Type` enum in `terrain.gd`
2. Add properties to `PROPERTIES` dict

**Add a new autoload singleton:**
1. Create script in `scripts/autoload/`
2. Add to `project.godot` under `[autoload]`

**Add signals for cross-system communication:**
1. Add signal to `event_bus.gd`
2. Emit with `EventBus.signal_name.emit(args)`
3. Connect with `EventBus.signal_name.connect(callback)`
