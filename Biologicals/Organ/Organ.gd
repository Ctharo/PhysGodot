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

@export var organ_type:String :
	get:
		return Helpers.to_title_case(Organs.get_string(type))

@export var health: float = 1.0:
	set(value):
		health = max(value, 0)
		if health == 0:
			died()

var hypoxic: bool :
	set(value):
		if value and value != hypoxic:
			hypoxia.emit(self)
		hypoxic = value

var hypercapnic: bool :
	set(value):
		if value and value != hypercapnic:
			hypercapnia.emit(self)
		hypercapnic = value

@export var params: TissueParams ## Stores values of normal ranges, physical data, etc.
@export var dead: bool = false
var tissues: Tissues
var type: GlobalTypes.Organs
var debug: bool
var timer: float = 0.0

func _init(Organ_type: GlobalTypes.Organs, params: TissueParams) -> void:
	self.type = Organ_type
	self.params = params
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
	if dead: return
	timer += delta
	if timer > 1:
		check_chemistry()
		timer = 0
	health_check(delta)

## Checks [Organ] status and decreases health accordingly [br]
## TODO: Should probably be done in [Tissue].
func health_check(delta: float) -> void:
	if settings.INVINCIBLE_TISSUES: return
	if hypoxic:
		health -= delta * params.hypoxia_sensitivity * params.health_loss_factor
	if hypercapnic:
		health -= delta * params.hypercapnea_sensitivity * params.health_loss_factor

## Assigns statuses to [Organ] based on [Tissue] statuses
func check_chemistry() -> void:
	hypercapnic = tissues.any(func(tissue: Tissue) -> bool: return tissue.is_concentration_abnormal(GlobalTypes.Gases.CARBON_DIOXIDE))
	hypoxic = tissues.any(func(tissue: Tissue) -> bool: return tissue.is_concentration_abnormal(GlobalTypes.Gases.OXYGEN))

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
	
