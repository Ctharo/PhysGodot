class_name Organ
extends Node
## Has a functional role
##
## Physiological processes depend on Organ

signal on_bad_chemistry
signal on_died

@export var organ_type:String :
	get:
		return Helpers.to_title_case(Organs.get_string(type))

@export var health: float = 1.0:
	set(value):
		health = max(value, 0)
		if health == 0:
			died()

@export var bad_chemistry: bool :
	get:
		var r: bool = false
		for tissue: Tissue in tissues:
			if tissues.get_concentration(GlobalTypes.Gases.OXYGEN) < 0.07 or tissues.get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE) > 0.1:
				r = true
		return r

@export var organ_stats: OrganStats
@export var dead: bool = false
var tissues: Tissues
var type: GlobalTypes.Organs
var debug: bool
var timer: float = 0.0

func _init(Organ_type: GlobalTypes.Organs, stats: OrganStats) -> void:
	self.type = Organ_type
	self.organ_stats = stats
	name = Helpers.to_title_case(Organs.get_string(type))
	init_tissues()

func init_tissues() -> void:
	# TODO: Should divide total mass among tissues if instancing more than 1.
	assert(self.organ_stats.metabolism_factor > 0, "metabolism_factor needs to be greater than zero to work")
	var tissue: Tissue = Tissue.new(self.organ_stats.metabolism_factor, self.organ_stats.mass)
	tissue.name = self.name + " Tissue"
	add_child(tissue)
	tissues = Tissues.new([tissue] as Array[Tissue])

func _physics_process(delta: float) -> void:
	if dead:
		return
	timer += delta
	if timer > 1:
		if bad_chemistry:
			health -= timer * organ_stats.metabolism_factor * 20
		timer = 0

func get_concentration(gas: GlobalTypes.Gases) -> float:
	return tissues.get_concentration(gas)

func get_capillaries() -> Vessels:
	return tissues.get_capillaries()

func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	return tissues.get_vessels_by_type(vessel_type)

func get_all_vessels() -> Vessels:
	return tissues.get_all_vessels()

## Connects all tissues to source and sink vessels
func connect_vessels_to_tissues(source_vessel: Vessel, sink_vessel: Vessel) -> bool:
	for tissue: Tissue in tissues:
		if !tissue.connect_vessels_to_tissue(source_vessel, sink_vessel):
			return false
	return true

func set_debug(value: bool) -> void:
	debug = value
	tissues.set_debug(value)

func is_of_type(test_type: GlobalTypes.Organs) -> bool:
	return type == test_type

func died() -> void:
	dead = true
	on_died.emit(self)
	self.set_physics_process(false)
