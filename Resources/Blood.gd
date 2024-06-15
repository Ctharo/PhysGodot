class_name Blood
extends Resource
##
##
## One [class Blood] is used to simulate the contents of a [class Vessel]

## Stores info about the gases present in the blood
var gases: Gases

var name: String

## The volume of the blood in liters
var volume: float

func _init(_volume: float = 0.5) -> void:
	self.volume = _volume
	_init_gases()

func _init_gases() -> void:
	gases = Gases.new()
	gases.set_moles(GlobalTypes.Gases.OXYGEN, 0.21 * volume)
	gases.set_moles(GlobalTypes.Gases.CARBON_DIOXIDE, 0.045 * volume)

## Uses [method set_moles] to change value to sum of current moles and moles to add
func add_gas(gas: GlobalTypes.Gases, moles: float) -> void:
	var current_moles := gases.get_moles(gas)
	assert(current_moles + moles > 0, "Moles cannot be less than zero")
	set_moles(gas, current_moles + moles)

## Retrieves moles of gas
func get_moles(gas: GlobalTypes.Gases) -> float:
	return gases.get_moles(gas)

## Sets moles of gas
func set_moles(gas: GlobalTypes.Gases, moles: float) -> void:
	gases.set_moles(gas, moles)
