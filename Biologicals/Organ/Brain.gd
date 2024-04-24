class_name Brain
extends Organ
## Manages the brain's state and behavior.
##
## Responsible for signal responses from various stimuli.

signal heart_rate_increase
signal heart_rate_decrease
signal respiratory_rate_increase
signal respiratory_rate_decrease

var last_heart_stimulus_time: float
var heart_stimulus_interval: float = 1
var last_lungs_stimulus_time: float
var lungs_stimulus_interval: float = 1


func _init(params: TissueParams) -> void:
	super._init(GlobalTypes.Organs.BRAIN, params)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

## Connects signals from [Organ]s the brain is responsible to monitor
func connect_organ_signals(organ: Organ) -> void:
	organ.hypoxia.connect(_on_organ_hypoxic)
	organ.organ_died.connect(_on_organ_died)
	organ.hypercapnia.connect(_on_organ_hypercapnic)

## Will be used to respond to a hypoxic status of a monitored [Organ]
func _on_organ_hypoxic(organ: Organ) -> void:
	pass

## Will be used to respond to a hypercapnic status of a monitored [Organ]
func _on_organ_hypercapnic(organ: Organ) -> void:
	pass

## Will be used to respond to the death of a monitored [Organ]
func _on_organ_died(organ: Organ) -> void:
	print("%s's %s died!" % [get_parent().name, organ.name])


