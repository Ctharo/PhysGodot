extends Node
class_name Tissue

var gases: Gases = Gases.new()
var vessels: Vessels = Vessels.new()
var mass: float = 1.0
var volume: float = 1.0
var metabolism_factor: float = 1.0

func _ready():
	pass

func _process(delta):
	pass

func get_concentration(gas: String) -> float:
	if mass == 0:
		return 0.0
	var moles: float = get_moles(gas)
	return moles/mass

func get_moles(gas: String) -> float:
	return gases.get_moles(gas)

func exchange_gas(gas: String, moles: float) -> void:
	var total_moles: float = get_moles(gas) + moles
	assert(total_moles >= 0, "Moles for %s cannot be negative." % gas)
	if moles > 0:
		# We are adding moles
		pass
	if moles < 0:
		# We are removing moles
		pass
	push_error("exchange_gas method not yet implemented")

func get_capillaries() -> Vessels:
	return vessels.get_capillaries()
