class_name Gas
extends Resource

@export var name: String
@export var moles: float
@export var params: GasParams

var gas_type: GlobalTypes.Gases

func _init(type: GlobalTypes.Gases, stats: GasParams, initial_moles: float = 0.0) -> void:
	gas_type = type
	params = stats
	moles = initial_moles
	name = Helpers.to_title_case(Gases.get_string(type))

func set_moles(moles: float) -> void:
	self.moles = max(moles, 0)

func set_solubility(solubility: float) -> void:
	if not params:
		printerr("Cannot edit solubility for %s: stats not found" % name)
	params.solubility = solubility

func get_solubility() -> float:
	if not params:
		printerr("Cannot get solubility for %s: stats not found" % name)
	return params.solubility
