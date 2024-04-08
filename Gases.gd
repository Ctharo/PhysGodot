class_name Gases
"""
Represents a collection of gases and their amounts in moles.
"""

var gases: Dictionary = {}

func _init():
	for gas in GlobalTypes.Gases.values():
		set_moles(gas, 0.1)

func set_moles(gas: GlobalTypes.Gases, moles: float) -> void:
	"""
	Sets the amount of a specified gas.

	- `gas`: The gas type as a `String`.
	- `moles`: The amount of the gas in moles as a `float`.
	"""
	assert(moles >= 0, "Moles for %s cannot be negative." % Gases.get_string(gas))
	gases[Gases.get_string(gas)] = moles

func get_moles(gas: GlobalTypes.Gases) -> float:
	"""
	Gets the amount of moles for a specified gas.

	- `gas`: The gas type as a `String`.
	- Returns: The amount of the gas in moles as a `float`.
	"""
	if gases.has(Gases.get_string(gas)):
		return gases[Gases.get_string(gas)]
	return 0.0

func get_all_gases() -> Dictionary:
	"""
	Returns a deep copy of the gases dictionary.

	- Returns: A `Dictionary` representing all gases and their mole amounts.
	"""
	return gases.duplicate()

static func get_string(gas: GlobalTypes.Gases) -> String:
	return GlobalTypes.Gases.keys()[gas]
