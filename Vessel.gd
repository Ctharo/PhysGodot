extends Node
class_name Vessel

var volume: float
var type: GlobalTypes.Vessels

func _init(vessel_type: GlobalTypes.Vessels, _volume: float = 1.0):
	self.type = vessel_type
	self.volume = _volume
	name = to_title_case(get_string())

func get_string() -> String:
	return GlobalTypes.Vessels.keys()[type]

func to_title_case(s: String) -> String:
	# Split the string into words based on spaces
	var words = s.split(" ")

	# Capitalize the first letter of each word
	for i in range(words.size()):
		words[i] = words[i].capitalize()

	# Join the words back into a single string with spaces
	return " ".join(words)


