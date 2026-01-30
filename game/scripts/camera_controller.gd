extends Camera2D
## Camera controller for panning and zooming
##
## Provides smooth camera movement for the colony view.

## Pan speed in pixels per second
@export var pan_speed := 500.0

## Zoom settings
@export var zoom_speed := 0.1
@export var min_zoom := 0.25
@export var max_zoom := 2.0

## Smooth zoom
var _target_zoom := 0.5


func _ready() -> void:
	zoom = Vector2(_target_zoom, _target_zoom)


func _process(delta: float) -> void:
	_handle_pan(delta)
	_handle_zoom(delta)


func _handle_pan(delta: float) -> void:
	var pan_direction := Vector2.ZERO

	if Input.is_action_pressed("camera_pan_up"):
		pan_direction.y -= 1
	if Input.is_action_pressed("camera_pan_down"):
		pan_direction.y += 1
	if Input.is_action_pressed("camera_pan_left"):
		pan_direction.x -= 1
	if Input.is_action_pressed("camera_pan_right"):
		pan_direction.x += 1

	if pan_direction != Vector2.ZERO:
		# Normalize for consistent diagonal speed
		pan_direction = pan_direction.normalized()
		# Scale by zoom level so panning feels consistent
		var effective_speed := pan_speed / zoom.x
		position += pan_direction * effective_speed * delta


func _handle_zoom(delta: float) -> void:
	# Smoothly interpolate to target zoom
	var current_zoom: float = zoom.x
	if absf(current_zoom - _target_zoom) > 0.01:
		var new_zoom: float = lerpf(current_zoom, _target_zoom, 10.0 * delta)
		zoom = Vector2(new_zoom, new_zoom)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_zoom_in"):
		_target_zoom = clamp(_target_zoom + zoom_speed, min_zoom, max_zoom)
	elif event.is_action_pressed("camera_zoom_out"):
		_target_zoom = clamp(_target_zoom - zoom_speed, min_zoom, max_zoom)
