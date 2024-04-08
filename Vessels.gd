extends Iterator
class_name Vessels
## Iterable collection of Vessel instances with helpful methods

var vessels: Array[Vessel] :
	set(value):
		_collection = value
	get:
		return _collection

## Returns [Vessels] of [Vessel] with [member Vessel.type] == [member Vessel.CAPILLIARIES].
func get_capillaries() -> Vessels:
	var capillaries := Vessels.new()
	for vessel in vessels:
		if vessel.type == GlobalTypes.Vessels.CAPILLARIES:
			capillaries.add(vessel)
	return capillaries

# Making the Vessels class iterable
func _iter() -> Iterator:
	return Iterator.new(vessels)

static func get_string(vessel: GlobalTypes.Vessels) -> String:
	return GlobalTypes.Vessels.keys()[vessel]
