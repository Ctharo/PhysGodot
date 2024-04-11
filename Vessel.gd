extends Node
class_name Vessel

@export var _name: String

## Represents the volume of [Blood] that this vessel can hold
var volume: float

## Represents the type of [Vessel] this vessel is
var type: GlobalTypes.Vessels

## Stores the [Blood] that this vessel is currently holding
var blood: Array[Blood] = []

## The [Vessel] that this vessel delivers [Blood] to
@export var deliver_to: Vessel

## The [Vessel] that this vessel receives [Blood] from TODO: Do we need this?
@export var receive_from: Vessel

func _init(vessel_type: GlobalTypes.Vessels, _volume: float = 1.0):
	self.type = vessel_type
	self.volume = _volume
	name = Helpers.to_title_case(Vessels.get_string(vessel_type))
	_name = name

## Returns the current volume of blood in this vessel
func current_volume() -> float:
	# Use Array sum method
	var v: float = 0.0
	for b in self.blood:
		v += b.volume
	return v

##
func send_blood_to_vessel(v: float) -> void:
	if self.blood.size() == 0 or current_volume() < v:
		return

func get_concentration(gas: GlobalTypes.Gases) -> float:
	var total_volume: float = current_volume()
	if total_volume == 0:
		return 0.0
	var total_moles: float = get_moles(gas)
	return total_moles / total_volume

func get_moles(gas: GlobalTypes.Gases) -> float:
	var total_moles: float = 0.0
	for b in self.blood:
		total_moles += b.get_moles(gas)
	return total_moles

## Sets total moles of a gas in the blood of this vessel
func set_moles(gas: GlobalTypes.Gases, moles: float):
	var blood_volume: float = current_volume()
	if blood_volume == 0:
		printerr("Problem setting gas moles in blood - vessel has no volume")
		return
	var concentration = moles/blood_volume
	for b in blood:
		var moles_for_blood: float = concentration * b.volume
		# First ensure we aren't trying to remove more moles than what is available.
		assert(b.get_moles(gas) + moles_for_blood >= 0, "Moles cannot be negative")
		b.set_moles(gas, moles_for_blood)
