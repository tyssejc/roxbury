extends Node2D
## Main scene controller
##
## Entry point for the game. Manages scene initialization and UI updates.

@onready var time_label: Label = $UI/TopBar/TimeLabel
@onready var speed_label: Label = $UI/TopBar/SpeedLabel
@onready var population_label: Label = $UI/TopBar/PopulationLabel
@onready var bottom_info: Label = $UI/BottomInfo
@onready var map_manager: MapManager = $World/MapManager
@onready var colonist_container: Node2D = $World/ColonistContainer


func _ready() -> void:
	print("Discovery Colony starting...")
	GameManager.start_game()

	# Connect to time signals
	GameManager.day_changed.connect(_on_day_changed)
	GameManager.season_changed.connect(_on_season_changed)
	GameManager.year_changed.connect(_on_year_changed)

	# Connect to map signals
	if map_manager:
		map_manager.tile_hovered.connect(_on_tile_hovered)
		map_manager.tile_clicked.connect(_on_tile_clicked)

	# Setup colonist system
	ColonistManager.set_map_manager(map_manager)
	ColonistManager.set_colonist_container(colonist_container)

	# Connect to colonist events
	EventBus.colonist_died.connect(_on_colonist_died)
	EventBus.colonist_needs_critical.connect(_on_colonist_needs_critical)

	# Spawn initial colonists on beach
	_spawn_initial_colonists()

	_update_time_display()
	_update_speed_display()
	_update_population_display()


func _process(_delta: float) -> void:
	_update_time_display()
	_update_population_display()


func _update_time_display() -> void:
	if time_label:
		time_label.text = "Year %d | %s | Day %d" % [
			GameManager.current_year,
			GameManager.get_season_name(),
			GameManager.get_day_of_season()
		]


func _update_speed_display() -> void:
	if speed_label:
		speed_label.text = "Speed: %s" % _get_speed_name()


func _update_population_display() -> void:
	if population_label:
		population_label.text = "Population: %d" % ColonistManager.get_colonist_count()


func _get_speed_name() -> String:
	match GameManager.current_speed:
		GameManager.GameSpeed.PAUSED: return "Paused"
		GameManager.GameSpeed.NORMAL: return "Normal"
		GameManager.GameSpeed.FAST: return "Fast"
		GameManager.GameSpeed.VERY_FAST: return "Very Fast"
		_: return "Unknown"


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

	# Speed controls
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_SPACE:
				GameManager.toggle_pause()
				_update_speed_display()
			KEY_1:
				GameManager.set_speed(GameManager.GameSpeed.NORMAL)
				_update_speed_display()
			KEY_2:
				GameManager.set_speed(GameManager.GameSpeed.FAST)
				_update_speed_display()
			KEY_3:
				GameManager.set_speed(GameManager.GameSpeed.VERY_FAST)
				_update_speed_display()


func _on_day_changed(_day: int) -> void:
	pass  # Time display updates in _process


func _on_season_changed(season: String) -> void:
	EventBus.notification_requested.emit("Season changed to %s" % season, "info")


func _on_year_changed(year: int) -> void:
	EventBus.notification_requested.emit("Year %d begins" % year, "info")


func _on_tile_hovered(pos: Vector2i, terrain_type: Terrain.Type) -> void:
	if bottom_info:
		var props := Terrain.get_properties(terrain_type)
		var terrain_name: String = props.get("name", "Unknown")
		var water_type: Variant = props.get("water_type", null)
		var resources: Array = props.get("resources", [])
		var walkable: bool = props.get("walkable", false)
		var buildable: bool = props.get("buildable", false)

		var info_text := "%s (%d, %d)\n" % [terrain_name, pos.x, pos.y]

		# Water info
		if water_type:
			info_text += "Water: %s\n" % [str(water_type).capitalize()]

		# Resources
		if resources.size() > 0:
			var resource_names: PackedStringArray = []
			for r in resources:
				resource_names.append(str(r).replace("_", " ").capitalize())
			info_text += "Resources: %s\n" % [", ".join(resource_names)]

		# Flags
		var flags: PackedStringArray = []
		if walkable:
			flags.append("Walkable")
		if buildable:
			flags.append("Buildable")
		if flags.size() > 0:
			info_text += ", ".join(flags)

		bottom_info.text = info_text


func _on_tile_clicked(pos: Vector2i, terrain_type: Terrain.Type) -> void:
	var props := Terrain.get_properties(terrain_type)
	var terrain_name: String = props.get("name", "Unknown")
	print("Clicked tile: %s at %s" % [terrain_name, pos])


func _on_colonist_died(colonist: Node2D, cause: String) -> void:
	print("Colonist died from %s. Population: %d" % [cause, ColonistManager.get_colonist_count() - 1])


func _on_colonist_needs_critical(colonist: Node2D, need: String) -> void:
	print("Colonist has critical %s need" % need)


## Find beach tiles and spawn initial colonists
func _spawn_initial_colonists() -> void:
	var beach_tiles: Array[Vector2i] = []

	# Find all beach tiles
	for x in range(map_manager.map_width):
		for y in range(map_manager.map_height):
			var pos := Vector2i(x, y)
			if map_manager.get_terrain(pos) == Terrain.Type.BEACH:
				beach_tiles.append(pos)

	if beach_tiles.is_empty():
		push_error("No beach tiles found for colonist spawning")
		return

	# Spawn 5 colonists on random beach tiles
	var num_colonists := 5
	for i in range(num_colonists):
		var spawn_tile := beach_tiles[randi() % beach_tiles.size()]
		ColonistManager.spawn_colonist(spawn_tile)

	print("Spawned %d colonists on beach" % num_colonists)
