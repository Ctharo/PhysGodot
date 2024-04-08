extends Node
class_name Body


var organs: Organs

func _init(new_name: String):
	name = new_name
	print("Body created with name: ", name)

func _ready():

	# Create Brain
	var brain := Organ.new(GlobalTypes.Organs.BRAIN)
	add_child(brain)

	# Create Lungs
	var lungs := Organ.new(GlobalTypes.Organs.LUNGS)
	add_child(lungs)

	# Create Organs resource
	organs = Organs.new([brain, lungs] as Array[Organ])


	# Debugging
	var organ = organs.get_organ_by_type(GlobalTypes.Organs.BRAIN)
	print(organ)
	for vessel in organ.get_vessels_by_type(GlobalTypes.Vessels.VEIN):
		print(vessel)

func get_brain():
	return organs.get_organ_by_name("Brain")

func get_lungs():
	return organs.get_organ_by_name("Lungs")


