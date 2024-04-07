extends Node
class_name Organ

var tissues: Tissues = Tissues.new()

func get_capillaries() -> Vessels:
	return tissues.get_capillaries()
