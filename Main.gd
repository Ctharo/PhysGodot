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

func create_ui(b: Body) -> void:
	if hbox == null:
		return
	for child in hbox.get_children():
		if child != null:
			child.queue_free()
	for organ: Organ in b.organs as Organs:
		var vbox := VBoxContainer.new()
		var label := Label.new()
		var label_health := Label.new()
		label.text = organ.name
		label_health.text = "Health: %s" % (organ.health * 100)

		hbox.add_child(vbox)
		vbox.add_child(label)
		if organ.bad_chemistry:
			var bad_chem_warning_label: Label = Label.new()
			bad_chem_warning_label.text = "Warning: Chemical imbalance detected!"
			vbox.add_child(bad_chem_warning_label)
		vbox.add_child(label_health)
		for gas: int in GlobalTypes.Gases.values() as Array[int]:
			var label2 := Label.new()
			label2.text = "Tissue [%s]: %f" % [Gases.get_string(gas), organ.get_concentration(gas)]
			var label3 := Label.new()
			label3.text = "Vessel [%s]: %f" % [Gases.get_string(gas), organ.get_capillaries().get_concentration(gas)]
			vbox.add_child(label2)
			vbox.add_child(label3)





