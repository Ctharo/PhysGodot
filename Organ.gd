class_name Organ
extends Node
## Has a functional role
##
## Physiological processes depend on Organ

@export var organ_type:String : 
	get:
		return to_title_case(get_string())

@export var health: float = 1.0

var tissues: Tissues
var type: GlobalTypes.Organs



var debug: bool
var timer: float = 0.0


func _init(organ_type: GlobalTypes.Organs):
	self.type = organ_type
	name = to_title_case(get_string())
	init_tissues()

func init_tissues():
	var tissue: Tissue = Tissue.new()
	tissue.name = self.name + " Tissue"
	add_child(tissue)

	tissues = Tissues.new([tissue] as Array[Tissue])

func _physics_process(delta):
	timer += delta
	if timer > 1:
		for tissue in tissues:
			if tissue.get_concentration(GlobalTypes.Gases.OXYGEN) < 0.05:
				if debug: print("Organ " + name + " is not getting enough oxygen")
				health -= 0.01 * timer
			if tissue.get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE) > 0.1:
				if debug: print("Organ " + name + " is not removing enough CO2")
				health -= 0.1 * timer
	if health <= 0:
		print("Organ " + name + " has died")
		self.set_physics_process(false)
	timer = 0


func get_capillaries() -> Vessels:
	return tissues.get_capillaries()

func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	return tissues.get_vessels_by_type(vessel_type)

func get_all_vessels() -> Vessels:
	return tissues.get_all_vessels()

## Connects all tissues to source and sink vessels
func connect_vessels_to_tissues(source_vessel: Vessel, sink_vessel: Vessel):
	for tissue in tissues:
		if !tissue.connect_vessels_to_tissue(source_vessel, sink_vessel):
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

func set_debug(value: bool):
	debug = value
	tissues.set_debug(value)
