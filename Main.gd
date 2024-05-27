class_name Main
extends Node2D

@onready var ui: Control = %UI as Control

var game_timer: float = 0.0
var timer: float = 0.0
const UI_UPDATE_RATE: float = 0.1 # Time for UI update in seconds

func _ready() -> void:
	ui.bodies = [create_body("Wayne")] as Array[Body]
#
#func _process(delta: float) -> void:
	#timer += delta
	#if timer > 1.0:
		#var i: int = Benchmarker.get_call_count("get_concentration")
		#timer = 0.0

func create_body(name_of_body: String) -> Body:
	var new_body := Body.new(name_of_body)
	add_child(new_body)
	return new_body
