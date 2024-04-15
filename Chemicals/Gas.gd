class_name Gas
extends Resource

@export var name: String
@export var moles: float
@export var gas_stats: GasStats

var gas_type: GlobalTypes.Gases



func _init(type: GlobalTypes.Gases, stats: GasStats, initial_moles: float = 0.0) -> void:
	gas_type = type
	gas_stats = stats
	moles = initial_moles
	name = Helpers.to_title_case(Gases.get_string(type))

func set_moles(moles: float) -> void:
	self.moles = moles

func set_solubility(solubility: float) -> void:
	if not gas_stats:
		printerr("Cannot edit solubility for %s: stats not found" % name)
	gas_stats.solubility = solubility

func get_solubility() -> float:
	if not gas_stats:
		printerr("Cannot get solubility for %s: stats not found" % name)
	return gas_stats.solubility
