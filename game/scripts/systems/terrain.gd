extends Node
class_name Terrain
## Terrain type definitions and utilities
##
## Defines all terrain types and their properties for the colony map.

## Terrain type enumeration
enum Type {
	OCEAN,          # Deep salt water - fishing, trade routes
	COASTAL,        # Shallow salt water - harbors, coastal fishing
	BEACH,          # Sandy shore - landing sites
	FRESHWATER,     # Rivers, lakes - drinking water, freshwater fish
	MARSH,          # Wetland - herbs, disease risk, some freshwater
	GRASSLAND,      # Open land - farming, building
	FOREST,         # Wooded area - lumber, hunting, gathering
	DENSE_FOREST,   # Thick woods - more resources, harder to clear
	HILLS,          # Elevated terrain - stone, defensive positions
	MOUNTAIN,       # Impassable peaks - stone quarries at edges
}

## Terrain properties
const PROPERTIES := {
	Type.OCEAN: {
		"name": "Ocean",
		"color": Color(0.1, 0.2, 0.4),  # Dark blue
		"walkable": false,
		"buildable": false,
		"water_type": "salt",
		"resources": ["saltwater_fish"],
		"movement_cost": INF,
	},
	Type.COASTAL: {
		"name": "Coastal Waters",
		"color": Color(0.2, 0.4, 0.6),  # Medium blue
		"walkable": false,
		"buildable": false,  # But can build docks adjacent
		"water_type": "salt",
		"resources": ["saltwater_fish", "shellfish"],
		"movement_cost": INF,
	},
	Type.BEACH: {
		"name": "Beach",
		"color": Color(0.76, 0.7, 0.5),  # Sandy tan
		"walkable": true,
		"buildable": true,
		"water_type": null,
		"resources": ["shellfish"],
		"movement_cost": 1.2,
	},
	Type.FRESHWATER: {
		"name": "Freshwater",
		"color": Color(0.3, 0.5, 0.7),  # Lighter blue
		"walkable": false,
		"buildable": false,
		"water_type": "fresh",
		"resources": ["freshwater_fish", "drinking_water"],
		"movement_cost": INF,
	},
	Type.MARSH: {
		"name": "Marsh",
		"color": Color(0.4, 0.5, 0.3),  # Olive green
		"walkable": true,
		"buildable": false,
		"water_type": "fresh",  # Brackish but closer to fresh
		"resources": ["herbs", "reeds", "waterfowl"],
		"movement_cost": 2.0,
		"disease_risk": true,
	},
	Type.GRASSLAND: {
		"name": "Grassland",
		"color": Color(0.4, 0.6, 0.3),  # Light green
		"walkable": true,
		"buildable": true,
		"water_type": null,
		"resources": ["wild_plants"],
		"movement_cost": 1.0,
	},
	Type.FOREST: {
		"name": "Forest",
		"color": Color(0.2, 0.4, 0.2),  # Medium green
		"walkable": true,
		"buildable": true,  # After clearing
		"water_type": null,
		"resources": ["wood", "game", "herbs", "wild_plants"],
		"movement_cost": 1.5,
	},
	Type.DENSE_FOREST: {
		"name": "Dense Forest",
		"color": Color(0.1, 0.3, 0.1),  # Dark green
		"walkable": true,
		"buildable": true,  # After significant clearing
		"water_type": null,
		"resources": ["wood", "game", "herbs", "wild_plants", "furs"],
		"movement_cost": 2.0,
	},
	Type.HILLS: {
		"name": "Hills",
		"color": Color(0.5, 0.45, 0.35),  # Brown-gray
		"walkable": true,
		"buildable": true,
		"water_type": null,
		"resources": ["stone", "iron_ore"],
		"movement_cost": 1.8,
	},
	Type.MOUNTAIN: {
		"name": "Mountain",
		"color": Color(0.4, 0.4, 0.45),  # Gray
		"walkable": false,
		"buildable": false,
		"water_type": null,
		"resources": ["stone", "iron_ore", "silver"],  # At quarries on edges
		"movement_cost": INF,
	},
}


## Get properties for a terrain type
static func get_properties(type: Type) -> Dictionary:
	return PROPERTIES.get(type, {})


## Check if terrain is walkable
static func is_walkable(type: Type) -> bool:
	return PROPERTIES.get(type, {}).get("walkable", false)


## Check if terrain is buildable
static func is_buildable(type: Type) -> bool:
	return PROPERTIES.get(type, {}).get("buildable", false)


## Get water type (null, "fresh", or "salt")
static func get_water_type(type: Type) -> Variant:
	return PROPERTIES.get(type, {}).get("water_type", null)


## Check if terrain has fresh water access
static func has_fresh_water(type: Type) -> bool:
	return get_water_type(type) == "fresh"


## Get movement cost for pathfinding
static func get_movement_cost(type: Type) -> float:
	return PROPERTIES.get(type, {}).get("movement_cost", 1.0)


## Get color for rendering
static func get_color(type: Type) -> Color:
	return PROPERTIES.get(type, {}).get("color", Color.MAGENTA)


## Get display name
static func get_display_name(type: Type) -> String:
	return PROPERTIES.get(type, {}).get("name", "Unknown")


## Get available resources on this terrain
static func get_resources(type: Type) -> Array:
	return PROPERTIES.get(type, {}).get("resources", [])
