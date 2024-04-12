extends Node
class_name Body
##
##
## TODO: Should handle Blood movement from aorta to tissues and from tissues to vena_cava

@export var organs: Organs
@export var vessels: Vessels

func _init(new_name: String):
	name = new_name
	# Print the name of the body in a formatted string
	print("Body '%s' initialized" % name)

func _ready():
	# Create Brain
	var brain := Organ.new(GlobalTypes.Organs.BRAIN)
	add_child(brain)

	# Create Lungs
	var lungs := Organ.new(GlobalTypes.Organs.LUNGS)
	add_child(lungs)

	# Create Organs resource
	organs = Organs.new([brain, lungs] as Array[Organ])

	# Create Vessels resource
	vessels = Vessels.new()

	# Create Vessels
	var aorta := Vessel.new(GlobalTypes.Vessels.AORTA)
	add_child(aorta)
	vessels.add(aorta)

	var pulmonary_artery := Vessel.new(GlobalTypes.Vessels.PULMONARY_ARTERY)
	add_child(pulmonary_artery)
	vessels.add(pulmonary_artery)

	var pulmonary_vein := Vessel.new(GlobalTypes.Vessels.PULMONARY_VEIN)
	add_child(pulmonary_vein)
	vessels.add(pulmonary_vein)

	var vena_cava := Vessel.new(GlobalTypes.Vessels.VENA_CAVA)
	add_child(vena_cava)
	vessels.add(vena_cava)

	# Connect all tissues to body vessels
	if !organs.connect_vessels_to_organs(aorta, vena_cava):
		printerr("Problem connecting vessels")

	print("%s has been created successfully" % name)

	brain.set_debug(true)
	lungs.set_debug(true)

## TODO: Not sure what this should be used for yet
func _physics_process(_delta):
	pass

func get_brain():
	return _get_organ(GlobalTypes.Organs.BRAIN)

func get_lungs():
	return _get_organ(GlobalTypes.Organs.LUNGS)

func _get_organ(organ_type: GlobalTypes.Organs) -> Organ:
	return organs.get_organ_by_type(organ_type)

