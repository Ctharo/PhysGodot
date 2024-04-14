extends Node2D

var body: Body
@onready var hbox: HBoxContainer = %UI/HBoxContainer

var timer: float = 0.0

func _ready() -> void:
	body = create_body("Wayne")

func create_body(name_of_body: String) -> Body:
	var new_body := Body.new(name_of_body)
	add_child(new_body)
	create_ui(new_body)
	return new_body

func _process(delta: float) -> void:
	# HACK: For handling dead body
	if body == null and hbox != null:
		for child in hbox.get_children():
			if child != null:
				child.queue_free()
		var label := Label.new()
		label.text = "No living bodies found"
		hbox.add_child(label)
		return
	timer += delta
	if timer > 0.1:
		timer = 0.0
		create_ui(body)
	if body.dead:
		body.queue_free()

#func create_ui(b: Body) -> void:
	## Return early if hbox is not available
	#if hbox == null:
		#return
#
#
	## Clear any existing children in the hbox
	#for child in hbox.get_children():
		#if child != null:
			#child.queue_free()
#
	#var organ_count: int = b.organs.get_count()
#
	## Determine the width for each organ based on the number of organs
	#var organ_width: int = hbox.get_rect().size.x / max(organ_count, 1)
#
	## Iterate over each organ in the body
	#for organ in b.organs as Organs:
		#var vbox := VBoxContainer.new()
		#vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#vbox.size.x = organ_width
		#hbox.add_child(vbox)
#
		## RichTextLabel for organ information with BBCode enabled
		#var organ_info := RichTextLabel.new()
		#organ_info.bbcode_enabled = true
		#organ_info.fit_content = true
		#organ_info.append_text("[b]" + organ.name + "[/b]")
		#vbox.add_child(organ_info)
#
		## Health information
		#var health_info := RichTextLabel.new()
		#health_info.bbcode_enabled = true
		#health_info.fit_content = true
		#health_info.append_text("Health: [color=lime]" + str(int(organ.health * 100)) + "%[/color]")
		#vbox.add_child(health_info)
#
		## Chemical imbalance warning
		#if organ.bad_chemistry:
			#var chem_warning := RichTextLabel.new()
			#chem_warning.bbcode_enabled = true
			#chem_warning.fit_content = true
			#chem_warning.append_text("[color=red][b]Warning:[/b] Chemical imbalance detected![/color]")
#
			#vbox.add_child(chem_warning)
#
		## Gas-specific information
		#for gas in GlobalTypes.Gases.values() as Array[int]:
			#var gas_info := RichTextLabel.new()
			#gas_info.bbcode_enabled = true
			#gas_info.fit_content = true
			#gas_info.append_text("[b]" + Gases.get_string(gas) + "[/b]\n")
			#gas_info.append_text("[Tissue]: %f \n" % organ.get_concentration(gas))
			#gas_info.append_text("[Vessel]: %f" % organ.get_capillaries().get_concentration(gas))
			#vbox.add_child(gas_info)
#
#
func create_ui(b: Body) -> void:
	# Return early if hbox is not available
	if hbox == null:
		return

	# Clear any existing children in the hbox
	for child in hbox.get_children():
		if child != null:
			child.queue_free()

	var organ_count: int = b.organs.get_count()
	var organ_width: float = hbox.size.x / max(organ_count, 1)

	# Iterate over each organ in the body and create an OrganWidget
	for organ in b.organs as Organs:
		var organ_widget := OrganWidget.new(organ)
		organ_widget.custom_minimum_size.x = organ_width
		hbox.add_child(organ_widget)



