extends Node
class_name Tissue

var gases: Gases = Gases.new()
var vessels: Vessels
var mass: float = 1.0
var volume: float = 1.0
var metabolism_factor: float = 1.0


func _init():
	vessels = Vessels.new()
	init_vessels()

func init_vessels():
	var capillaries := Vessel.new(GlobalTypes.Vessels.CAPILLARIES)
	add_child(capillaries)

	var vein := Vessel.new(GlobalTypes.Vessels.VEIN)
	add_child(vein)

	var artery := Vessel.new(GlobalTypes.Vessels.ARTERY)
	add_child(artery)

	vessels = Vessels.new([capillaries, vein, artery] as Array[Vessel])

func get_concentration(gas: GlobalTypes.Gases) -> float:
	if mass == 0:
		return 0.0
	var moles: float = get_moles(gas)
	return moles/mass

func get_moles(gas: GlobalTypes.Gases) -> float:
	return gases.get_moles(gas)

func exchange_gas(gas: GlobalTypes.Gases, moles: float) -> void:
	var total_moles: float = get_moles(gas) + moles
	assert(total_moles >= 0, "Moles for %s cannot be negative." % gas)
	if moles > 0:
		# We are adding moles
		pass
	if moles < 0:
		# We are removing moles
		pass
	push_error("exchange_gas method not yet implemented")

func get_capillaries() -> Vessels:
	return get_vessels_by_type(GlobalTypes.Vessels.CAPILLARIES)

func get_all_vessels() -> Vessels:
	return vessels

func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	return vessels.get_vessels_by_type(vessel_type)
