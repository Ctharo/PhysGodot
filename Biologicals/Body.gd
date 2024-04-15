extends Node
class_name Body
##
##
## TODO: Should handle Blood movement from aorta to tissues and from tissues to vena_cava

@export var organs: Organs
@export var vessels: Vessels
@export var dead: bool

func _init(new_name: String) -> void:
	name = new_name

func _ready() -> void:
	# Create Brain
	var brain_stats: OrganStats = load("res://Resources/OrganStats/BrainStats.tres")
	var brain := Organ.new(GlobalTypes.Organs.BRAIN, brain_stats)
	add_child(brain)

	# Create Lungs
	var lungs_stats: OrganStats = load("res://Resources/OrganStats/LungsStats.tres") as OrganStats
	var lungs := Lungs.new(GlobalTypes.Organs.LUNGS, lungs_stats)
	lungs.respired.connect(_on_lungs_respired)
	add_child(lungs)

	var heart_stats: OrganStats = load("res://Resources/OrganStats/HeartStats.tres")
	var heart: Heart = Heart.new(GlobalTypes.Organs.HEART, heart_stats)
	heart.heart_beated.connect(_on_heart_beat)
	add_child(heart)

	# Create Organs resource
	organs = Organs.new([brain, lungs, heart] as Array[Organ])
	for organ: Organ in organs:
		if !organ.bad_chemistry_detected.is_connected(_on_organ_bad_chemistry):
			organ.bad_chemistry_detected.connect(_on_organ_bad_chemistry)
		if !organ.organ_died.is_connected(_on_organ_died):
			organ.organ_died.connect(_on_organ_died)

	# Create Vessels
	var aorta := Vessel.new(GlobalTypes.Vessels.AORTA)
	add_child(aorta)

	var pulmonary_artery := Vessel.new(GlobalTypes.Vessels.PULMONARY_ARTERY)
	add_child(pulmonary_artery)

	## Connect major Body vessels
	var pulmonary_vein := Vessel.new(GlobalTypes.Vessels.PULMONARY_VEIN)
	pulmonary_vein.deliver_to = Vessels.new([aorta] as Array[Vessel])
	add_child(pulmonary_vein)
	
	## Connect pulmonary circuit
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

## Should move Blood throughout body
func move_blood(_delta: float) -> void:
	pass

func _on_organ_bad_chemistry(organ: Organ, gas: GlobalTypes.Gases) -> void:
	print("%s is experiencing a chemical imbalance with %s" % [organ.name, Gases.get_string(gas)])

func _on_organ_died(organ: Organ) -> void:
	print("%s's %s has died" % [name, organ.name])
	if Organs.is_of_type(organ, GlobalTypes.Organs.BRAIN):
		on_died()

func get_organs() -> Organs:
	return organs as Organs

func get_brain() -> Organ:
	return _get_organ(GlobalTypes.Organs.BRAIN)

func get_lungs() -> Organ:
	return _get_organ(GlobalTypes.Organs.LUNGS)

func _get_organ(organ_type: GlobalTypes.Organs) -> Organ:
	return organs.get_organ_by_type(organ_type)

func on_died() -> void:
	print("%s has died" % name)
	dead = true

## TODO: Not yet implemented
func _on_heart_beat(_stroke_volume: float) -> void:
	pass

## HACK for now will simply reset each Gas in Capillary gases from each Organ
func _on_lungs_respired() -> void:
	for vessel: Vessel in organs.get_vessels_by_type(GlobalTypes.Vessels.CAPILLARIES):
		vessel.set_moles(GlobalTypes.Gases.OXYGEN, 0.21 * vessel.volume)
		vessel.set_moles(GlobalTypes.Gases.CARBON_DIOXIDE, 0.005)
