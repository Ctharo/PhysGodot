class_name Gases
## Represents a collection of gases and their details.
##
## Iterable

var gases: Dictionary = {}

func _init():
	for gas in GlobalTypes.Gases.values():
		set_moles(gas, 0.1)

## Sets the amount of a specified gas.
func set_moles(gas: GlobalTypes.Gases, moles: float) -> void:
	assert(moles >= 0, "Moles for %s cannot be negative." % Gases.get_string(gas))
	gases[Gases.get_string(gas)] = moles

func get_moles(gas: GlobalTypes.Gases) -> float:
	if gases.has(Gases.get_string(gas)):
		return gases[Gases.get_string(gas)]
	return 0.0

func get_all_gases() -> Dictionary:
	return gases.duplicate()

static func get_string(gas: GlobalTypes.Gases) -> String:
	return GlobalTypes.Gases.keys()[gas]
