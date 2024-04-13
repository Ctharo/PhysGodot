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
	for organ: Organ in organs:
		for tissue: Tissue in organ.tissues:
			for vessel: Vessel in tissue.get_vessels_by_type(vessel_type):
				vessels.add(vessel)
	return vessels

## This assumes there is only going to be 1 organ for each type (reasonable?)
func get_organ_by_type(organ_type: GlobalTypes.Organs) -> Organ:
	for organ: Organ in organs:
		if organ.is_of_type(organ_type):
			return organ as Organ
	return null

## Connects supplied source and sink vessels to organs
func connect_vessels_to_organs(source_vessel: Vessel, sink_vessel: Vessel) -> bool:
	for organ: Organ in organs:
		if !organ.connect_vessels_to_tissues(source_vessel, sink_vessel):
			printerr("Failed to connect %s with vessels" % organ.get_string())
			return false
	return true

func get_count() -> int:
	return organs.size()

static func get_string(organ: GlobalTypes.Organs) -> String:
	return GlobalTypes.Organs.keys()[organ]

static func is_of_type(organ: Organ, type: GlobalTypes.Organs) -> bool:
	return organ.type == type
