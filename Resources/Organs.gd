class_name Organs
extends Iterator
## Custom container class for [Organ] instances
##
## Custom container class for [Organ] instances

## Contains [Organ] instances for the [Body]
var organs: Array[Organ] :
	set(value):
		_collection = value as Array[Organ]
	get:
		return _collection as Array[Organ]

func _iter() -> Iterator:
	return Iterator.new(organs)

## Returns all [Tissue]s found in [member Tissue.vessels]
func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	var vessels := Vessels.new()
	for organ: Organ in organs:
		for vessel: Vessel in organ.get_vessels_by_type(vessel_type) as Vessels:
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
	# Set AORTA to deliver to all Artery
	source_vessel.deliver_to = get_vessels_by_type(GlobalTypes.Vessels.ARTERY)
	# Set all veins to deliver to VENA_CAVA
	for vessel: Vessel in get_vessels_by_type(GlobalTypes.Vessels.VEIN) as Vessels:
		vessel.deliver_to = Vessels.new([sink_vessel] as Array[Vessel])
	return true

## Returns organ count
func get_count() -> int:
	return organs.size()

## Static method to retrieve a String name of an organ
static func get_string(organ: GlobalTypes.Organs) -> String:
	return GlobalTypes.Organs.keys()[organ]

## Compares [Organ] types
static func is_of_type(organ: Organ, type: GlobalTypes.Organs) -> bool:
	return organ.type == type
