class_name Gas
extends Resource

@export var name: String
@export var moles: float

var gas_type: GlobalTypes.Gases



func _init(type: GlobalTypes.Gases, initial_moles: float = 0.0) -> void:
	gas_type = type
	moles = initial_moles
	name = Helpers.to_title_case(Gases.get_string(type))
