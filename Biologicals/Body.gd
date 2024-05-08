class_name Body
extends Node
## Manages [Organs] and major [Vessels]
##
## TODO: Should handle Blood movement from aorta to tissues and from tissues to vena_cava

@export var organs: Organs
@export var vessels: Vessels
@export var dead: bool


func _init(new_name: String) -> void:
	name = new_name

func _ready() -> void:
	# Create Brain
	var brain_params: TissueParams = load("res://Resources/Params/TissueParams/BrainParams.tres") as TissueParams
	var brain: Brain = Brain.new(brain_params)


	# Create Lungs
	var lungs_params: TissueParams = load("res://Resources/Params/TissueParams/LungsParams.tres") as TissueParams
	var lungs: Lungs  = Lungs.new(lungs_params)


	var heart_params: TissueParams = load("res://Resources/Params/TissueParams/HeartParams.tres") as TissueParams
	var heart: Heart = Heart.new(heart_params)


	# Create Organs resource
	organs = Organs.new([brain, lungs, heart] as Array[Organ])

	# Connect signals
	# Organ specific signals
	heart.heart_beated.connect(_on_heart_beat)

	# General signals
	for organ: Organ in organs:
		brain.connect_organ_signals(organ)
		organ.organ_died.connect(_on_organ_died)

	add_child(brain)
	add_child(lungs)
	add_child(heart)

	# Create Vessels
	var aorta := Vessel.new(GlobalTypes.Vessels.AORTA)
	add_child(aorta)

	var pulmonary_artery := Vessel.new(GlobalTypes.Vessels.PULMONARY_ARTERY)
	add_child(pulmonary_artery)

	# Connect major Body vessels
	var pulmonary_vein := Vessel.new(GlobalTypes.Vessels.PULMONARY_VEIN)
	pulmonary_vein.deliver_to = Vessels.new([aorta] as Array[Vessel])
	add_child(pulmonary_vein)

	# Connect pulmonary circuit
	pulmonary_artery.deliver_to = lungs.alveoli.get_capillaries()
	for vessel: Vessel in lungs.alveoli.get_capillaries():
		vessel.deliver_to = Vessels.new([pulmonary_vein] as Array[Vessel])

	var vena_cava := Vessel.new(GlobalTypes.Vessels.VENA_CAVA)
	vena_cava.deliver_to = Vessels.new([pulmonary_artery] as Array[Vessel])
	add_child(vena_cava)

	vessels = Vessels.new([aorta, pulmonary_artery, pulmonary_vein, vena_cava] as Array[Vessel])

	# Connect all tissues to body vessels
	if !organs.connect_vessels_to_organs(aorta, vena_cava):
		printerr("Problem connecting vessels")

	print("%s has been created successfully" % name)


## TODO: Not sure what this should be used for yet
func _physics_process(_delta: float) -> void:
	if dead:
		return
		
func send_signal(to_organ: GlobalTypes.Organs, sig: GlobalTypes.PhysioSignal) -> void:
	match to_organ:
		GlobalTypes.Organs.HEART:
			get_heart().receive_signal(sig)

## Should move Blood throughout body
func move_blood(_delta: float) -> void:
	pass

## Signal response
func _on_organ_bad_chemistry(organ: Organ, gas: GlobalTypes.Gases) -> void:
	print("%s is experiencing a chemical imbalance with %s" % [organ.name, Gases.get_string(gas)])

## Signal response
func _on_organ_died(organ: Organ) -> void:
	if Organs.is_of_type(organ, GlobalTypes.Organs.BRAIN):
		on_died()

## Returns [member organs]
func get_organs() -> Organs:
	return organs as Organs

## Returns brain
func get_brain() -> Brain:
	return _get_organ(GlobalTypes.Organs.BRAIN)

## Returns lungs
func get_lungs() -> Lungs:
	return _get_organ(GlobalTypes.Organs.LUNGS)

func get_heart() -> Heart:
	return _get_organ(GlobalTypes.Organs.HEART)

func _get_organ(organ_type: GlobalTypes.Organs) -> Organ:
	return organs.get_organ_by_type(organ_type)

## Called when [member health] is zero
func on_died() -> void:
	print("%s has died" % name)
	dead = true

## Simulates the effects of a heart beat in moving around gases through blood.
func _on_heart_beat(stroke_volume: float) -> void:
	if stroke_volume <= 0:
		printerr("Stroke volume must be greater than 0")
		return

	var pulmonary_capillaries: Vessels = get_lungs().alveoli.get_capillaries()

	for organ: Organ in organs:
		var organ_capillaries: Vessels = organ.get_capillaries()

		# Calculate gas removal based on organ capillaries
		var organ_o2_moles_removed: float = organ_capillaries.get_concentration(GlobalTypes.Gases.OXYGEN) * stroke_volume
		var organ_co2_moles_removed: float = organ_capillaries.get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE) * stroke_volume

		# Calculate gas addition based on pulmonary capillaries (donor blood)
		var pulm_o2_moles_added: float = pulmonary_capillaries.get_concentration(GlobalTypes.Gases.OXYGEN) * stroke_volume
		var pulm_co2_moles_added: float = pulmonary_capillaries.get_concentration(GlobalTypes.Gases.CARBON_DIOXIDE) * stroke_volume

		# Update moles in organ capillaries
		organ_capillaries.set_moles(GlobalTypes.Gases.OXYGEN, organ_capillaries.get_moles(GlobalTypes.Gases.OXYGEN) - organ_o2_moles_removed + pulm_o2_moles_added)
		organ_capillaries.set_moles(GlobalTypes.Gases.CARBON_DIOXIDE, organ_capillaries.get_moles(GlobalTypes.Gases.CARBON_DIOXIDE) - organ_co2_moles_removed + pulm_co2_moles_added)

		# Update moles in pulmonary capillaries
		pulmonary_capillaries.set_moles(GlobalTypes.Gases.OXYGEN, pulmonary_capillaries.get_moles(GlobalTypes.Gases.OXYGEN) + organ_o2_moles_removed - pulm_o2_moles_added)
		pulmonary_capillaries.set_moles(GlobalTypes.Gases.CARBON_DIOXIDE, pulmonary_capillaries.get_moles(GlobalTypes.Gases.CARBON_DIOXIDE) + organ_co2_moles_removed - pulm_co2_moles_added)


