extends Node
class_name Vessel


## Represents the current volume of [Blood] that this vessel is holding
var volume: float :
	get:
		if blood:
			return blood.volume
		else:
			return 0.0
## Represents the max volume of [Blood] that this vessel can hold
var max_volume: float = 1.0

## Represents the type of [Vessel] this vessel is
var type: GlobalTypes.Vessels

## Stores the [Blood] that this vessel is currently holding
var blood: Blood

var is_filled: bool = false

## The [Vessels] collection that this vessel delivers [Blood] to
@export var deliver_to: Vessels :
	set(value):
		deliver_to = value

func _init(_vessel_type: GlobalTypes.Vessels, max_volume: float = 1.0) -> void:
	self.type = _vessel_type
	self.max_volume = max_volume
	fill_with_blood()

## Instantiates [Blood] with [member Blood.volume] equal to [member max_volume]
func fill_with_blood()-> void:
	if is_filled: 
		return
	assert(!is_filled, "Blood should only be initialized once")
	var b: Blood = Blood.new(max_volume)
	blood = b
	blood.name = name + "'s Blood"
	is_filled = true

## TODO: Currently does nothing
func send_blood_to_vessel() -> void:
	pass

## Calculates concentration based on moles of [Gas] and [member Blood.volume] in moles/L
func get_concentration(gas: GlobalTypes.Gases) -> float:
	var blood_volume: float = blood.volume
	if blood_volume == 0:
		return 0.0
	var total_moles: float = get_moles(gas)
	return total_moles / blood_volume

## Returns moles of [Gas] contained in [member blood]
func get_moles(gas: GlobalTypes.Gases) -> float:
	return self.blood.get_moles(gas)

## Sets total moles of a gas in the blood of this vessel
func set_moles(gas: GlobalTypes.Gases, moles: float) -> void:
	assert(blood, "Blood should be present")
	self.blood.set_moles(gas, moles)
