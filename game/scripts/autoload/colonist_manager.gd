extends Node
## ColonistManager - Central singleton managing all colonists
##
## Spawns colonists, triggers daily need updates, tracks active colonists.

## Reference to the map manager for pathfinding
var map_manager: MapManager

## All active colonists
var _colonists: Array[Node2D] = []

## Colonist scene to instantiate
var _colonist_scene: PackedScene

## Container node for colonists
var _colonist_container: Node2D


func _ready() -> void:
	_colonist_scene = preload("res://scenes/entities/colonist.tscn")
	GameManager.day_changed.connect(_on_day_changed)
	print("ColonistManager initialized")


## Set the colonist container node
func set_colonist_container(container: Node2D) -> void:
	_colonist_container = container


## Set the map manager reference for pathfinding
func set_map_manager(manager: MapManager) -> void:
	map_manager = manager


## Spawn a colonist at the given tile position
func spawn_colonist(tile_pos: Vector2i) -> Node2D:
	if not _colonist_container:
		push_error("ColonistManager: No colonist container set")
		return null

	if not map_manager:
		push_error("ColonistManager: No map manager set")
		return null

	var colonist: Node2D = _colonist_scene.instantiate()
	_colonist_container.add_child(colonist)

	# Position at tile center (use global_position for consistency)
	var world_pos := map_manager.tile_to_world(tile_pos)
	colonist.global_position = world_pos
	colonist.current_tile = tile_pos

	_colonists.append(colonist)
	EventBus.colonist_spawned.emit(colonist)

	print("Colonist spawned at tile %s" % tile_pos)
	return colonist


## Remove a colonist from management
func remove_colonist(colonist: Node2D) -> void:
	var idx := _colonists.find(colonist)
	if idx >= 0:
		_colonists.remove_at(idx)


## Get the number of active colonists
func get_colonist_count() -> int:
	return _colonists.size()


## Get all active colonists
func get_colonists() -> Array[Node2D]:
	return _colonists


## Called when a new day starts - trigger need updates
func _on_day_changed(_day: int) -> void:
	for colonist in _colonists:
		if colonist.has_method("update_needs_daily"):
			colonist.update_needs_daily()
