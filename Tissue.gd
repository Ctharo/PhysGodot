extends Node
class_name Tissue

@export_category("Tissue")
## Stores information required for managing gas diffusion between capillaries and stored gases
var gases: Gases = Gases.new(0.18, 0.0)
var vessels: Vessels
var mass: float = 1.0
var volume: float = 1.0
const METABOLISM_FACTOR: float = 0.001
const GAS_EXCHANGE_FACTOR: float = 0.5

@export_category("Meta")
var timer: float = 0.0
const TIMER_INTERVAL: float = 1.0
var debug: bool = false

func _init():
	vessels = Vessels.new()
	init_vessels()

func _physics_process(delta):
	# TODO: Should be responsible to run physiological processes
	# (i.e., cellular respiration, acid-base chemistry, intercellular exchanges etc)
	timer += delta
	if timer > TIMER_INTERVAL:
		if debug: print("%s tissue processing" % name)
		exchange_gases(timer)
		aerobic_respiration(timer)

		## HACK: Ensures CO2 has a sink for debugging purposes
		if vessels.get_capillaries().get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE) > 0.045:
			vessels.get_capillaries().set_moles(GlobalTypes.Gases.CARBON_DIOXIDE, 0.0)

		timer = 0.0

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

	vein.receive_from = capillaries
	artery.deliver_to = capillaries

func connect_vessels_to_tissue(source_vessel: Vessel, sink_vessel: Vessel):
	if source_vessel.type != GlobalTypes.Vessels.AORTA or sink_vessel.type != GlobalTypes.Vessels.VENA_CAVA: # TODO: Can probably be removed at some point - used to ensure that the correct vessels are connected
		printerr("Incorrect type source_vessel: %s sink_vessel: %s" % [source_vessel, sink_vessel])
		return false

	# Connect tissue to vessel
	for vein in get_vessels_by_type(GlobalTypes.Vessels.VEIN):
		vein.deliver_to = sink_vessel
	for artery in get_vessels_by_type(GlobalTypes.Vessels.ARTERY):
		artery.receive_from = source_vessel
	return true

## Returns the concentration of a gas in the tissue
func get_concentration(gas: GlobalTypes.Gases) -> float:
	if mass == 0:
		return 0.0
	var moles: float = get_moles(gas)
	return moles/mass

func get_moles(gas: GlobalTypes.Gases) -> float:
	return gases.get_moles(gas)

func exchange_gases(delta: float) -> void:
	var capillaries: Vessels = get_capillaries()
	var vessel_oxygen_concentration: float = capillaries.get_concentration(GlobalTypes.Gases.OXYGEN)
	var vessel_carbon_dioxide_concentration: float = capillaries.get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE)
	var tissue_oxygen_concentration: float = get_concentration(GlobalTypes.Gases.OXYGEN)
	var tissue_carbon_dioxide_concentration: float = get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE)

	# Before exchange
	if debug: print("Before exchange: Tissue [O2]: %f, [CO2]: %f, Vessel [O2]: %f, [CO2]: %f" % [tissue_oxygen_concentration, tissue_carbon_dioxide_concentration, vessel_oxygen_concentration, vessel_carbon_dioxide_concentration])

	# Exchange gases with capillaries
	exchange_gas_with_capillaries(GlobalTypes.Gases.OXYGEN, tissue_oxygen_concentration, vessel_oxygen_concentration, capillaries, delta)
	exchange_gas_with_capillaries(GlobalTypes.Gases.CARBON_DIOXIDE, tissue_carbon_dioxide_concentration, vessel_carbon_dioxide_concentration, capillaries, delta)

	# After exchange
	if debug: print("After exchange: Tissue [O2]: %f, [CO2]: %f, Vessel [O2]: %f, [CO2]: %f" % [get_concentration(GlobalTypes.Gases.OXYGEN), get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE), capillaries.get_concentration(GlobalTypes.Gases.OXYGEN), capillaries.get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE)])

func exchange_gas_with_capillaries(gas: GlobalTypes.Gases, tissue_concentration: float, capillary_concentration: float, capillaries: Vessels, delta: float) -> void:
	var delta_concentration: float = capillary_concentration - tissue_concentration
	var moles: float = delta_concentration * volume * GAS_EXCHANGE_FACTOR * delta
	if debug: print("Exchanging %s: Delta concentration: %f, Moles exchanged: %f" % [Gases.get_string(gas), delta_concentration, moles])

	exchange_gas(gas, moles)
	capillaries.exchange_gas(gas, -moles)

## Adds or removes moles of a gas from the tissue
func exchange_gas(gas: GlobalTypes.Gases, moles: float) -> void:
	var total_moles: float = get_moles(gas) + moles
	assert(total_moles >= 0, "%s moles cannot be negative." % gas)
	gases.set_moles(gas, total_moles)


func get_capillaries() -> Vessels:
	return get_vessels_by_type(GlobalTypes.Vessels.CAPILLARIES)

func get_all_vessels() -> Vessels:
	return vessels

func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	return vessels.get_vessels_by_type(vessel_type)

func aerobic_respiration(delta: float):
	var oxygen_moles: float = get_moles(GlobalTypes.Gases.OXYGEN)

	var oxygen_needed: float = min(METABOLISM_FACTOR * delta, oxygen_moles)
	var carbon_dioxide_produced: float = METABOLISM_FACTOR * 2 * delta

	exchange_gas(GlobalTypes.Gases.OXYGEN, -oxygen_needed)
	exchange_gas(GlobalTypes.Gases.CARBON_DIOXIDE, carbon_dioxide_produced)
