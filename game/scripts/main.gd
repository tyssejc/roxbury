extends Node2D
## Main scene controller
##
## Entry point for the game. Manages scene initialization and debug display.

@onready var debug_label: Label = $UI/DebugInfo


func _ready() -> void:
	print("Discovery Colony starting...")
	GameManager.start_game()

	# Connect to time signals for debug display
	GameManager.day_changed.connect(_on_day_changed)
	GameManager.season_changed.connect(_on_season_changed)
	GameManager.year_changed.connect(_on_year_changed)

	_update_debug_info()


func _process(_delta: float) -> void:
	_update_debug_info()


func _update_debug_info() -> void:
	if debug_label:
		var speed_name := _get_speed_name()
		debug_label.text = "Year %d | %s | Day %d\nSpeed: %s\n\nPress SPACE to pause\n1-3 for speed" % [
			GameManager.current_year,
			GameManager.get_season_name(),
			GameManager.get_day_of_season(),
			speed_name
		]


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
			KEY_1:
				GameManager.set_speed(GameManager.GameSpeed.NORMAL)
			KEY_2:
				GameManager.set_speed(GameManager.GameSpeed.FAST)
			KEY_3:
				GameManager.set_speed(GameManager.GameSpeed.VERY_FAST)


func _on_day_changed(_day: int) -> void:
	pass  # Could trigger daily events here


func _on_season_changed(season: String) -> void:
	EventBus.notification_requested.emit("Season changed to %s" % season, "info")


func _on_year_changed(year: int) -> void:
	EventBus.notification_requested.emit("Year %d begins" % year, "info")
