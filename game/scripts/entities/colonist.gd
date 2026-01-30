extends Node2D
class_name Colonist
## Individual colonist entity with needs, state machine, and movement

## Colonist states
enum State { IDLE, MOVING, SEEKING_NEED, DYING }

## Need thresholds
const WARNING_THRESHOLD := 30.0
const CRITICAL_THRESHOLD := 15.0
const DEATH_THRESHOLD := 0.0

## Need decay rates (per day)
const FOOD_DECAY := 10.0
const SHELTER_DECAY := 5.0
const WARMTH_DECAY := 3.0

## Need recovery rates (per day, when conditions met)
const FOOD_RECOVERY_FOREST := 8.0
const FOOD_RECOVERY_GRASSLAND := 4.0
const WARMTH_RECOVERY_FOREST := 3.0

## Movement
const BASE_MOVE_SPEED := 64.0  # Pixels per second
const WANDER_RANGE := 5  # Tiles

## Visual
const COLONIST_WIDTH := 16.0
const COLONIST_HEIGHT := 24.0
const SKIN_COLOR := Color(0.76, 0.60, 0.42)  # Period-appropriate skin tone

## Current state
var current_state: State = State.IDLE

## Current tile position
var current_tile: Vector2i = Vector2i.ZERO

## Needs (0-100, death at 0)
var food: float = 100.0
var shelter: float = 100.0
var warmth: float = 100.0

## State machine variables
var _idle_timer: float = 0.0
var _idle_duration: float = 3.0
var _current_path: Array[Vector2i] = []
var _path_index: int = 0
var _target_tile: Vector2i = Vector2i.ZERO
var _dying_timer: float = 0.0
var _is_processing: bool = true

## Critical need being sought
var _seeking_need: String = ""


func _ready() -> void:
	_idle_duration = randf_range(2.0, 5.0)
	GameManager.game_paused.connect(_on_game_paused)


func _process(delta: float) -> void:
	if not _is_processing:
		return

	match current_state:
		State.IDLE:
			_process_idle(delta)
		State.MOVING:
			_process_moving(delta)
		State.SEEKING_NEED:
			_process_seeking(delta)
		State.DYING:
			_process_dying(delta)


func _draw() -> void:
	# Base body color - tint based on critical needs
	var body_color := SKIN_COLOR

	if current_state == State.DYING:
		body_color = Color.GRAY
	else:
		# Blend toward warning colors for critical needs
		if food < CRITICAL_THRESHOLD:
			body_color = body_color.lerp(Color.RED, 0.5)
		if warmth < CRITICAL_THRESHOLD:
			body_color = body_color.lerp(Color.CYAN, 0.5)
		if shelter < CRITICAL_THRESHOLD:
			body_color = body_color.lerp(Color.BLUE, 0.5)

	# Draw body (centered)
	var body_rect := Rect2(
		-COLONIST_WIDTH / 2.0,
		-COLONIST_HEIGHT / 2.0,
		COLONIST_WIDTH,
		COLONIST_HEIGHT
	)
	draw_rect(body_rect, body_color)

	# Draw critical need indicators above head
	var indicator_y := -COLONIST_HEIGHT / 2.0 - 8.0
	var indicator_x := -6.0

	if food < WARNING_THRESHOLD:
		draw_rect(Rect2(indicator_x, indicator_y, 4, 4), Color.RED)
		indicator_x += 5.0

	if warmth < WARNING_THRESHOLD:
		draw_rect(Rect2(indicator_x, indicator_y, 4, 4), Color.CYAN)
		indicator_x += 5.0

	if shelter < WARNING_THRESHOLD:
		draw_rect(Rect2(indicator_x, indicator_y, 4, 4), Color.BLUE)


## Update needs at the start of each day
func update_needs_daily() -> void:
	if current_state == State.DYING:
		return

	var season: GameManager.Season = GameManager.current_season

	# Calculate seasonal modifiers
	var food_modifier := 1.0
	var shelter_modifier := 1.0
	var warmth_modifier := 1.0

	match season:
		GameManager.Season.WINTER:
			food_modifier = 1.5
			shelter_modifier = 2.0
			warmth_modifier = 3.0
		GameManager.Season.SUMMER:
			warmth_modifier = 0.5

	# Apply decay
	food -= FOOD_DECAY * food_modifier
	shelter -= SHELTER_DECAY * shelter_modifier
	warmth -= WARMTH_DECAY * warmth_modifier

	# Apply terrain-based recovery (foraging)
	var terrain: Terrain.Type = ColonistManager.map_manager.get_terrain(current_tile)

	match terrain:
		Terrain.Type.FOREST, Terrain.Type.DENSE_FOREST:
			food += FOOD_RECOVERY_FOREST
			warmth += WARMTH_RECOVERY_FOREST
		Terrain.Type.GRASSLAND:
			food += FOOD_RECOVERY_GRASSLAND

	# Clamp values
	food = clampf(food, 0.0, 100.0)
	shelter = clampf(shelter, 0.0, 100.0)
	warmth = clampf(warmth, 0.0, 100.0)

	# Check for critical needs
	_check_critical_needs()

	# Check for death
	if food <= DEATH_THRESHOLD:
		_die("starvation")
	elif shelter <= DEATH_THRESHOLD:
		_die("exposure")
	elif warmth <= DEATH_THRESHOLD:
		_die("hypothermia")

	queue_redraw()


## Check and emit signals for critical needs
func _check_critical_needs() -> void:
	if food < CRITICAL_THRESHOLD and food > DEATH_THRESHOLD:
		EventBus.colonist_needs_critical.emit(self, "food")
	if shelter < CRITICAL_THRESHOLD and shelter > DEATH_THRESHOLD:
		EventBus.colonist_needs_critical.emit(self, "shelter")
	if warmth < CRITICAL_THRESHOLD and warmth > DEATH_THRESHOLD:
		EventBus.colonist_needs_critical.emit(self, "warmth")


## Transition to a new state
func _change_state(new_state: State) -> void:
	current_state = new_state

	match new_state:
		State.IDLE:
			_idle_timer = 0.0
			_idle_duration = randf_range(2.0, 5.0)
		State.MOVING:
			pass
		State.SEEKING_NEED:
			pass
		State.DYING:
			_dying_timer = 0.0


## Process idle state
func _process_idle(delta: float) -> void:
	_idle_timer += delta

	if _idle_timer >= _idle_duration:
		# Check if we have critical needs
		var critical_need := _get_most_critical_need()
		if critical_need != "":
			_seeking_need = critical_need
			_seek_need_location()
		else:
			# Random wander
			_start_random_wander()


## Process moving state
func _process_moving(delta: float) -> void:
	if _current_path.is_empty() or _path_index >= _current_path.size():
		# Reached destination
		_change_state(State.IDLE)
		return

	var target_tile := _current_path[_path_index]
	var target_pos := ColonistManager.map_manager.tile_to_world(target_tile)

	# Get movement speed based on terrain
	var terrain: Terrain.Type = ColonistManager.map_manager.get_terrain(current_tile)
	var movement_cost: float = Terrain.get_movement_cost(terrain)
	var speed: float = BASE_MOVE_SPEED / movement_cost

	# Move toward target (use global_position for consistency with tile_to_world)
	var direction := (target_pos - global_position).normalized()
	var move_distance := speed * delta
	var distance_to_target := global_position.distance_to(target_pos)

	if move_distance >= distance_to_target:
		# Reached this tile
		global_position = target_pos
		current_tile = target_tile
		_path_index += 1
	else:
		global_position += direction * move_distance


## Process seeking need state (same as moving but for needs)
func _process_seeking(delta: float) -> void:
	_process_moving(delta)

	# When we reach destination, go back to idle (foraging happens on day tick)
	if _current_path.is_empty() or _path_index >= _current_path.size():
		_change_state(State.IDLE)


## Process dying state
func _process_dying(delta: float) -> void:
	_dying_timer += delta

	if _dying_timer >= 1.0:
		_complete_death()


## Get the most critical need
func _get_most_critical_need() -> String:
	var lowest_value := WARNING_THRESHOLD
	var critical_need := ""

	if food < lowest_value:
		lowest_value = food
		critical_need = "food"

	if warmth < lowest_value:
		lowest_value = warmth
		critical_need = "warmth"

	if shelter < lowest_value:
		critical_need = "shelter"

	return critical_need


## Start seeking a location to satisfy a need
func _seek_need_location() -> void:
	var target: Vector2i = Vector2i(-1, -1)

	match _seeking_need:
		"food", "warmth":
			# Find nearest forest tile
			target = _find_nearest_terrain([Terrain.Type.FOREST, Terrain.Type.DENSE_FOREST])
			if target == Vector2i(-1, -1) and _seeking_need == "food":
				# Fall back to grassland for food
				target = _find_nearest_terrain([Terrain.Type.GRASSLAND])
		"shelter":
			# No buildings yet, just stay put
			_change_state(State.IDLE)
			return

	if target != Vector2i(-1, -1):
		move_to(target)
		_change_state(State.SEEKING_NEED)
	else:
		_change_state(State.IDLE)


## Find nearest tile of given terrain types
func _find_nearest_terrain(terrain_types: Array) -> Vector2i:
	var best_tile := Vector2i(-1, -1)
	var best_distance := INF

	# Search in expanding rings from current position
	for radius in range(1, 20):
		for dx in range(-radius, radius + 1):
			for dy in range(-radius, radius + 1):
				if absi(dx) != radius and absi(dy) != radius:
					continue  # Only check ring perimeter

				var check_tile := current_tile + Vector2i(dx, dy)
				if not ColonistManager.map_manager.is_valid_tile(check_tile):
					continue

				var terrain: Terrain.Type = ColonistManager.map_manager.get_terrain(check_tile)
				if terrain in terrain_types:
					var dist: float = current_tile.distance_to(check_tile)
					if dist < best_distance:
						best_distance = dist
						best_tile = check_tile

		if best_tile != Vector2i(-1, -1):
			break  # Found one at this radius

	return best_tile


## Start random wandering
func _start_random_wander() -> void:
	var attempts := 0
	while attempts < 10:
		var dx := randi_range(-WANDER_RANGE, WANDER_RANGE)
		var dy := randi_range(-WANDER_RANGE, WANDER_RANGE)
		var target := current_tile + Vector2i(dx, dy)

		if ColonistManager.map_manager.is_valid_tile(target):
			var terrain: Terrain.Type = ColonistManager.map_manager.get_terrain(target)
			if Terrain.is_walkable(terrain):
				move_to(target)
				return

		attempts += 1

	# Couldn't find valid wander target, stay idle
	_change_state(State.IDLE)


## Move to a target tile using pathfinding
func move_to(target: Vector2i) -> void:
	_current_path = ColonistManager.map_manager.find_path(current_tile, target)
	_path_index = 0
	_target_tile = target

	if _current_path.is_empty():
		_change_state(State.IDLE)
	else:
		_change_state(State.MOVING)


## Start the death process
func _die(cause: String) -> void:
	if current_state == State.DYING:
		return

	print("Colonist dying from %s" % cause)
	_change_state(State.DYING)
	queue_redraw()


## Complete the death and remove colonist
func _complete_death() -> void:
	var cause := "unknown"
	if food <= DEATH_THRESHOLD:
		cause = "starvation"
	elif warmth <= DEATH_THRESHOLD:
		cause = "hypothermia"
	elif shelter <= DEATH_THRESHOLD:
		cause = "exposure"

	EventBus.colonist_died.emit(self, cause)
	ColonistManager.remove_colonist(self)
	queue_free()


## Handle game pause
func _on_game_paused(is_paused: bool) -> void:
	_is_processing = not is_paused
