class_name OrganWidget
extends VBoxContainer
## UI object that will display information on an [Organ] passed on instantiation


func _init(organ: Organ) -> void:
	self.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	self.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Organ name
	var organ_info := RichTextLabel.new()
	organ_info.name = "OrganNameLabel"
	organ_info.bbcode_enabled = true
	organ_info.fit_content = true
	organ_info.append_text("[b]" + organ.name + "[/b]")
	add_child(organ_info)

	# Health information
	var health_info := RichTextLabel.new()
	health_info.name = "HealthLabel"
	health_info.bbcode_enabled = true
	health_info.fit_content = true
	health_info.append_text("Health: [color=lime]%s[/color]" % Helpers.as_percent(organ.health))
	add_child(health_info)

	# Chemical imbalance warning
	var chem_warning := RichTextLabel.new()
	chem_warning.name = "ChemWarningLabel"
	chem_warning.bbcode_enabled = true
	chem_warning.fit_content = true
	var warning_text := ""
	if organ.status.hypoxia:
		warning_text += "[color=red]Warning: Organ is hypoxic![/color] \n"
	if organ.status.hypercapnia:
		warning_text += "[color=red]Warning: Organ is hypercapneic![/color]"
	chem_warning.append_text(warning_text if warning_text else " ")
	add_child(chem_warning)

	# Gas-specific information
	for gas in GlobalTypes.Gases.values() as Array[int]:
		var gas_info := RichTextLabel.new()
		gas_info.name = Gases.get_string(gas) + "InfoLabel"
		gas_info.bbcode_enabled = true
		gas_info.fit_content = true
		gas_info.append_text("[b]" + Gases.get_string(gas) + "[/b]\n")

		# Get concentrations and check conditions
		var tissue_concentration := organ.get_concentration(gas)
		var capillaries := organ.get_capillaries()
		var vessel_concentration := capillaries.get_concentration(gas)

		gas_info.append_text("Tissue: [color=" + get_concentration_color_string(gas, organ) + "]%s[/color] \n" % Helpers.as_percent(tissue_concentration, 2))
		gas_info.append_text("Vessel: [color=" + get_vessel_concentration_color_string(gas, organ, capillaries) + "]%s[/color]" % Helpers.as_percent(vessel_concentration, 2))
		add_child(gas_info)

	# Additional setup based on organ type
	match organ.type:
		GlobalTypes.Organs.LUNGS:
			_lungs_setup(organ)
		GlobalTypes.Organs.HEART:
			_heart_setup(organ)
		_:
			pass

func get_concentration_color_string(gas: GlobalTypes.Gases, organ: Organ) -> String:
	var result: String
	match gas:
		GlobalTypes.Gases.OXYGEN:
			result = "red" if organ.is_hypoxic() else "white"
		GlobalTypes.Gases.CARBON_DIOXIDE:
			result = "red" if organ.is_hypercapnic() else "white"
		_:
			result = "white"
	return result

func get_vessel_concentration_color_string(gas: GlobalTypes.Gases, organ: Organ, vessels: Vessels) -> String:
	var result: String
	match gas:
		GlobalTypes.Gases.OXYGEN:
			result = "red" if vessels.get_concentration(gas) < organ.params.min_concentration[gas] else "white"
		GlobalTypes.Gases.CARBON_DIOXIDE:
			result = "red" if vessels.get_concentration(gas) > organ.params.max_concentration[gas] else "white"
		_:
			result = "white"
	return result

func _heart_setup(organ: Heart) -> void:
	var space := RichTextLabel.new()
	space.name = "space"
	space.bbcode_enabled = true
	space.fit_content = true
	space.append_text(" ")
	add_child(space)

	var heart_rate_info := RichTextLabel.new()
	heart_rate_info.name = "respiration_info"
	heart_rate_info.bbcode_enabled = true
	heart_rate_info.fit_content = true
	var hr: float = organ.heart_rate * 60
	heart_rate_info.append_text("[b]Heart Rate: [/b] %.2f/min" % hr)
	add_child(heart_rate_info)

func _lungs_setup(organ: Lungs) -> void:
	var space := RichTextLabel.new()
	space.name = "space"
	space.bbcode_enabled = true
	space.fit_content = true
	space.append_text(" ")
	add_child(space)

	var respiration_info := RichTextLabel.new()
	respiration_info.name = "respiration_info"
	respiration_info.bbcode_enabled = true
	respiration_info.fit_content = true
	var rr: float = organ.respiration_rate * 60
	respiration_info.append_text("[b]Respiration Rate: [/b] %.2f/min" % rr)
	add_child(respiration_info)

	var space2 := RichTextLabel.new()
	space2.name = "space2"
	space2.bbcode_enabled = true
	space2.fit_content = true
	space2.append_text(" ")
	add_child(space2)

	var alveoli_info := RichTextLabel.new()
	alveoli_info.name = "AlveoliNameLabel"
	alveoli_info.bbcode_enabled = true
	alveoli_info.fit_content = true
	alveoli_info.append_text("[b]" + organ.alveoli.name + "[/b]")
	add_child(alveoli_info)

	# Gas-specific information
	for gas in GlobalTypes.Gases.values() as Array[int]:
		var gas_info := RichTextLabel.new()
		gas_info.name = Gases.get_string(gas) + "InfoLabel"
		gas_info.bbcode_enabled = true
		gas_info.fit_content = true
		gas_info.append_text("[b]" + Gases.get_string(gas) + "[/b]\n")
		gas_info.append_text("[Alveoli]: %s \n" % Helpers.as_percent(organ.alveoli.get_concentration(gas), 2))
		gas_info.append_text("[Pulmonary Capillaries]: %s" % Helpers.as_percent(organ.alveoli.get_capillaries().get_concentration(gas),2))
		add_child(gas_info)


