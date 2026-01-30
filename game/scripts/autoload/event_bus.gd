extends Node
## EventBus - Central message bus for game events
##
## Allows decoupled communication between game systems.
## Systems emit events here, and other systems can listen without direct references.

# =============================================================================
# COLONIST EVENTS
# =============================================================================

## Emitted when a colonist is spawned
signal colonist_spawned(colonist: Node2D)

## Emitted when a colonist dies
signal colonist_died(colonist: Node2D, cause: String)

## Emitted when a colonist's needs change significantly
signal colonist_needs_critical(colonist: Node2D, need: String)

## Emitted when a colonist starts a task
signal colonist_task_started(colonist: Node2D, task: String)

## Emitted when a colonist completes a task
signal colonist_task_completed(colonist: Node2D, task: String)

# =============================================================================
# BUILDING EVENTS
# =============================================================================

## Emitted when a building is placed
signal building_placed(building: Node2D, position: Vector2i)

## Emitted when a building is completed
signal building_completed(building: Node2D)

## Emitted when a building is destroyed
signal building_destroyed(building: Node2D)

# =============================================================================
# RESOURCE EVENTS
# =============================================================================

## Emitted when resources are gathered
signal resources_gathered(resource_type: String, amount: int)

## Emitted when resources are consumed
signal resources_consumed(resource_type: String, amount: int)

## Emitted when a resource stockpile is critically low
signal resources_critical(resource_type: String, amount: int)

# =============================================================================
# MAP EVENTS
# =============================================================================

## Emitted when a tile is explored
signal tile_explored(position: Vector2i)

## Emitted when a map region is surveyed by a cartographer
signal region_surveyed(region_id: String, quality: int)

# =============================================================================
# DIPLOMACY EVENTS
# =============================================================================

## Emitted when native relations change
signal native_relations_changed(faction: String, old_value: int, new_value: int)

## Emitted when Crown favor changes
signal crown_favor_changed(old_value: int, new_value: int)

# =============================================================================
# UI EVENTS
# =============================================================================

## Emitted when the player selects something
signal selection_changed(selected: Node)

## Emitted when a notification should be shown
signal notification_requested(message: String, type: String)


func _ready() -> void:
	print("EventBus initialized")
