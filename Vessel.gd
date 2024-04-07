extends Node
class_name Vessel

const VEIN: String = "Vein"
const CAPILLARIES: String = "Capillaries"
const ARTERY: String = "Artery"

var type: String

func set_type(type: String):
	if type == null:
		push_error("Cannot set null type for vessel")
		return
	self.type = type


