class_name Tissue
extends Cacheable
## Describes the organization and functionality of a tissue, dependent on its role with an [Organ].
#TODO: Make Cells class that will describe the composition and function of the cells in this tissue
# Cells will be responsible to sample blood for signalling compounds to effect change in the Tissue/Organ

signal health_changed


## Ratio of health, where 1 is full health and 0 is death
var health: float :
	set(value):
		if dead:
			health = 0
			return
		if value != health:
			_health = value
			_health_dirty = true
			# Restart the timer to delay signal emission
			if not _timer.is_stopped():
				_timer.stop()
			_timer.start()
	get:
		return _health

var _health: float = 1
var _health_dirty: bool = false
var _timer: Timer = Timer.new()

## Used to turn certain processes on/off
var settings: Settings = load("res://Settings.tres") as Settings
## Used for data logging and retrieval
var data: Data

## Stores information required for managing gas diffusion between capillaries and stored gases
var gases: Gases
## Represents the collection of child [Vessel]s
var vessels: Vessels
## Is true when health reaches zero
var dead: bool

@export var is_hypoxic: bool :
	get:
		return get_cached_value("is_hypoxic", Tissue.calculate_is_hypoxic.bind(self), false, 5.0)

@export var is_hypercapnic: bool :
	get:
		return get_cached_value("is_hypercapnic", Tissue.calculate_is_hypercapnic.bind(self), false, 5.0)

#region Set by OrganStats
var _params: TissueParams ## Stores values of normal ranges, physical data, etc.
var status: Status ## Stores current status of tissue
#endregion

var timer: float = 0.0 ## Incremented by delta value in [method _physics_process], used to limit calculations
const TIMER_INTERVAL: float = 0.1 ## Time between calculations
var health_loss_buffer: float = 20
var last_oxygen_sufficient: float
var last_carbon_dioxide_sufficient: float
var mass: float :
	get:
		if get_params():
			return get_params().mass
		else:
			return 0.0

func _init(params: TissueParams) -> void:
	vessels = Vessels.new()
	self._params = params
	self.status = Status.new(params)
	self.data = Data.new(self)
	_init_vessels(params.blood_volume)
	_init_gases()

	_timer.wait_time = 0.1  # Delay before emitting the signal
	_timer.one_shot = true
	_timer.timeout.connect(_emit_health_changed)
	add_child(_timer)

func _physics_process(delta: float) -> void:
	# TODO: Should be responsible to run physiological processes
	# (i.e., cellular respiration, acid-base chemistry, intercellular exchanges etc)
	if dead: return
	timer += delta
	if timer > TIMER_INTERVAL:
		Logger.log_verbose("Processing...", self)
		if settings.GAS_DIFFUSION_ENABLED: exchange_gases(timer)
		if settings.AEROBIC_RESPIRATION_ENABLED: aerobic_respiration(timer)
		if !settings.INVINCIBLE_TISSUES: health_check(timer)
		timer = 0.0
		Logger.log_verbose("Finished processing", self)

func _init_gases() -> void:
	gases = Gases.new()
	set_moles(GlobalTypes.Gases.OXYGEN, 0.21 * mass)
	set_moles(GlobalTypes.Gases.CARBON_DIOXIDE, 0.0 * mass)

func _init_vessels(total_blood_volume: float) -> void:

	var volume_per_vessel: float = total_blood_volume/3

	var capillaries: Vessel = Vessel.new(GlobalTypes.Vessels.CAPILLARIES, volume_per_vessel)
	capillaries.name = "%s's Capillaries" % name
	add_child(capillaries)

	var vein: Vessel = Vessel.new(GlobalTypes.Vessels.VEIN, volume_per_vessel)
	vein.name = "%s's Vein" % name
	add_child(vein)

	var artery: Vessel = Vessel.new(GlobalTypes.Vessels.ARTERY, volume_per_vessel)
	artery.name = "%s's Artery" % name
	add_child(artery)

	vessels = Vessels.new([capillaries, vein, artery] as Array[Vessel])
	vessels.name = "%s's Vessels" % name

	# Connect capillaries
	capillaries.deliver_to = Vessels.new([vein] as Array[Vessel])
	artery.deliver_to = Vessels.new([capillaries] as Array[Vessel])

func get_params() -> TissueParams:
	return _params

## Responsible for removing health if certain conditions are met. Called from [method _physics_process].
func health_check(delta: float) -> void:
	if self.is_hypoxic:
		if Time.get_ticks_msec() - last_oxygen_sufficient > get_params().hypoxia_health_buffer * 1000:
			health -= delta * get_params().hypoxia_sensitivity * get_params().health_loss_factor * 0.01
	else:
		last_oxygen_sufficient = Time.get_ticks_msec()
	if self.is_hypercapnic:
		if Time.get_ticks_msec() - last_carbon_dioxide_sufficient > get_params().hypercapnea_health_buffer * 1000:
			health -= delta * get_params().hypercapnea_sensitivity * get_params().health_loss_factor * 0.01
	else:
		last_carbon_dioxide_sufficient = Time.get_ticks_msec()

# Emit the health_changed signal if health is dirty
func _emit_health_changed() -> void:
	if _health_dirty:
		health_changed.emit()
		_health_dirty = false

## Returns the concentration of a gas in the tissue
func get_concentration(gas: GlobalTypes.Gases) -> float:
	return get_cached_value("concentration_%s" % gas, Callable(Tissue.calculate_concentration).bind(self, gas), 0.016)

## Returns the amount of gas in the tissue in moles
func get_moles(gas: GlobalTypes.Gases) -> float:
	return gases.get_moles(gas)

## Use to directly set moles of a gas for this [Tissue]
func set_moles(gas: GlobalTypes.Gases, moles: float) -> void:
	gases.set_moles(gas, moles)

## Use to directly set concentration of a gas for this [Tissue]
func set_concentration(gas: GlobalTypes.Gases, concentration: float) -> void:
	gases.set_moles(gas, concentration * mass) # [Gases] has no set_concentration method as it does not have inherent volume/mass

## Responsible for directing the exchange of moles of gas between this class and child capillaries: [Vessel] based on concentration differences
func exchange_gases(delta: float) -> void:
	log_event("Exchanging gases with capillaries")
	
	# Exchange gases with capillaries
	var capillaries: Vessels = self.get_capillaries()
	exchange_gas_with_capillaries(GlobalTypes.Gases.OXYGEN, capillaries, delta)
	exchange_gas_with_capillaries(GlobalTypes.Gases.CARBON_DIOXIDE, capillaries, delta)
	
	log_event("Finished exchanging gases with capillaries")

## Responsible for exchanging of moles of gas between this class and arg capillaries
func exchange_gas_with_capillaries(gas: GlobalTypes.Gases, capillaries: Vessels, delta: float) -> void:
	# Do nothing if concentrations are equal
	if is_equal_approx(self.get_concentration(gas), capillaries.get_concentration(gas)):
		return
	# Assign donor and recipient
	# FIXME:I like the elegance of this method tho no type safety
	@warning_ignore("incompatible_ternary")
	var donor: Object = capillaries if capillaries.get_concentration(gas) > self.get_concentration(gas) else self
	@warning_ignore("incompatible_ternary")
	var recipient: Object = capillaries if capillaries.get_concentration(gas) < self.get_concentration(gas) else self
	assert(donor and recipient)
	var delta_concentration: float = donor.get_concentration(gas) - recipient.get_concentration(gas)
	var potential_moles: float = delta_concentration * mass * get_params().vascularity_factor * delta
	var moles: float = min(potential_moles, donor.get_moles(gas))
	# Calculate the actual amount of moles that can be exchanged
	if is_zero_approx(moles):
		return
	log_event("%s is sending %s moles of %s to %s" % [donor.name, Helpers.to_sci_notation(moles), Gases.get_string(gas), recipient.name])
	donor.exchange_gas(gas, -moles)
	recipient.exchange_gas(gas, moles)

## Adds or removes moles of a gas from the tissue
func exchange_gas(gas: GlobalTypes.Gases, moles: float) -> void:
	var total_moles: float = get_moles(gas) + moles
	assert(total_moles >= 0, "%s moles cannot be negative." % gas)
	set_moles(gas, total_moles)

#region Vessels helper methods
func get_capillaries() -> Vessels:
	var capillaries: Vessels = get_vessels_by_type(GlobalTypes.Vessels.CAPILLARIES)
	capillaries.name = "%s's Capillaries" % name
	return capillaries

func get_all_vessels() -> Vessels:
	return vessels

func get_vessels_by_type(vessel_type: GlobalTypes.Vessels) -> Vessels:
	return vessels.get_vessels_by_type(vessel_type)
#endregion

## Tissue-specific task for producing CO2 and consuming O2
func aerobic_respiration(delta: float) -> void:
	var oxygen_moles: float = get_moles(GlobalTypes.Gases.OXYGEN)

	var oxygen_needed: float = min(0.001 * get_params().metabolism_factor * get_params().oxygen_consumption_factor * delta, oxygen_moles)
	var carbon_dioxide_produced: float = 5e-5 * get_params().metabolism_factor * get_params().carbon_dioxide_production_factor * delta

	exchange_gas(GlobalTypes.Gases.OXYGEN, -oxygen_needed)
	exchange_gas(GlobalTypes.Gases.CARBON_DIOXIDE, carbon_dioxide_produced)

	log_event("Consumed %s moles of oxygen" % Helpers.to_sci_notation(oxygen_needed))
	log_event("Produced %s moles of carbon dioxide" % Helpers.to_sci_notation(carbon_dioxide_produced))

func log_event(message: String, verbosity: Logger.Verbosity = Logger.Verbosity.VERBOSE) -> void:
	Logger.log_event(message, self, verbosity)

#region Static methods for calculations mostly
## MUST GUARANTEE UP-TO-DATE CALCULATIONS 			##
## NO CACHED VALUES SHOULD BE USED IN CALCULATIONS 	##


## Checks if tissue has too high of CO2 concentration
static func calculate_is_hypercapnic(tissue: Tissue) -> bool:
	return Tissue.calculate_concentration(tissue, GlobalTypes.Gases.CARBON_DIOXIDE) > tissue.get_params().max_concentration[GlobalTypes.Gases.CARBON_DIOXIDE]

## Checks if tissue has too low of O2 concentration
static func calculate_is_hypoxic(tissue: Tissue) -> bool:
	return Tissue.calculate_concentration(tissue, GlobalTypes.Gases.OXYGEN) < tissue.get_params().min_concentration[GlobalTypes.Gases.OXYGEN]

## Returns concentration of a [Gas] within a [Tissue]
static func calculate_concentration(tissue: Tissue, gas: GlobalTypes.Gases) -> float:
	if tissue.mass == 0:
		assert(false, "Why is mass zero?")
		return 0.0
	var moles: float = tissue.get_moles(gas)
	return moles/tissue.mass
#endregion
