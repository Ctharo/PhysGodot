class_name UI
extends Control

var bodies: Array[Body]
@onready var vbox: VBoxContainer = %VBoxContainer as VBoxContainer
@onready var hbox: HBoxContainer = %OrganWidgetHBox as HBoxContainer
@onready var game_time_label: RichTextLabel = %GameTimeLabel as RichTextLabel

var game_time: float

func _ready() -> void:
	refresh_timer_label()

func _on_update_ui_timer_timeout() -> void:
	if hbox == null:
		return
		
	if clear_dead():
		return

	if not bodies.size():
		clear_organ_widgets()
		var label := Label.new()
		label.add_to_group("OrganWidget")
		label.set_offsets_preset(Control.PRESET_CENTER)
		label.text = "No living bodies found"
		hbox.add_child(label)
		return
		
	create_ui(bodies)

func create_ui(b: Array[Body]) -> void:
	# Return early if hbox is not available
	if hbox == null:
		printerr("Hbox is null")
		return

	# Clear any existing children in the hbox
	clear_organ_widgets()

	# Iterate over each organ in the body and create an OrganWidget
	for body: Body in b as Array[Body]:
		var organs: Organs = body.get_organs() as Organs
		for organ: Organ in organs:
			var organ_widget := OrganWidget.new(organ)
			organ_widget.add_to_group("UIElement")
			organ_widget.add_to_group("OrganWidget")
			organ_widget.name = organ.name + "Widget"
			hbox.add_child(organ_widget)

func clear_organ_widgets() -> void:
	get_tree().call_group("OrganWidget", "queue_free")

func refresh_timer_label() -> void:
	game_time_label.parse_bbcode("Time: %s" % Helpers.format_time(floor(Time.get_ticks_msec())))

func clear_dead() -> bool:
	var dead_bodies: Array[Body] = bodies.filter(func(body: Body) -> bool: return body == null or body.dead) as Array[Body]
	for dead_body: Body in dead_bodies:
		bodies.erase(dead_body)
		#dead_body.queue_free()
	return dead_bodies.size() > 0


func _on_game_time_timer_timeout() -> void:
	refresh_timer_label()
