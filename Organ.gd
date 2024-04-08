extends Node
class_name Organ


var tissues: Tissues

func _init(organ_name: String):
	var tissue: Tissue = Tissue.new()
	name = organ_name
	tissue.name = organ_name + " Tissue"
	add_child(tissue)

	tissues = Tissues.new([tissue] as Array[Tissue])
	#tissues.name = "Tissues"
	#add_child(tissues)


func get_capillaries() -> Vessels:
	return tissues.get_capillaries()

