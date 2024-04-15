class_name Alveoli
extends Node

@export var gases: Gases
@export var volume: float = 6.0
@export var vessels: Vessels
var vascularity_factor: float = 5.0
var debug: bool

func _init() -> void:
	gases = Gases.new()
	_init_vessels()

## HINT Connections are set from Body
func _init_vessels() -> void:
	var capillaries := Vessel.new(GlobalTypes.Vessels.CAPILLARIES)
	add_child(capillaries)
	vessels = Vessels.new([capillaries] as Array[Vessel])

func _physics_process(delta: float) -> void:
	exchange_gases(delta)
	
func exchange_gases(delta: float) -> void:
	var capillaries: Vessels = get_capillaries()
	var vessel_oxygen_concentration: float = capillaries.get_concentration(GlobalTypes.Gases.OXYGEN)
	var vessel_carbon_dioxide_concentration: float = capillaries.get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE)
	var alveoli_oxygen_concentration: float = get_concentration(GlobalTypes.Gases.OXYGEN)
	var alveoli_carbon_dioxide_concentration: float = get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE)

	# Before exchange
	if debug: print("Before exchange: Tissue [O2]: %f, [CO2]: %f, Vessel [O2]: %f, [CO2]: %f" % [alveoli_oxygen_concentration, alveoli_carbon_dioxide_concentration, vessel_oxygen_concentration, vessel_carbon_dioxide_concentration])

	# Exchange gases with capillaries
	exchange_gas_with_capillaries(GlobalTypes.Gases.OXYGEN, alveoli_oxygen_concentration, vessel_oxygen_concentration, capillaries, delta)
	exchange_gas_with_capillaries(GlobalTypes.Gases.CARBON_DIOXIDE, alveoli_carbon_dioxide_concentration, vessel_carbon_dioxide_concentration, capillaries, delta)

	# After exchange
	if debug: print("After exchange: Tissue [O2]: %f, [CO2]: %f, Vessel [O2]: %f, [CO2]: %f" % [get_concentration(GlobalTypes.Gases.OXYGEN), get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE), capillaries.get_concentration(GlobalTypes.Gases.OXYGEN), capillaries.get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE)])

func get_capillaries() -> Vessels:
	return get_vessels_by_type(GlobalTypes.Vessels.CAPILLARIES)

func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	return vessels.get_vessels_by_type(vessel_type)

func get_concentration(gas: GlobalTypes.Gases) -> float:
	if volume == 0:
		return 0
	return gases.get_moles(gas)/volume

func exchange_gas_with_capillaries(gas: GlobalTypes.Gases, alveoli_concentration: float, capillary_concentration: float, capillaries: Vessels, delta: float) -> void:
	var delta_concentration: float = capillary_concentration - alveoli_concentration
	var moles: float = delta_concentration * volume * vascularity_factor * delta
	exchange_gas(gas, moles)
	capillaries.exchange_gas(gas, -moles)

## Adds or removes moles of a gas from the air within alveoli
func exchange_gas(gas: GlobalTypes.Gases, moles: float) -> void:
	var total_moles: float = get_moles(gas) + moles
	assert(total_moles >= 0, "%s moles cannot be negative." % gas)
	gases.set_moles(gas, total_moles)

func get_moles(gas: GlobalTypes.Gases) -> float:
	return gases.get_moles(gas)

func set_moles(gas: GlobalTypes.Gases, moles: float) -> void:
	gases.set_moles(gas, moles)
