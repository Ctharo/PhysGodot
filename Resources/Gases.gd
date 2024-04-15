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
func _init(g: Array[Gas] = []) -> void:
	super._init(g)
	_init_gases()

func _init_gases() -> void:
	var oxygen_stats: GasStats = load("res://Resources/GasStats/OxygenStats.tres") as GasStats
	var o2: Gas = Gas.new(GlobalTypes.Gases.OXYGEN, oxygen_stats)
	var carbon_dioxide_stats: GasStats = load("res://Resources/GasStats/CarbonDioxideStats.tres") as GasStats
	var co2: Gas = Gas.new(GlobalTypes.Gases.CARBON_DIOXIDE, carbon_dioxide_stats)
	gases = [o2, co2] as Array[Gas]

## Sets the amount of a specified gas.
func set_moles(gas_type: GlobalTypes.Gases, moles: float = 0.0) -> void:
	assert(moles >= 0, "Moles for %s cannot be negative." % Gases.get_string(gas_type))
	for gas: Gas in gases:
		if gas.gas_type == gas_type:
			gas.moles = moles
			return
	printerr("Cannot set moles for gas: Gas not found")

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
