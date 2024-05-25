extends Resource
class_name ChemicalSignal

var type: String
var affinity: float  # Higher affinity means stronger binding preference
var half_life: float  # Time for the signal's effect to halve
var effect: float  # Magnitude of the effect on the cell

# Constructor
func _init(_type: String, _affinity: float, _half_life: float, _effect: float) -> void:
	type = _type
	affinity = _affinity
	half_life = _half_life
	effect = _effect
