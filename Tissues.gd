extends Iterator
class_name Tissues
## Iterable class that contains Tissue instances and helpful methods.

var tissues: Array[Tissue] :
	set(value):
		_collection = value
	get:
		return _collection

## Returns float of sum of moles of provided [param gas]: [Gas]
func get_moles(gas: GlobalTypes.Gases) -> float:
	var moles: float = 0.0
	for tissue in tissues:
		moles += tissue.get_moles(gas)
	return moles

func total_mass() -> float:
	var total: float = 0.0
	for tissue in tissues:
		total += tissue.mass
	return total

## Returns float of sum of moles of provided [param gas] divided by [method total_mass] return value.
func get_concentration(gas: GlobalTypes.Gases) -> float:
	var mass = total_mass()
	if mass == 0.0:
		return 0.0
	return get_moles(gas)/mass

func get_capillaries() -> Vessels:
	var capillaries:= Vessels.new() # If we make it type Vessels, we can use our methods on the vessels
	for tissue in tissues:
		for capillary in tissue.get_capillaries():
			capillaries.add(capillary)
	return capillaries

func _iter() -> Iterator:
	return Iterator.new(tissues)

