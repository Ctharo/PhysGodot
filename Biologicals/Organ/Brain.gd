class_name Brain
extends Organ
## Manages the brain's state and behavior.
##
## Responsible for signal responses from various stimuli.

func _init(params: TissueParams) -> void:
	super._init(GlobalTypes.Organs.BRAIN, params)

func connect_organ_signals(organ: Organ) -> void:
	organ.hypoxia.connect(_on_organ_hypoxic)
	organ.organ_died.connect(_on_organ_died)
	organ.hypercapnia.connect(_on_organ_hypercapneic)

func _on_organ_hypoxic(organ: Organ) -> void:
	print("%s is hypoxic" % organ.name)

func _on_organ_hypercapneic(organ: Organ) -> void:
	print("%s is hypercapneic" % organ.name)

func _on_organ_died(organ: Organ) -> void:
	print("%s died" % organ.name)

	
