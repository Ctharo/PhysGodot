extends Node
class_name Body


var organs: Organs

func _init(new_name: String):
	name = new_name
	print("Body created with name: ", name)

func _ready():

	# Create Brain
	var brain := Organ.new("Brain")
	add_child(brain)

	# Create Lungs
	var lungs := Organ.new("Lungs")
	add_child(lungs)

	# Create Organs resource
	var organ_list: Array[Organ] = [brain, lungs]

	organs = Organs.new(organ_list)
	#organs.name = "Organs"
	#add_child(organs)

	# Debugging
	for organ in organs:
		print(organ)

func get_brain():
	return organs.get_organ_by_name("Brain")

func get_lungs():
	return organs.get_organ_by_name("Lungs")


