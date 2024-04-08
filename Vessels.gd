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

func add(vessel: Vessel) -> void:
	vessels.append(vessel)

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
