extends Node
class_name Organ

var _name: String
var tissues: Tissues = Tissues.new()

func _init(organ_name: String):
	_name = organ_name
	var tissue: Tissue = Tissue.new()
	tissues.add_tissue(tissue)
	
func get_capillaries() -> Vessels:
	return tissues.get_capillaries()

