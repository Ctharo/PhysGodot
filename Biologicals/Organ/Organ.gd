class_name Organ
extends Node
## Has a functional role
##
## Physiological processes depend on Organ

signal bad_chemistry_detected ## Not sure if will use, too general
signal hypercapnia ## Emitted if [enum GlobalTypes.Gases.CARBON_DIOXIDE] concentration in the [Tissue]s are higher than [member params.max_concentration]
signal hypoxia ## Emitted if [enum GlobalTypes.Gases.OXYGEN] concentration in the [Tissue]s are lower than [member params.min_concentration]
signal organ_died ## Emitted if all [member Tissue.health] values are zero

var settings: Settings = load("res://Settings.tres") as Settings

@export var organ_type: String :
	get:
		return Helpers.to_title_case(Organs.get_string(type))

## Returns mean value of all tissue health
@export var health: float

@export var params: TissueParams ## Stores values of normal ranges, physical data, etc.
@export var status: Status ## Custom iterator object to contain status values
## Returns true if mean health of tissues is zero
@export var dead: bool
var tissues: Tissues
var type: GlobalTypes.Organs
var debug: bool
var timer: float = 0.0

func _init(Organ_type: GlobalTypes.Organs, params: TissueParams) -> void:
	self.type = Organ_type
	self.params = params
	self.status = Status.new(self.params)

	name = Helpers.to_title_case(Organs.get_string(type))
	_init_tissues()

func _init_tissues() -> void:
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
		return
	timer += delta
	if timer > 1:
		check_health()
		timer = 0.0

## Called from [method _physics_process] and handles setting [member health] and calling [method died] if necessary
func check_health() -> void:
	health = tissues.get_mean_health()
	if health == 0.0:
		died()

## Depreciated? Might not use.
func set_debug(value: bool) -> void:
	debug = value
	tissues.set_debug(value)

## Returns bool if arg is same value as [member type]. Uses [method Organs.is_of_type]
func is_of_type(test_type: GlobalTypes.Organs) -> bool:
	return Organs.is_of_type(self, test_type)

## Called from [method check_health] when [member health] is zero
func died() -> void:
	dead = true
	organ_died.emit(self)
	self.set_physics_process(false)

## HACK: Should instead be responding to mean o2 concentration
func is_hypoxic() -> bool:
	var val: float = params.min_concentration[GlobalTypes.Gases.OXYGEN]
	return get_concentration(GlobalTypes.Gases.OXYGEN) < val

## HACK: Should instead be responding to mean co2 concentration
func is_hypercapnic() -> bool:
	var val: float = params.max_concentration[GlobalTypes.Gases.CARBON_DIOXIDE]
	return get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE) > val

#region [member tissues] helper methods
func get_concentration(gas: GlobalTypes.Gases) -> float:
	return tissues.get_concentration(gas)

func get_capillaries() -> Vessels:
	return tissues.get_capillaries()

func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	return tissues.get_vessels_by_type(vessel_type)

func get_all_vessels() -> Vessels:
	return tissues.get_all_vessels()
#endregion
