extends Node
class_name Vessel

@export var _name: String
@export var vessel_type: String
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

## The [Vessels] collection that this vessel delivers [Blood] to
@export var deliver_to: Vessels

### The [Vessels] that this vessel receives [Blood] from TODO: Do we need this?
#@export var receive_from: Vessels

func _init(_vessel_type: GlobalTypes.Vessels, max_volume: float = 1.0) -> void:
	self.type = _vessel_type
	self.max_volume = max_volume
	name = Helpers.to_title_case(Vessels.get_string(self.type))
	_name = name

func fill_with_blood()-> void:
	var b: Blood = Blood.new(max_volume)

	blood = b

##
func send_blood_to_vessel() -> void:
	pass

func get_concentration(gas: GlobalTypes.Gases) -> float:
	var blood_volume: float = blood.volume
	if blood_volume == 0:
		return 0.0
	var total_moles: float = get_moles(gas)
	return total_moles / blood_volume

func get_moles(gas: GlobalTypes.Gases) -> float:
	return self.blood.get_moles(gas)

## Sets total moles of a gas in the blood of this vessel
func set_moles(gas: GlobalTypes.Gases, moles: float) -> void:
	self.blood.set_moles(gas, moles)
