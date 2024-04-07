extends Resource
class_name Vessels
## Iterable collection of Vessel instances with helpful methods

var vessels: Array[Vessel]

func _init(vessels: Array[Vessel] = []):
	self.vessels = vessels

func add_vessel(vessel: Vessel) -> void:
	vessels.append(vessel)

## Returns first [Vessel] that it is found in [member vessels].
func get_capillaries() -> Vessel:
	var capillaries: Vessel
	for vessel in vessels:
		if vessel.type == Vessel.CAPILLARIES:
			capillaries = vessel
			break
	return capillaries

# Making the Vessels class iterable
func _iter() -> Iterator:
	return Iterator.new(vessels)
