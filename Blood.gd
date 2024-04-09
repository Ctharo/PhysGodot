class_name Blood
extends Resource
## TODO: Blood should be a resource as its just data containers and don't need to be added to the scene tree
var gases: Gases
var volume: float = 0.01

func _init():
	gases = Gases.new()


func exchange_gas(gas: GlobalTypes.Gases, amount: float):
	var current_moles := gases.get_moles(gas)
	assert(current_moles + amount > 0, "Moles cannot be less than zero")
	gases.set_moles(gas, current_moles + amount)

