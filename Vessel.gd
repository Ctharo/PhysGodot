extends Node
class_name Vessel

@export var _name: String
var volume: float
var type: GlobalTypes.Vessels


## The [Vessel] that this vessel delivers [Blood] to
@export var deliver_to: Vessel

## The [Vessel] that this vessel receives [Blood] from TODO: Do we need this?
@export var receive_from: Vessel

func _init(vessel_type: GlobalTypes.Vessels, _volume: float = 1.0):
	self.type = vessel_type
	self.volume = _volume
	name = to_title_case(get_string())
	_name = name

## Returns String name representation of the [Vessel]
func get_string() -> String:
	return GlobalTypes.Vessels.keys()[type]

## Helper function to convert a string to title case
func to_title_case(s: String) -> String:
	# Split the string into words based on spaces
	var words = s.split(" ")

	# Capitalize the first letter of each word
	for i in range(words.size()):
		words[i] = words[i].capitalize()

	# Join the words back into a single string with spaces
	return " ".join(words)


