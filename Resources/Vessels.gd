class_name Vessels
extends Iterator
## Iterable collection of Vessel instances with helpful methods

func _init(v: Array[Vessel] = [] as Array[Vessel]) -> void:
	super._init(v)
	fill_vessels_with_blood()

func fill_vessels_with_blood() -> void:
	for vessel: Vessel in elements as Array[Vessel]:
		vessel.fill_with_blood()

# FIXME: Doesn't appear to be working?
func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	var array: Array[Vessel] = elements.filter(func(vessel: Vessel) -> bool: return vessel.type == vessel_type) as Array[Vessel]
	var vessels := Vessels.new(array)
	return vessels

func get_concentration(gas: GlobalTypes.Gases) -> float:
	var total_volume: float = get_volume()
	if total_volume == 0:
		return 0.0
	var total_moles: float = get_moles(gas)
	return total_moles / total_volume

func get_moles(gas: GlobalTypes.Gases) -> float:
	var total_moles: float = 0.0
	for vessel: Vessel in elements as Array[Vessel]:
		total_moles += vessel.get_moles(gas)
	return total_moles

func get_volume() -> float:
	var total_volume: float = 0.0
	for vessel: Vessel in elements as Array[Vessel]:
		total_volume += vessel.volume
	return total_volume

## Returns [Vessels] of [Vessel] with [member Vessel.type] == [member Vessel.CAPILLIARIES].
func get_capillaries() -> Vessels:
	return get_vessels_by_type(GlobalTypes.Vessels.CAPILLARIES)

static func get_string(vessel: GlobalTypes.Vessels) -> String:
	return GlobalTypes.Vessels.keys()[vessel]

# TODO: Should probably ensure we are maintaining mass conservation
func exchange_gas(gas: GlobalTypes.Gases, moles: float) -> void:
	var total_volume: float = get_volume()
	if is_zero_approx(total_volume):
		printerr("Total volume of all vessels is zero")
		return
	var concentration: float = moles/total_volume
	for vessel: Vessel in elements as Array[Vessel]:
		var moles_for_vessel: float = concentration * vessel.volume
		var final_moles_for_vessel: float = moles_for_vessel + vessel.get_moles(gas)
		if is_zero_approx(final_moles_for_vessel):
			final_moles_for_vessel = 0
		assert(final_moles_for_vessel >= 0, "Moles should not be less than zero")
		vessel.set_moles(gas, final_moles_for_vessel)

## Warning: Does not follow conservation of mass. Debugging only.
func set_moles(gas: GlobalTypes.Gases, moles: float) -> void:
	for vessel: Vessel in elements as Array[Vessel]:
		vessel.set_moles(gas, moles)

func get_parent_name() -> String:
	return elements[0].get_parent().name

func get_vessel_name() -> String:
	if elements.size() == 1:
		return elements[0].name
	else:
		return "Vessels"
