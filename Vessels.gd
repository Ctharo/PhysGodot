extends Iterator
class_name Vessels
## Iterable collection of Vessel instances with helpful methods

var vessels: Array[Vessel]

func _init(vessels: Array[Vessel] = []):
	super._init(vessels)
	self.vessels = vessels

func add_vessel(vessel: Vessel) -> void:
	vessels.append(vessel)

## Returns [Vessels] of [Vessel] with [member Vessel.type] == [member Vessel.CAPILLIARIES].
func get_capillaries() -> Vessels:
	var capillaries := Vessels.new()
	for vessel in vessels:
		if vessel.type == Vessel.CAPILLARIES:
			capillaries.add(vessel)
	return capillaries

# Making the Vessels class iterable
func _iter() -> Iterator:
	return Iterator.new(vessels)

