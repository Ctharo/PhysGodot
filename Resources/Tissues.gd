class_name Tissues
extends Iterator
## Iterable class that contains Tissue instances and helpful methods.

var tissues: Array[Tissue] :
	set(value):
		_collection = value
	get:
		return _collection

func _init(t: Array[Tissue] = []) -> void:
	super._init(t)

## Returns float of sum of moles of provided [param gas]: [Gas]
func get_moles(gas: GlobalTypes.Gases) -> float:
	var moles: float = 0.0
	for tissue: Tissue in tissues:
		moles += tissue.get_moles(gas)
	return moles

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

func get_capillaries() -> Vessels:
	return get_vessels_by_type(GlobalTypes.Vessels.CAPILLARIES)

func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	var vessels := Vessels.new()
	for tissue: Tissue in tissues:
		for vessel: Vessel in tissue.get_vessels_by_type(vessel_type):
			vessels.add(vessel)
	return vessels

func get_all_vessels() -> Vessels:
	var vessels := Vessels.new()
	for tissue: Tissue in tissues:
		for vessel: Vessel in tissue.get_all_vessels():
			vessels.add(vessel)
	return vessels

func _iter() -> Iterator:
	return Iterator.new(tissues)

func set_debug(value: bool) -> void:
	for tissue: Tissue in tissues:
		tissue.debug = value
