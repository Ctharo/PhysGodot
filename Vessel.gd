extends Node
class_name Vessel

var volume: float
var type: GlobalTypes.Vessels

func _init(vessel_type: GlobalTypes.Vessels, _volume: float = 1.0):
	self.type = vessel_type
	self.volume = _volume

func get_string() -> String:
	return GlobalTypes.Vessels.keys()[type]

