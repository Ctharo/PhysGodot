class_name Organ
extends Node
## Has a functional role
##
## Physiological processes depend on Organ

signal bad_chemistry_detected
signal hypercapnia
signal hypoxia
signal organ_died

var settings: Settings = load("res://Settings.tres") as Settings

@export var organ_type: String :
	get:
		return Helpers.to_title_case(Organs.get_string(type))

## Returns mean value of all tissue health
@export var health: float :
	get:
		return tissues.get_mean_health()

@export var params: TissueParams ## Stores values of normal ranges, physical data, etc.
@export var status: Status
## Returns true if mean health of tissues is zero
@export var dead: bool :
	get:
		return tissues.get_mean_health() == 0
var tissues: Tissues
var type: GlobalTypes.Organs
var debug: bool
var timer: float = 0.0

func _init(Organ_type: GlobalTypes.Organs, params: TissueParams) -> void:
	self.type = Organ_type
	self.params = params
	self.status = Status.new(self.params)

	name = Helpers.to_title_case(Organs.get_string(type))
	init_tissues()

func init_tissues() -> void:
	var tissue_count: int = self.params.tissue_count # For dividing total organ mass by number of tissues. FIXME: Assumes equally-sized tissues.
	assert(self.params.metabolism_factor > 0, "metabolism_factor needs to be greater than zero to work")
	var a: Array[Tissue] = [] as Array[Tissue]
	var tissue_params: TissueParams = self.params.duplicate(true) ## Copy params, but change relavent data such as mass, blood volume, etc.
	tissue_params.mass = self.params.mass / tissue_count
	tissue_params.blood_volume = self.params.blood_volume / tissue_count
	for i in tissue_count:
		var tissue: Tissue = Tissue.new(tissue_params)
		tissue.name = self.name + " Tissue %s" % (i + 1)
		add_child(tissue)
		a.append(tissue)
	tissues = Tissues.new(a)
	
func _physics_process(delta: float) -> void:
	if dead: 
		died()
		return
	timer += delta

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
	organ_died.emit(self)
	self.set_physics_process(false)
	
func is_hypoxic() -> bool:
	return tissues.any(func(tissue: Tissue) -> bool: return tissue.is_hypoxic())
	
func is_hypercapnic() -> bool:
	return tissues.any(func(tissue: Tissue) -> bool: return tissue.is_hypercapnic())
