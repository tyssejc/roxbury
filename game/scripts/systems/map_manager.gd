extends Node2D
class_name MapManager
## Manages the game map, terrain data, and rendering
##
## Handles terrain storage, map generation, and tile rendering.
## Uses a simple colored rectangle approach for prototyping.

signal tile_clicked(position: Vector2i, terrain_type: Terrain.Type)
signal tile_hovered(position: Vector2i, terrain_type: Terrain.Type)

## Tile size in pixels
const TILE_SIZE := 32

## Map dimensions (in tiles)
@export var map_width := 64
@export var map_height := 64

## Terrain data: Vector2i -> Terrain.Type
var _terrain_data := {}

## Currently hovered tile
var _hovered_tile: Vector2i = Vector2i(-1, -1)

## Pathfinding grid
var _astar: AStarGrid2D


func _ready() -> void:
	# Generate a test map on ready
	generate_test_map()
	_setup_pathfinding()
	queue_redraw()


func _draw() -> void:
	# Draw all terrain tiles
	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2i(x, y)
			var terrain_type: Terrain.Type = _terrain_data.get(pos, Terrain.Type.OCEAN)
			var color: Color = Terrain.get_color(terrain_type)

			var rect := Rect2(
				x * TILE_SIZE,
				y * TILE_SIZE,
				TILE_SIZE,
				TILE_SIZE
			)
			draw_rect(rect, color)

	# Draw grid lines (subtle)
	var grid_color := Color(0, 0, 0, 0.1)
	for x in range(map_width + 1):
		draw_line(
			Vector2(x * TILE_SIZE, 0),
			Vector2(x * TILE_SIZE, map_height * TILE_SIZE),
			grid_color
		)
	for y in range(map_height + 1):
		draw_line(
			Vector2(0, y * TILE_SIZE),
			Vector2(map_width * TILE_SIZE, y * TILE_SIZE),
			grid_color
		)

	# Highlight hovered tile
	if _hovered_tile.x >= 0 and _hovered_tile.y >= 0:
		var hover_rect := Rect2(
			_hovered_tile.x * TILE_SIZE,
			_hovered_tile.y * TILE_SIZE,
			TILE_SIZE,
			TILE_SIZE
		)
		draw_rect(hover_rect, Color(1, 1, 1, 0.3))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var new_hovered := world_to_tile(get_global_mouse_position())
		if new_hovered != _hovered_tile:
			_hovered_tile = new_hovered
			if is_valid_tile(_hovered_tile):
				var terrain_type: Terrain.Type = get_terrain(_hovered_tile)
				tile_hovered.emit(_hovered_tile, terrain_type)
			queue_redraw()

	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var clicked_tile := world_to_tile(get_global_mouse_position())
			if is_valid_tile(clicked_tile):
				var terrain_type: Terrain.Type = get_terrain(clicked_tile)
				tile_clicked.emit(clicked_tile, terrain_type)


## Convert world position to tile coordinates
func world_to_tile(world_pos: Vector2) -> Vector2i:
	var local_pos := to_local(world_pos)
	return Vector2i(
		int(floor(local_pos.x / TILE_SIZE)),
		int(floor(local_pos.y / TILE_SIZE))
	)


## Convert tile coordinates to world position (center of tile)
func tile_to_world(tile_pos: Vector2i) -> Vector2:
	return to_global(Vector2(
		tile_pos.x * TILE_SIZE + TILE_SIZE / 2.0,
		tile_pos.y * TILE_SIZE + TILE_SIZE / 2.0
	))


## Check if tile coordinates are valid
func is_valid_tile(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < map_width and pos.y >= 0 and pos.y < map_height


## Get terrain type at position
func get_terrain(pos: Vector2i) -> Terrain.Type:
	return _terrain_data.get(pos, Terrain.Type.OCEAN)


## Set terrain type at position
func set_terrain(pos: Vector2i, terrain_type: Terrain.Type) -> void:
	if is_valid_tile(pos):
		_terrain_data[pos] = terrain_type
		queue_redraw()


## Get map bounds in world coordinates
func get_map_bounds() -> Rect2:
	return Rect2(
		to_global(Vector2.ZERO),
		Vector2(map_width * TILE_SIZE, map_height * TILE_SIZE)
	)


## Generate a test map with varied terrain
func generate_test_map() -> void:
	_terrain_data.clear()

	# Use simple noise-like generation for variety
	var rng := RandomNumberGenerator.new()
	rng.seed = 12345  # Fixed seed for reproducibility during development

	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2i(x, y)
			var terrain_type := _generate_terrain_at(x, y, rng)
			_terrain_data[pos] = terrain_type

	# Post-process: add rivers
	_add_river(rng)

	# Post-process: ensure coastline consistency
	_smooth_coastline()

	print("Map generated: %dx%d tiles" % [map_width, map_height])


func _generate_terrain_at(x: int, y: int, rng: RandomNumberGenerator) -> Terrain.Type:
	# Create an interesting landmass shape
	var center_x := map_width / 2.0
	var center_y := map_height / 2.0

	# Distance from center (normalized)
	var dist_x := (x - center_x) / center_x
	var dist_y := (y - center_y) / center_y
	var distance := sqrt(dist_x * dist_x + dist_y * dist_y)

	# Add some noise to the coastline
	var noise_val := sin(x * 0.3) * 0.15 + cos(y * 0.4) * 0.15 + rng.randf() * 0.1
	var adjusted_distance := distance + noise_val

	# Determine terrain based on distance from center
	if adjusted_distance > 1.1:
		return Terrain.Type.OCEAN
	elif adjusted_distance > 0.95:
		return Terrain.Type.COASTAL
	elif adjusted_distance > 0.85:
		return Terrain.Type.BEACH
	else:
		# Inland terrain - use noise to vary
		var inland_noise := rng.randf()

		# Hills tend toward edges of landmass
		if adjusted_distance > 0.6 and inland_noise > 0.85:
			return Terrain.Type.HILLS
		elif adjusted_distance > 0.7 and inland_noise > 0.95:
			return Terrain.Type.MOUNTAIN
		# Forests more common further inland
		elif adjusted_distance < 0.5 and inland_noise > 0.4:
			if inland_noise > 0.75:
				return Terrain.Type.DENSE_FOREST
			else:
				return Terrain.Type.FOREST
		elif inland_noise > 0.7:
			return Terrain.Type.FOREST
		else:
			return Terrain.Type.GRASSLAND


@warning_ignore("integer_division")
func _add_river(rng: RandomNumberGenerator) -> void:
	# Add a river from hills/mountains to the coast
	# Find a starting point in the hills
	var start_pos := Vector2i(map_width / 3, map_height / 4)

	# Find nearest hills or high ground
	for x in range(map_width / 4, map_width * 3 / 4):
		for y in range(map_height / 4, map_height / 2):
			var pos := Vector2i(x, y)
			if _terrain_data.get(pos) == Terrain.Type.HILLS:
				start_pos = pos
				break

	# Flow river toward the coast (generally downward/outward)
	var current := start_pos
	var river_tiles: Array[Vector2i] = []

	for i in range(100):  # Max river length
		river_tiles.append(current)

		# Check if we've reached water
		var current_terrain: Terrain.Type = _terrain_data.get(current, Terrain.Type.OCEAN)
		if current_terrain == Terrain.Type.OCEAN or current_terrain == Terrain.Type.COASTAL:
			break

		# Move toward the coast (toward edges)
		var center := Vector2(map_width / 2.0, map_height / 2.0)
		var to_edge := Vector2(current) - center
		to_edge = to_edge.normalized()

		# Add some meandering
		var perpendicular := Vector2(-to_edge.y, to_edge.x)
		var meander := perpendicular * (rng.randf() - 0.5) * 2.0
		var direction := (to_edge + meander).normalized()

		# Move to next tile
		var next := Vector2i(
			current.x + roundi(direction.x),
			current.y + roundi(direction.y)
		)

		if not is_valid_tile(next):
			break

		current = next

	# Set river tiles
	for pos in river_tiles:
		var existing: Terrain.Type = _terrain_data.get(pos, Terrain.Type.OCEAN)
		if existing != Terrain.Type.OCEAN and existing != Terrain.Type.COASTAL:
			_terrain_data[pos] = Terrain.Type.FRESHWATER

	# Add marsh near river
	for pos in river_tiles:
		for dx in [-1, 0, 1]:
			for dy in [-1, 0, 1]:
				if dx == 0 and dy == 0:
					continue
				var neighbor := Vector2i(pos.x + dx, pos.y + dy)
				if is_valid_tile(neighbor):
					var neighbor_terrain: Terrain.Type = _terrain_data.get(neighbor, Terrain.Type.OCEAN)
					if neighbor_terrain == Terrain.Type.GRASSLAND and rng.randf() > 0.7:
						_terrain_data[neighbor] = Terrain.Type.MARSH


func _smooth_coastline() -> void:
	# Ensure beaches are between land and water
	var changes := {}

	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2i(x, y)
			var terrain: Terrain.Type = _terrain_data.get(pos, Terrain.Type.OCEAN)

			# Check if this land tile is adjacent to ocean
			if Terrain.is_walkable(terrain) and terrain != Terrain.Type.BEACH:
				var adjacent_to_ocean := false
				for dx in [-1, 0, 1]:
					for dy in [-1, 0, 1]:
						if dx == 0 and dy == 0:
							continue
						var neighbor := Vector2i(x + dx, y + dy)
						var neighbor_terrain: Terrain.Type = _terrain_data.get(neighbor, Terrain.Type.OCEAN)
						if neighbor_terrain == Terrain.Type.OCEAN or neighbor_terrain == Terrain.Type.COASTAL:
							adjacent_to_ocean = true
							break
					if adjacent_to_ocean:
						break

				if adjacent_to_ocean:
					changes[pos] = Terrain.Type.BEACH

	for pos in changes:
		_terrain_data[pos] = changes[pos]


## Setup A* pathfinding grid
func _setup_pathfinding() -> void:
	_astar = AStarGrid2D.new()
	_astar.region = Rect2i(0, 0, map_width, map_height)
	_astar.cell_size = Vector2(TILE_SIZE, TILE_SIZE)
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	_astar.update()

	# Mark impassable tiles and set movement costs
	for x in range(map_width):
		for y in range(map_height):
			var pos := Vector2i(x, y)
			var terrain: Terrain.Type = _terrain_data.get(pos, Terrain.Type.OCEAN)

			if not Terrain.is_walkable(terrain):
				_astar.set_point_solid(pos, true)
			else:
				var cost: float = Terrain.get_movement_cost(terrain)
				_astar.set_point_weight_scale(pos, cost)

	print("Pathfinding grid initialized")


## Get a path between two tile positions (returns tile coordinates, not world positions)
func find_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	if not _astar:
		return []

	if not is_valid_tile(from) or not is_valid_tile(to):
		return []

	if _astar.is_point_solid(from) or _astar.is_point_solid(to):
		return []

	# Use get_id_path to get tile coordinates (not get_point_path which returns world positions)
	var path: Array[Vector2i] = _astar.get_id_path(from, to)

	# Skip the first point (current position)
	if path.size() <= 1:
		return []

	return path.slice(1)


## Check if a tile is passable for pathfinding
func is_tile_passable(pos: Vector2i) -> bool:
	if not _astar:
		return false
	if not is_valid_tile(pos):
		return false
	return not _astar.is_point_solid(pos)
