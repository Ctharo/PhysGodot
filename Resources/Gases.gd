class_name Gases
extends Iterator
## Represents a collection of gases and their details.
##
## Iterable

var gases: Array[Gas] :
	set(value):
		_collection = value
	get:
		return _collection

# TODO: Change Gases initial moles to be an initial concentration
func _init(g: Array[Gas] = []):
	super._init(g)


## Sets the amount of a specified gas.
func set_moles(gas_type: GlobalTypes.Gases, moles: float = 0.0) -> void:
	assert(moles >= 0, "Moles for %s cannot be negative." % Gases.get_string(gas_type))
	for gas: Gas in gases:
		if gas.gas_type == gas_type:
			gas.moles = moles
			return
	gases.append(Gas.new(gas_type, moles))

func get_moles(gas_type: GlobalTypes.Gases) -> float:
	for gas: Gas in gases:
		if gas.gas_type == gas_type:
			return gas.moles
	return 0.0

func get_all_gases() -> Array[Gas]:
	return gases

static func get_string(gas: GlobalTypes.Gases) -> String:
	return GlobalTypes.Gases.keys()[gas]

func _iter() -> Iterator:
	return Iterator.new(gases)
