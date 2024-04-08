extends Node
class_name Tissue

var gases: Gases = Gases.new()
var vessels: Vessels
var mass: float = 1.0
var volume: float = 1.0
var metabolism_factor: float = 1.0


func _init():
	# Should create vessels upon instantiation
	var capillaries := Vessel.new(GlobalTypes.Vessels.CAPILLARIES)
	capillaries.name = "Capillaries"
	add_child(capillaries)

	var vein := Vessel.new(GlobalTypes.Vessels.VEIN)
	vein.name = "Vein"
	add_child(vein)

	var artery := Vessel.new(GlobalTypes.Vessels.ARTERY)
	artery.name = "Artery"
	add_child(artery)


	vessels = Vessels.new([capillaries, vein, artery] as Array[Vessel])
	#vessels.name = "Vessels"
	#add_child(vessels)

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
	return vessels.get_capillaries()
