class_name Organ
extends Node
## Has a functional role
##
## Physiological processes depend on Organ

signal bad_chemistry_detected
signal hypercapnia
signal hypoxia
signal organ_died

@export var organ_type:String :
	get:
		return Helpers.to_title_case(Organs.get_string(type))

@export var health: float = 1.0:
	set(value):
		health = max(value, 0)
		if health == 0:
			died()


@export var bad_chemistry: bool # TODO: Depreciated? 
var hypoxic: bool :
	set(value):
		if value and value != hypoxic:
			hypoxia.emit(self)
		hypoxic = value
		
var hypercapneic: bool :
	set(value):
		if value and value != hypercapneic:
			hypercapnia.emit(self)
		hypercapneic = value
		
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
	var tissue: Tissue = Tissue.new(self.organ_stats.metabolism_factor, self.organ_stats.vascularity_factor, self.organ_stats.mass)
	tissue.name = self.name + " Tissue"
	add_child(tissue)
	tissues = Tissues.new([tissue] as Array[Tissue])

func _physics_process(delta: float) -> void:
	if dead: return
	timer += delta
	if timer > 1:
		check_chemistry()
		if bad_chemistry:
			health -= timer * organ_stats.metabolism_factor * 20
		timer = 0
		
func check_chemistry() -> void:
	hypercapneic = tissues.any(func(tissue: Tissue) -> bool: return tissue.is_hypercapneic())
	hypoxic = tissues.any(func(tissue: Tissue) -> bool: return tissue.is_hypoxic())

func get_concentration(gas: GlobalTypes.Gases) -> float:
	return tissues.get_concentration(gas)

func get_capillaries() -> Vessels:
	return tissues.get_capillaries()

func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	return tissues.get_vessels_by_type(vessel_type)

func get_all_vessels() -> Vessels:
	return tissues.get_all_vessels()

func set_debug(value: bool) -> void:
	debug = value
	tissues.set_debug(value)

func is_of_type(test_type: GlobalTypes.Organs) -> bool:
	return type == test_type

func died() -> void:
	dead = true
	organ_died.emit(self)
	self.set_physics_process(false)
