class_name Main
extends Node2D

var bodies: Array[Body]
@onready var vbox: VBoxContainer = %UI/VBoxContainer as VBoxContainer
@onready var hbox: HBoxContainer = %UI/VBoxContainer/OrganWidgetHBox as HBoxContainer

var game_timer: float = 0.0
var timer: float = 0.0
const UI_UPDATE_RATE: float = 0.1 # Time for UI update in seconds

func _ready() -> void:
	bodies = [create_body("Wayne")]

func create_body(name_of_body: String) -> Body:
	var new_body := Body.new(name_of_body)
	add_child(new_body)
	create_ui([new_body] as Array[Body])
	return new_body

func _process(delta: float) -> void:
	timer += delta
	timer_label_process()
	if hbox == null:
		return

	if clear_dead():
		return

	if not bodies.size():
		clear_hbox()
		var label := Label.new()
		label.add_to_group("OrganWidget")
		label.set_offsets_preset(Control.PRESET_CENTER)
		label.text = "No living bodies found"
		hbox.add_child(label)
		return

	if timer > UI_UPDATE_RATE:
		timer = 0.0
		create_ui(bodies)

func clear_dead() -> bool:
	var dead_bodies: Array[Body] = bodies.filter(func(body: Body) -> bool: return body == null or body.dead) as Array[Body]
	for dead_body: Body in dead_bodies:
		bodies.erase(dead_body)
		#dead_body.queue_free()
	return dead_bodies.size() > 0

func create_ui(b: Array[Body]) -> void:
	# Return early if hbox is not available
	if hbox == null:
		printerr("Hbox is null")
		return

	# Clear any existing children in the hbox
	clear_hbox()

	# Iterate over each organ in the body and create an OrganWidget
	for body: Body in b as Array[Body]:
		var organs: Organs = body.get_organs() as Organs
		for organ: Organ in organs:
			var organ_widget := OrganWidget.new(organ)
			organ_widget.add_to_group("UIElement")
			organ_widget.add_to_group("OrganWidget")
			organ_widget.name = organ.name + "Widget"
			hbox.add_child(organ_widget)

func add_timer_label() -> void:
	var timer_label: RichTextLabel = RichTextLabel.new()
	timer_label.add_to_group("Timer")
	timer_label.bbcode_enabled = true
	timer_label.fit_content = true
	timer_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	timer_label.size_flags_stretch_ratio = 0.2
	timer_label.append_text("Time: %s" % Helpers.format_time(floor(Time.get_ticks_msec()/1000)))
	vbox.add_child(timer_label)
	vbox.move_child(timer_label, 0)

func timer_label_process() -> void:
	if not bodies.size():
		return
	get_tree().call_group("Timer", "queue_free")
	add_timer_label()

func clear_ui() -> void:
	get_tree().call_group("UIElement", "queue_free")

func clear_hbox() -> void:
	get_tree().call_group("OrganWidget", "queue_free")
