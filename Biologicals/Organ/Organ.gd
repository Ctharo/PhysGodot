class_name Organ
extends Cacheable
## Has a functional role
##
## Physiological processes depend on Organ

signal organ_died ## Emitted if all [member Tissue.health] values are zero

var settings: Settings = load("res://Settings.tres") as Settings

@export var organ_type: String :
	get:
		return Helpers.to_title_case(Organs.get_string(type))

## Returns mean value of all tissue health
@export var health: float :
	get:
		var value: float = get_cached_value("health", self.tissues.get_mean_health)
		if value == 0.0 and not dead:
			died()
		return value

@export var mass: float :
	get:
		return get_cached_value("mass", self.tissues.total_mass)

@export var _params: TissueParams ## Stores values of normal ranges, physical data, etc.
#@export var status: Status ## Custom iterator object to contain status values
## Returns true if mean health of tissues is zero
@export var dead: bool

@export var is_hypoxic: bool :
	get:
<<<<<<< Updated upstream
		return get_cached_value("is_hypoxic", self._is_hypoxic, false, 1.0)
		
@export var is_hypercapnic: bool :
	get:
		return get_cached_value("is_hypercapnic", self._is_hypercapnic, false, 1.0)
=======
		return self._is_hypoxic()

@export var is_hypercapnic: bool :
	get:
		return self._is_hypercapnic()
>>>>>>> Stashed changes

var min_concentration: Dictionary :
	get:
		return get_params().min_concentration
<<<<<<< Updated upstream
	
=======

>>>>>>> Stashed changes
var max_concentration: Dictionary :
	get:
		return get_params().max_concentration

var tissues: Tissues
var type: GlobalTypes.Organs
var debug: bool
var timer: float = 0.0

func _init(Organ_type: GlobalTypes.Organs, params: TissueParams) -> void:
	self.type = Organ_type
	self._params = params
	#self.status = Status.new(self.params)

	name = Helpers.to_title_case(Organs.get_string(type))
	_init_tissues()

func _init_tissues() -> void:
	var tissue_count: int = get_params().tissue_count # For dividing total organ mass by number of tissues. FIXME: Assumes equally-sized tissues.
	assert(tissue_count != 0)
	assert(get_params().metabolism_factor > 0, "metabolism_factor needs to be greater than zero to work")
	for i in tissue_count:
		_add_tissue(_determine_tissue_params())
	assert(tissues)
	tissues.name = self.name + "'s Tissues"

func _physics_process(_delta: float) -> void:
	if dead:
		return


## Creates a new [Tissue] and adds it to [member tissues]
func _add_tissue(params: TissueParams) -> void:
	if not tissues:
		var a: Array[Tissue] = []
		tissues = Tissues.new(a)
	var tissue: Tissue = Tissue.new(params)
	assert(tissue)
	tissue.name = self.name + " Tissue %s" % (tissues.size() + 1)
	tissue.health_changed.connect(_on_tissue_health_changed)
	add_child(tissue)
	tissues.add(tissue)
	invalidate_all_cache()

## From the [Organ]'s parameters, the [Tissue]'s will be generated
func _determine_tissue_params() -> TissueParams:
	var tissue_count: int = get_params().tissue_count
	assert(tissue_count)
	var tissue_params: TissueParams = get_params().duplicate(true) ## Copy params, but change relavent data such as mass, blood volume, etc.
	assert(tissue_params)

	# Total Organ mass is divided amongst tissues
	tissue_params.mass = get_params().mass / tissue_count

	# Total Organ blood volume is divided amongst tissues
	tissue_params.blood_volume = get_params().blood_volume / tissue_count

	return tissue_params

func get_params() -> TissueParams:
	return params

## Signal handler for when any tissue's health changes
func _on_tissue_health_changed() -> void:
	invalidate_cache("health")

func get_params() -> TissueParams:
	return _params

## Returns bool if arg is same value as [member type]. Uses [method Organs.is_of_type]
func is_of_type(test_type: GlobalTypes.Organs) -> bool:
	return Organs.is_of_type(self, test_type)

## Called from [method check_health] when [member health] is zero
func died() -> void:
	assert(tissues.all_dead(), "All tissues should be dead")
	dead = true
	organ_died.emit(self)

#region [member tissues] helper methods
<<<<<<< Updated upstream
func get_concentration(gas: GlobalTypes.Gases, force_update: bool = false) -> float:
	return get_cached_value("concentration_%s" % gas, Callable(tissues.get_concentration).bind(gas), force_update, 0.016)
	
=======
func get_concentration(gas: GlobalTypes.Gases) -> float:
	return get_cached_value("concentration_%s" % gas, Callable(tissues.get_concentration).bind(gas), 0.2)

>>>>>>> Stashed changes
func set_concentration(gas: GlobalTypes.Gases, concentration: float) -> void:
	tissues.set_concentration(gas, concentration)

func set_health(health_value: float) -> void:
	tissues.set_health(health_value)

func get_capillaries() -> Vessels:
	return tissues.get_capillaries()

func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	return tissues.get_vessels_by_type(vessel_type)

func get_all_vessels() -> Vessels:
	return tissues.get_all_vessels()
#endregion

func _is_hypoxic() -> bool:
<<<<<<< Updated upstream
	return tissues.any_hypoxic()
		
=======
	return tissues.get_concentration(GlobalTypes.Gases.OXYGEN) < min_concentration[GlobalTypes.Gases.OXYGEN]

>>>>>>> Stashed changes
func _is_hypercapnic() -> bool:
	return tissues.any_hypercapnic()

