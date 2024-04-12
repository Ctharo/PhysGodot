extends Node2D

var body: Body
var hbox: HBoxContainer

var timer: float = 0.0

func _ready():

	var wayne := Body.new("Wayne")
	body = wayne
	add_child(wayne)
	create_ui(wayne)

func _process(delta):
	timer += delta
	if timer > 0.1:
		timer = 0.0
		create_ui(body)
	if body.get_brain().health <= 0:
		print("%s has died." % body.name)
		body.set_physics_process(false)
		body.set_process(false)

func create_ui(body: Body):
	if hbox:
		hbox.queue_free()
	hbox = HBoxContainer.new()
	add_child(hbox)
	for organ: Organ in body.organs:
		var vbox = VBoxContainer.new()
		var label = Label.new()
		var label_health = Label.new()
		label.text = organ.name
		label_health.text = "Health: %s" % (organ.health * 100)
		hbox.add_child(vbox)
		vbox.add_child(label)
		vbox.add_child(label_health)
		for gas in GlobalTypes.Gases.values():
			var label2 = Label.new()
			label2.text = "Tissue [%s]: %f" % [Gases.get_string(gas), organ.get_concentration(gas)]
			var label3 = Label.new()
			label3.text = "Vessel [%s]: %f" % [Gases.get_string(gas), organ.get_capillaries().get_concentration(gas)]
			vbox.add_child(label2)
			vbox.add_child(label3)
		hbox.add_child(Control.new())




