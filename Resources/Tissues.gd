class_name Tissues
extends Iterator
## Iterable class that contains Tissue instances and helpful methods.
##
## No methods should use or rely on cached values, only pure calculations here (except mass, which 
## doesn't change regularly)
var _is_mass_dirty: bool = true
var _mass: float
var mass: float :
	get:
		if not _is_mass_dirty:
			return _mass
		var total: float = 0.0
		for tissue: Tissue in elements as Array[Tissue]:
			total += tissue.mass
		_mass = total
		_is_mass_dirty = false
		return _mass
		
func _init(t: Array[Tissue] = [] as Array[Tissue]) -> void:
	super._init(t)

## Returns float of sum of moles of provided [param gas]: [Gas]
func get_moles(gas: GlobalTypes.Gases) -> float:
	var moles: float = 0.0
	for tissue: Tissue in elements as Array[Tissue]:
		moles += tissue.get_moles(gas)
	return moles
	
func add(tissue: Variant) -> void:
	_is_mass_dirty = true
	super.add(tissue)

## Returns float of sum of moles of provided [param gas] divided by [method total_mass] return value.
func get_concentration(gas: GlobalTypes.Gases) -> float:
	#Benchmarker.increment_call_count("get_concentration")
	if mass == 0.0:
		return 0.0
	return get_moles(gas)/mass

## Sets concentration of a [Gas] to all [Tissue]s
func set_concentration(gas: GlobalTypes.Gases, concentration: float) -> void:
	for tissue: Tissue in elements as Array[Tissue]:
		tissue.set_concentration(gas, concentration)

## Sets health of all [Tissue]s
func set_health(health_value: float) -> void:
	for tissue: Tissue in elements as Array[Tissue]:
		tissue.health = health_value

## Returns true if all tissues are dead
func all_dead() -> bool:
	return elements.all(func(tissue: Tissue) -> bool: return tissue.dead)

## Returns [Vessels] of type [enum GlobalTypes.Vessels.CAPILLARIES]
func get_capillaries() -> Vessels:
	return get_vessels_by_type(GlobalTypes.Vessels.CAPILLARIES)

## Returns [Vessels] of passed type [enum GlobalTypes.Vessels]
func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	var vessels := Vessels.new()
	for tissue: Tissue in elements as Array[Tissue]:
		for vessel: Vessel in tissue.get_vessels_by_type(vessel_type) as Vessels:
			vessels.add(vessel)
	return vessels

## Returns all [Vessel]s FIXME: May not be working
func get_all_vessels() -> Vessels:
	var vessels := Vessels.new()
	for tissue: Tissue in elements as Array[Tissue]:
		for vessel: Vessel in tissue.get_all_vessels():
			vessels.add(vessel)
	return vessels

## Returns mean value of [member Tissue.health] of [Tissue]s found in [member tissues]
func get_mean_health() -> float:
	assert(elements)
	if is_empty(): return 0.0
	var health: float = 0
	for tissue: Tissue in elements as Array[Tissue]:
		health += tissue.health
	return health/size()

func any_hypoxic() -> bool:
	return elements.any(func(tissue: Tissue) -> bool: return tissue.is_hypoxic)

func any_hypercapnic() -> bool:
	return elements.any(func(tissue: Tissue) -> bool: return tissue.is_hypercapnic)

