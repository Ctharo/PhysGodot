class_name Lungs
extends Organ

signal respired

@export var respiration_rate: float
@export var respiration_rate_timer: float
@export var alveoli: Alveoli


func _init(params: TissueParams) -> void:
	super._init(GlobalTypes.Organs.LUNGS, params)

	alveoli = Alveoli.new()
	alveoli.name = "Alveoli"
	add_child(alveoli)
	respiration_rate = 0.2

func _physics_process(delta: float) -> void:
	if dead: return
	super._physics_process(delta)
	if params.perform_organ_specific_task: respire(delta)

## Organ specific task responsible for refreshing each [Gas] amount in [Alveoli]
func respire(delta: float) -> void:
	if respiration_rate == 0:
		return
	respiration_rate_timer += delta
	if respiration_rate_timer > 1/respiration_rate:
		respiration_rate_timer = 0
		alveoli._on_respiration()
