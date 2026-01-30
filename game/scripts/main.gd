extends Node2D
## Main scene controller
##
## Entry point for the game. Manages scene initialization and UI updates.

@onready var time_label: Label = $UI/TopBar/TimeLabel
@onready var speed_label: Label = $UI/TopBar/SpeedLabel
@onready var bottom_info: Label = $UI/BottomInfo
@onready var map_manager: MapManager = $World/MapManager


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

	_update_time_display()
	_update_speed_display()


func _process(_delta: float) -> void:
	_update_time_display()


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
