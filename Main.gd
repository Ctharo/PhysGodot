extends Node2D

var bodies: Array[Body]
@onready var hbox: HBoxContainer = %UI/HBoxContainer as HBoxContainer

var timer: float = 0.0
const UI_UPDATE_RATE: float = 0.1 # Time for UI update in seconds

func _ready() -> void:
	bodies = [create_body("Wayne")]

func create_body(name_of_body: String) -> Body:
	var new_body := Body.new(name_of_body)
	add_child(new_body)
	create_ui([new_body])
	return new_body

func _process(delta: float) -> void:
	# HACK: For handling dead body
	if hbox == null:
		return
	if not bodies.size():
		clear_hbox()
		var label := Label.new()
		label.text = "No living bodies found"
		hbox.add_child(label)
		return
	elif clear_dead():
		return
	timer += delta
	if timer > UI_UPDATE_RATE:
		timer = 0.0
		create_ui(bodies)

func clear_dead() -> bool:
	var dead_bodies: Array[Body] = bodies.filter(func(body: Body) -> bool: return body == null or body.dead) as Array[Body]
	for dead_body: Body in dead_bodies:
		bodies.erase(dead_body)
		dead_body.queue_free()
	return dead_bodies.size() > 0

func create_ui(b: Array[Body]) -> void:
	# Return early if hbox is not available
	if hbox == null:
		return
		
	# Clear any existing children in the hbox
	clear_hbox()

	# Iterate over each organ in the body and create an OrganWidget
	for body: Body in b as Array[Body]:
		var organs: Organs = body.get_organs() as Organs
		for organ: Organ in organs:
			var organ_widget := OrganWidget.new(organ)
			organ_widget.name = organ.name + "Widget"
			hbox.add_child(organ_widget)

func clear_hbox() -> void:
	for child: Control in hbox.get_children() as Array[Control]:
		if child != null:
			child.queue_free()
