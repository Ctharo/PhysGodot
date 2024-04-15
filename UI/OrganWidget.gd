class_name OrganWidget
extends VBoxContainer

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
	health_info.append_text("Health: [color=lime]" + str(int(organ.health * 100)) + "%[/color]")
	add_child(health_info)


	# Chemical imbalance warning
	var chem_warning := RichTextLabel.new()
	chem_warning.name = "ChemWarningLabel"
	chem_warning.bbcode_enabled = true
	chem_warning.fit_content = true
	if organ.bad_chemistry:
		#var chem_warning := RichTextLabel.new()
		#chem_warning.bbcode_enabled = true
		#chem_warning.fit_content = true
		chem_warning.append_text("[color=red]Warning: Chemical imbalance detected![/color]")
	else:
		chem_warning.append_text(" ")
	add_child(chem_warning)

	# Gas-specific information
	for gas in GlobalTypes.Gases.values() as Array[int]:
		var gas_info := RichTextLabel.new()
		gas_info.name = Gases.get_string(gas) + "InfoLabel"
		gas_info.bbcode_enabled = true
		gas_info.fit_content = true
		gas_info.append_text("[b]" + Gases.get_string(gas) + "[/b]\n")
		gas_info.append_text("[Tissue]: %f \n" % organ.get_concentration(gas))
		gas_info.append_text("[Vessel]: %f" % organ.get_capillaries().get_concentration(gas))
		add_child(gas_info)

		
	match organ.type:
		GlobalTypes.Organs.LUNGS:
			_lungs_setup(organ)
		_:
			pass
			
func _lungs_setup(organ: Organ) -> void:
	var chem_warning := RichTextLabel.new()
	chem_warning.name = "ChemWarningLabel"
	chem_warning.bbcode_enabled = true
	chem_warning.fit_content = true
	chem_warning.append_text(" ")
	add_child(chem_warning)
	
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
		gas_info.append_text("[Alveoli]: %f \n" % organ.alveoli.get_concentration(gas))
		gas_info.append_text("[Pulmonary Capillaries]: %f" % organ.alveoli.get_capillaries().get_concentration(gas))
		add_child(gas_info)
	
