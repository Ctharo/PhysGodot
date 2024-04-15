class_name Blood
extends Resource
##
##
## One [class Blood] is used to simulate the contents of a [class Vessel]

## Stores info about the gases present in the blood
var gases: Gases

## The volume of the blood in liters
var volume: float

func _init(_volume: float = 0.5) -> void:
	self.volume = _volume
	_init_gases()

func _init_gases() -> void:
	gases = Gases.new()
	gases.set_moles(GlobalTypes.Gases.OXYGEN, 0.21 * volume)
	gases.set_moles(GlobalTypes.Gases.CARBON_DIOXIDE, 0.05 * volume)

func exchange_gas(gas: GlobalTypes.Gases, moles: float) -> void:
	var current_moles := gases.get_moles(gas)
	assert(current_moles + moles > 0, "Moles cannot be less than zero")
	set_moles(gas, current_moles + moles)

func get_moles(gas: GlobalTypes.Gases) -> float:
	return gases.get_moles(gas)

func set_moles(gas: GlobalTypes.Gases, moles: float) -> void:
	gases.set_moles(gas, moles)
