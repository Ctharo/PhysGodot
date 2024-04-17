class_name Heart
extends Organ

signal heart_beated
@export var heart_rate: float
@export var stroke_volume: float
@export var heart_rate_timer: float


func _init(params: TissueParams) -> void:
	super._init(GlobalTypes.Organs.HEART, params)

	heart_rate = 1
	stroke_volume = 0.06
	
func _physics_process(delta: float) -> void:
	if dead: return
	super._physics_process(delta)
	if params.perform_organ_specific_task: heart_beat(delta)

## Organ specific task responsible for timing of heartbeat which in turn triggers circulation from [Body]
func heart_beat(delta: float) -> void:
	if heart_rate == 0:
		return
	heart_rate_timer += delta
	if heart_rate_timer > 1/heart_rate:
		heart_beated.emit(stroke_volume)
		heart_rate_timer = 0
