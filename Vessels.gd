extends Iterator
class_name Vessels
## Iterable collection of Vessel instances with helpful methods

var vessels: Array[Vessel] :
	set(value):
		_collection = value
	get:
		return _collection

func _init(v: Array[Vessel] = []):
	super._init(v)
	fill_vessels_with_blood()

func add(vessel: Vessel) -> void:
	vessels.append(vessel)

func fill_vessels_with_blood() -> void:
	for vessel in vessels:
		var current_volume: float = 0.0
		while current_volume < vessel.volume:
			var blood: Blood = Blood.new()
			vessel.blood.append(blood)
			current_volume += blood.volume

func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	var _vessels:= Vessels.new()
	for vessel in vessels:
		if vessel.type == vessel_type:
			_vessels.add(vessel)
	return _vessels

func get_concentration(gas: GlobalTypes.Gases) -> float:
	var total_volume: float = get_volume()
	if total_volume == 0:
		return 0.0
	var total_moles: float = get_moles(gas)
	return total_moles / total_volume

func get_moles(gas: GlobalTypes.Gases) -> float:
	var total_moles: float = 0.0
	for vessel in vessels:
		total_moles += vessel.get_moles(gas)
	return total_moles

func get_volume() -> float:
	var total_volume: float = 0.0
	for vessel in vessels:
		total_volume += vessel.current_volume()
	return total_volume

## Returns [Vessels] of [Vessel] with [member Vessel.type] == [member Vessel.CAPILLIARIES].
func get_capillaries() -> Vessels:
	return get_vessels_by_type(GlobalTypes.Vessels.CAPILLARIES)

# Making the Vessels class iterable
func _iter() -> Iterator:
	return Iterator.new(vessels)

static func get_string(vessel: GlobalTypes.Vessels) -> String:
	return GlobalTypes.Vessels.keys()[vessel]

func exchange_gas(gas: GlobalTypes.Gases, moles: float):
	var total_volume: float = get_volume()
	if total_volume == 0:
		printerr("Total volume of all vessels is zero")
	var concentration = moles/total_volume
	for vessel in vessels:
		var moles_for_vessel: float = concentration * vessel.current_volume()
		var final_moles_for_vessel: float = moles_for_vessel + vessel.get_moles(gas)
		vessel.set_moles(gas, final_moles_for_vessel)

