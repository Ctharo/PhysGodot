class_name Organs
extends Iterator
## Manages iterable list of [Organ] instances

var organs: Array[Organ] :
	set(value):
		_collection = value
	get:
		return _collection

func _iter() -> Iterator:
	return Iterator.new(organs)

func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	var vessels := Vessels.new()
	for organ in organs:
		for tissue in organ.tissues:
			for vessel in tissue.get_vessels_by_type(vessel_type):
				vessels.add(vessel)
	return vessels

func get_organ_by_type(organ_type: GlobalTypes.Organs) -> Organ:
	for organ in organs:
		if organ.type == organ_type:
			return organ as Organ
	return null

func get_organ_by_name(organ_name: String):
	for organ in organs:
		if organ.name == organ_name:
			return organ
	return null

## Connects supplied source and sink vessels to organs
func connect_vessels_to_organs(source_vessel: Vessel, sink_vessel: Vessel):
	for organ in organs:
		if !organ.connect_vessels_to_tissues(source_vessel, sink_vessel):
			printerr("Failed to connect %s with vessels" % organ.get_string())
			return false
	return true

static func get_string(organ: GlobalTypes.Organs) -> String:
	return GlobalTypes.Organs.keys()[organ]
