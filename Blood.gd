class_name Blood
extends Resource
##
##
##

## Stores info about the gases present in the blood
var gases: Gases

## The volume of the blood in liters
var volume: float = 0.01

func _init():
	gases = Gases.new(0.2, 0.0)

func exchange_gas(gas: GlobalTypes.Gases, moles: float):
	var current_moles := gases.get_moles(gas)
	assert(current_moles + moles > 0, "Moles cannot be less than zero")
	set_moles(gas, current_moles + moles)

func get_moles(gas: GlobalTypes.Gases) -> float:
	return gases.get_moles(gas)

func set_moles(gas: GlobalTypes.Gases, moles: float):
	gases.set_moles(gas, moles)
