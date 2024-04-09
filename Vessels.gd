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

## Returns [Vessels] of [Vessel] with [member Vessel.type] == [member Vessel.CAPILLIARIES].
func get_capillaries() -> Vessels:
	return get_vessels_by_type(GlobalTypes.Vessels.CAPILLARIES)

# Making the Vessels class iterable
func _iter() -> Iterator:
	return Iterator.new(vessels)

static func get_string(vessel: GlobalTypes.Vessels) -> String:
	return GlobalTypes.Vessels.keys()[vessel]
