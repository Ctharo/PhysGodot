class_name Organ
extends Node
## Has a functional role
##
## Physiological processes depend on Organ

var tissues: Tissues
var type: GlobalTypes.Organs

func _init(organ_type: GlobalTypes.Organs):
	self.type = organ_type
	name = to_title_case(get_string())
	init_tissues()

func init_tissues():
	var tissue: Tissue = Tissue.new()
	tissue.name = self.name + " Tissue"
	add_child(tissue)

	tissues = Tissues.new([tissue] as Array[Tissue])

func _physics_process(_delta):
	# TODO: Should be responsible to run organ system specific processes 
	# (i.e., heart beat, respiration, intracellular exchanges, etc.)
	pass



func get_capillaries() -> Vessels:
	return tissues.get_capillaries()

func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	return tissues.get_vessels_by_type(vessel_type)

func get_all_vessels() -> Vessels:
	return tissues.get_all_vessels()

func connect_vessels_to_tissues(to_vessel: Vessel, from_vessel: Vessel):
	for tissue in tissues:
		if !tissue.connect_vessels_to_tissue(to_vessel, from_vessel):
			return false
	return true

func get_string() -> String:
	return GlobalTypes.Organs.keys()[type]

func to_title_case(s: String) -> String:
	# Split the string into words based on spaces
	var words = s.split(" ")

	# Capitalize the first letter of each word
	for i in range(words.size()):
		words[i] = words[i].capitalize()

	# Join the words back into a single string with spaces
	return " ".join(words)
