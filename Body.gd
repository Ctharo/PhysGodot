extends Node
class_name Body

var _name: String
var organs: Organs

func _init(new_name: String):
	_name = new_name
	print("Body created with name: ", _name)
	
func _ready():
	var brain := Organ.new("Brain")
	var lungs := Organ.new("Lungs")
	var organ_list: Array[Organ] = [brain, lungs]
	organs = Organs.new(organ_list)
	for organ in organs:
		print(organ)

func get_brain():
	return organs.get_organ_by_name("Brain")
	
func get_lungs():
	return organs.get_organ_by_name("Lungs")
	
		
