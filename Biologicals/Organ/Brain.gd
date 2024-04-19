class_name Brain
extends Organ
## Manages the brain's state and behavior.
##
## Responsible for signal responses from various stimuli.


func _init(params: TissueParams) -> void:
	super._init(GlobalTypes.Organs.BRAIN, params)

## Connects signals from [Organ]s the brain is responsible to monitor
func connect_organ_signals(organ: Organ) -> void:
	organ.hypoxia.connect(_on_organ_hypoxic)
	organ.organ_died.connect(_on_organ_died)
	organ.hypercapnia.connect(_on_organ_hypercapneic)

## Will be used to respond to a hypoxic status of a monitored [Organ]
func _on_organ_hypoxic(organ: Organ) -> void:
	print("%s's %s is hypoxic!" % [get_parent().name, organ.name])

## Will be used to respond to a hypercapnic status of a monitored [Organ]
func _on_organ_hypercapneic(organ: Organ) -> void:
	print("%s's %s is hypercapnic!" % [get_parent().name, organ.name])

## Will be used to respond to the death of a monitored [Organ]
func _on_organ_died(organ: Organ) -> void:
	print("%s's %s died!" % [get_parent().name, organ.name])


