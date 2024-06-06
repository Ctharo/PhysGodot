class_name Gases
extends Iterator
## Represents a collection of gases and their details.
##
## Contains helpful methods for managing [Gas] instances

@export var oxygen_params: GasParams = preload("res://Resources/Params/GasParams/OxygenParams.tres") as GasParams
@export var carbon_dioxide_params: GasParams = preload("res://Resources/Params/GasParams/CarbonDioxideParams.tres") as GasParams

# TODO: Change Gases initial moles to be an initial concentration
func _init(g: Array[Gas] = []) -> void:
	super._init(g)
	_init_gases()

func _init_gases() -> void:
	var o2: Gas = Gas.new(GlobalTypes.Gases.OXYGEN, oxygen_params)
	var co2: Gas = Gas.new(GlobalTypes.Gases.CARBON_DIOXIDE, carbon_dioxide_params)
	elements = [o2, co2] as Array[Gas]

## Sets the amount of a specified gas
func set_moles(gas_type: GlobalTypes.Gases, moles: float = 0.0) -> void:
	assert(moles >= 0, "Moles for %s cannot be negative." % Gases.get_string(gas_type))
	for gas: Gas in elements:
		if gas.gas_type == gas_type:
			gas.moles = moles
			return
	printerr("Cannot set moles for gas: Gas not found")

func get_moles(gas_type: GlobalTypes.Gases) -> float:
	for gas: Gas in elements:
		if gas.gas_type == gas_type:
			return gas.moles
	return 0.0

static func get_string(gas: GlobalTypes.Gases) -> String:
	return GlobalTypes.Gases.keys()[gas]

