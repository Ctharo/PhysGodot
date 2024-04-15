extends Node
class_name Tissue

@export_category("Tissue")
## Stores information required for managing gas diffusion between capillaries and stored gases
var gases: Gases
var vessels: Vessels
var mass: float #TODO: Tissue mass should cause increased rates of aerobic respiration, but also increased rates of gas exchange.
var metabolism_factor: float ## Effects rate at which this tissue consumes O2 and produces CO2 (TODO: Maybe more)
var vascularity_factor: float ## Effects rate at which this tissue can diffuse gases from Capillaries 


@export_category("Meta")
var timer: float = 0.0
const TIMER_INTERVAL: float = 0.1
var debug: bool = false

func _init(metabolism_factor: float, vascularity_factor: float, mass: float) -> void:
	vessels = Vessels.new()
	self.metabolism_factor = metabolism_factor
	self.vascularity_factor = vascularity_factor
	self.mass = mass
	_init_vessels()
	_init_gases()

func _physics_process(delta: float) -> void:
	# TODO: Should be responsible to run physiological processes
	# (i.e., cellular respiration, acid-base chemistry, intercellular exchanges etc)
	timer += delta
	if timer > TIMER_INTERVAL:
		if debug: print("%s tissue processing" % name)
		exchange_gases(timer)
		aerobic_respiration(timer)

		timer = 0.0

func _init_gases() -> void:
	gases = Gases.new()
	gases.set_moles(GlobalTypes.Gases.OXYGEN, 0.21 * mass)
	gases.set_moles(GlobalTypes.Gases.CARBON_DIOXIDE, 0.0 * mass)
	
func _init_vessels() -> void:
	var capillaries := Vessel.new(GlobalTypes.Vessels.CAPILLARIES)
	add_child(capillaries)

	var vein := Vessel.new(GlobalTypes.Vessels.VEIN)
	add_child(vein)

	var artery := Vessel.new(GlobalTypes.Vessels.ARTERY)
	add_child(artery)

	vessels = Vessels.new([capillaries, vein, artery] as Array[Vessel])

	# Connect capillaries
	capillaries.deliver_to = Vessels.new([vein] as Array[Vessel])
	artery.deliver_to = Vessels.new([capillaries] as Array[Vessel])

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
	var moles: float = delta_concentration * mass * vascularity_factor * delta
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

## Tissue-specific task for producing CO2 and consuming O2
func aerobic_respiration(delta: float) -> void:
	var oxygen_moles: float = get_moles(GlobalTypes.Gases.OXYGEN)

	var oxygen_needed: float = min(metabolism_factor * delta, oxygen_moles)
	var carbon_dioxide_produced: float = metabolism_factor * 0.5 * delta 

	exchange_gas(GlobalTypes.Gases.OXYGEN, -oxygen_needed)
	exchange_gas(GlobalTypes.Gases.CARBON_DIOXIDE, carbon_dioxide_produced)

### HACK method for debugging purposes until circulation is implemented
#func reset_blood_gases() -> void:
	#if vessels.get_capillaries().get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE) > 0.05:
		#vessels.get_capillaries().set_moles(GlobalTypes.Gases.CARBON_DIOXIDE, 0.0)
	#if vessels.get_capillaries().get_concentration(GlobalTypes.Gases.OXYGEN) < 0.205:
		#vessels.get_capillaries().set_moles(GlobalTypes.Gases.OXYGEN, 0.21)
