class_name Tissues
extends Iterator
## Iterable class that contains Tissue instances and helpful methods.
##
##

var name: String

## Contains all [Tissue]s in Array
var tissues: Array[Tissue] :
	set(value):
		_collection = value
	get:
		return _collection

func _init(t: Array[Tissue] = []) -> void:
	super._init(t)

func add_tissue(tissue: Tissue) -> void:
	tissues.append(tissue)

## Returns float of sum of moles of provided [param gas]: [Gas]
func get_moles(gas: GlobalTypes.Gases) -> float:
	var moles: float = 0.0
	for tissue: Tissue in tissues:
		moles += tissue.get_moles(gas)
	return moles

#TODO: Cache this value
## Returns sum of [member Tissue.mass] from [member tissues]
func total_mass() -> float:
	var total: float = 0.0
	for tissue: Tissue in tissues:
		total += tissue.mass
	return total

## Returns float of sum of moles of provided [param gas] divided by [method total_mass] return value.
func get_concentration(gas: GlobalTypes.Gases) -> float:
	var mass: float = total_mass()
	if mass == 0.0:
		return 0.0
	return get_moles(gas)/mass
	
## Sets concentration of a [Gas] to all [Tissue]s
func set_concentration(gas: GlobalTypes.Gases, concentration: float) -> void:
	for tissue: Tissue in tissues:
		tissue.set_concentration(gas, concentration)

## Sets health of all [Tissue]s
func set_health(health_value: float) -> void:
	for tissue: Tissue in tissues:
		tissue.health = health_value

func all_dead() -> bool:
	var dead: bool = true
	for tissue: Tissue in tissues:
		if not tissue.dead:
			dead = false
			break
	return dead

## Returns [Vessels] of type [enum GlobalTypes.Vessels.CAPILLARIES]
func get_capillaries() -> Vessels:
	return get_vessels_by_type(GlobalTypes.Vessels.CAPILLARIES)

## Returns [Vessels] of passed type [enum GlobalTypes.Vessels]
func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	var vessels := Vessels.new()
	for tissue: Tissue in tissues:
		for vessel: Vessel in tissue.get_vessels_by_type(vessel_type):
			vessels.add(vessel)
	return vessels

## Returns all [Vessel]s FIXME: May not be working
func get_all_vessels() -> Vessels:
	var vessels := Vessels.new()
	for tissue: Tissue in tissues:
		for vessel: Vessel in tissue.get_all_vessels():
			vessels.add(vessel)
	return vessels

## Depreciated?
func set_debug(value: bool) -> void:
	for tissue: Tissue in tissues:
		tissue.debug = value

## Returns mean value of [member Tissue.health] of [Tissue]s found in [member tissues]
func get_mean_health() -> float:
	assert(tissues)
	if not tissues.size(): return 0.0
	var health: float = 0
	for tissue: Tissue in tissues:
		health += tissue.health
	return health/tissues.size()

func size() -> int:
	return tissues.size()

func _iter() -> Iterator:
	return Iterator.new(tissues)
