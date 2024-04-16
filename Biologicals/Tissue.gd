extends Node
class_name Tissue

var settings: Settings = load("res://Settings.tres") as Settings

@export_category("Tissue")
## Stores information required for managing gas diffusion between capillaries and stored gases
var gases: Gases
var vessels: Vessels

#region Set by OrganStats
var params: TissueParams
var mass: float #TODO: Tissue mass should cause increased rates of aerobic respiration, but also increased rates of gas exchange.
#endregion

@export_category("Meta")
var timer: float = 0.0
const TIMER_INTERVAL: float = 0.1
var debug: bool = false

func _init(params: TissueParams, mass: float) -> void:
	vessels = Vessels.new()
	self.params = params
	self.mass = mass
	_init_vessels()
	_init_gases()

func _physics_process(delta: float) -> void:
	# TODO: Should be responsible to run physiological processes
	# (i.e., cellular respiration, acid-base chemistry, intercellular exchanges etc)
	timer += delta
	if timer > TIMER_INTERVAL:
		if debug: print("%s tissue processing" % name)
		if settings.GAS_DIFFUSION_ENABLED: exchange_gases(timer)
		if settings.AEROBIC_RESPIRATION_ENABLED: aerobic_respiration(timer)

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
	var moles: float = delta_concentration * mass * params.vascularity_factor * delta
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

	var oxygen_needed: float = min(0.001 * params.metabolism_factor * params.oxygen_consumption_factor * delta, oxygen_moles)
	var carbon_dioxide_produced: float = 0.001 * params.metabolism_factor * params.carbon_dioxide_production_factor * delta 

	exchange_gas(GlobalTypes.Gases.OXYGEN, -oxygen_needed)
	exchange_gas(GlobalTypes.Gases.CARBON_DIOXIDE, carbon_dioxide_produced)

## Checks if tissue has too high of CO2 concentration
func is_hypercapnic() -> bool:
	return get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE) > params.max_co2_concentration

## Checks if tissue has too low of O2 concentration
func is_hypoxic() -> bool:
	return get_concentration(GlobalTypes.Gases.OXYGEN) < params.min_o2_concentration
