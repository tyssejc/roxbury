extends Node
## GameManager - Global game state singleton
##
## Manages overall game state, time progression, and coordinates between systems.

signal day_changed(day: int)
signal season_changed(season: String)
signal year_changed(year: int)
signal game_paused(is_paused: bool)

## Game speed settings
enum GameSpeed { PAUSED, NORMAL, FAST, VERY_FAST }

## Season definitions
enum Season { SPRING, SUMMER, AUTUMN, WINTER }

const DAYS_PER_SEASON := 30
const SEASONS_PER_YEAR := 4
const DAYS_PER_YEAR := DAYS_PER_SEASON * SEASONS_PER_YEAR

## Current game time
var current_day := 1
var current_season: Season = Season.SPRING
var current_year := 1

## Game speed (seconds per game day at normal speed)
var seconds_per_day := 60.0
var current_speed: GameSpeed = GameSpeed.NORMAL
var _day_timer := 0.0

## Speed multipliers
var _speed_multipliers := {
	GameSpeed.PAUSED: 0.0,
	GameSpeed.NORMAL: 1.0,
	GameSpeed.FAST: 3.0,
	GameSpeed.VERY_FAST: 10.0
}

## Game state
var is_game_started := false


func _ready() -> void:
	print("GameManager initialized")


func _process(delta: float) -> void:
	if not is_game_started or current_speed == GameSpeed.PAUSED:
		return

	_day_timer += delta * _speed_multipliers[current_speed]

	if _day_timer >= seconds_per_day:
		_day_timer -= seconds_per_day
		_advance_day()


func start_game() -> void:
	"""Begin a new game."""
	current_day = 1
	current_season = Season.SPRING
	current_year = 1
	is_game_started = true
	current_speed = GameSpeed.NORMAL
	print("Game started: Year %d, %s, Day %d" % [current_year, get_season_name(), current_day])


func set_speed(speed: GameSpeed) -> void:
	"""Set the game speed."""
	current_speed = speed
	game_paused.emit(speed == GameSpeed.PAUSED)


func toggle_pause() -> void:
	"""Toggle between paused and normal speed."""
	if current_speed == GameSpeed.PAUSED:
		set_speed(GameSpeed.NORMAL)
	else:
		set_speed(GameSpeed.PAUSED)


func get_season_name() -> String:
	"""Get the display name of the current season."""
	match current_season:
		Season.SPRING: return "Spring"
		Season.SUMMER: return "Summer"
		Season.AUTUMN: return "Autumn"
		Season.WINTER: return "Winter"
		_: return "Unknown"


func get_day_of_season() -> int:
	"""Get the current day within the season (1-30)."""
	return ((current_day - 1) % DAYS_PER_SEASON) + 1


func _advance_day() -> void:
	"""Advance the game by one day."""
	current_day += 1
	day_changed.emit(current_day)

	# Check for season change
	var day_in_year := ((current_day - 1) % DAYS_PER_YEAR)
	var new_season: Season = int(day_in_year / DAYS_PER_SEASON) as Season

	if new_season != current_season:
		current_season = new_season
		season_changed.emit(get_season_name())
		print("Season changed to %s" % get_season_name())

	# Check for year change
	if day_in_year == 0 and current_day > 1:
		current_year += 1
		year_changed.emit(current_year)
		print("Year %d begins" % current_year)
