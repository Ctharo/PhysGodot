extends Node
class_name Tissue

## Stores information required for managing gas diffusion between capillaries and stored gases
var gases: Gases = Gases.new()
var vessels: Vessels
var mass: float = 1.0
var volume: float = 1.0
var metabolism_factor: float = 1.0


func _init():
	vessels = Vessels.new()
	init_vessels()
	
func _physics_process(_delta):
	# TODO: Should be responsible to run physiological processes 
	# (i.e., cellular respiration, acid-base chemistry, intercellular exchanges etc)
	pass
	


func init_vessels():
	var capillaries := Vessel.new(GlobalTypes.Vessels.CAPILLARIES)
	add_child(capillaries)

	var vein := Vessel.new(GlobalTypes.Vessels.VEIN)
	add_child(vein)

	var artery := Vessel.new(GlobalTypes.Vessels.ARTERY)
	add_child(artery)

	vessels = Vessels.new([capillaries, vein, artery] as Array[Vessel])
	
	# Connect capillaries
	capillaries.receive_from = artery
	capillaries.deliver_to = vein
	
	# TODO: Connect vein
	vein.receive_from = capillaries
	
	# TODO: Connect arteryvein
	artery.deliver_to = capillaries

func connect_vessels_to_tissue(to_vessel: Vessel, from_vessel: Vessel):
	if to_vessel.type != GlobalTypes.Vessels.VENA_CAVA or from_vessel.type != GlobalTypes.Vessels.AORTA:
		printerr("Incorrect type to_vessel: %s from_vessel: %s" % [to_vessel, from_vessel])
		return false
	
	# Connect tissue to vessel
	for vein in get_vessels_by_type(GlobalTypes.Vessels.VEIN):
		vein.deliver_to = to_vessel
	for artery in get_vessels_by_type(GlobalTypes.Vessels.ARTERY):
		artery.receive_from = from_vessel
	return true
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
