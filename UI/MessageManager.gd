extends Control

# Dictionary to store console containers for each entity
var entity_consoles: Dictionary = {}

# Container to hold all the console panels
@onready var console_container: VBoxContainer

# Signal to emit when a new console is created (optional, for external listeners)
signal console_created(entity_name: String)

func _ready():
	# Create the main container if it doesn't exist
	if not console_container:
		console_container = VBoxContainer.new()
		console_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(console_container)
	
	# Set up the main container properties
	console_container.add_theme_constant_override("separation", 10)

# Main function to receive messages - connect this to your signal
func receive_message(origin_entity: String, message: String) -> void:
	# Create console for entity if it doesn't exist
	if not entity_consoles.has(origin_entity):
		_create_entity_console(origin_entity)
	
	# Add message to the appropriate console
	_add_message_to_console(origin_entity, message)

# Creates a new console panel for an entity
func _create_entity_console(entity_name: String) -> void:
	# Main panel container
	var panel_container := PanelContainer.new()
	panel_container.custom_minimum_size = Vector2(400, 200)
	
	# VBox to organize title and content
	var vbox := VBoxContainer.new()
	panel_container.add_child(vbox)
	
	# Title label
	var title_label = Label.new()
	title_label.text = entity_name
	title_label.add_theme_font_size_override("font_size", 16)
	title_label.add_theme_color_override("font_color", Color.CYAN)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title_label)
	
	# Scroll container for messages
	var scroll_container := ScrollContainer.new()
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_container.custom_minimum_size.y = 150
	vbox.add_child(scroll_container)
	
	# Rich text label for messages
	var rich_text_label := RichTextLabel.new()
	rich_text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rich_text_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rich_text_label.bbcode_enabled = true
	rich_text_label.scroll_following = true
	rich_text_label.fit_content = true
	scroll_container.add_child(rich_text_label)
	
	# Store references
	entity_consoles[entity_name] = {
		"panel": panel_container,
		"rich_text": rich_text_label,
		"scroll": scroll_container
	}
	
	# Add to main container
	console_container.add_child(panel_container)
	
	# Emit signal for external listeners
	console_created.emit(entity_name)

# Adds a message to a specific entity's console
func _add_message_to_console(entity_name: String, message: String) -> void:
	if not entity_consoles.has(entity_name):
		return
	
	var rich_text: RichTextLabel = entity_consoles[entity_name]["rich_text"]
	var timestamp := Time.get_datetime_string_from_system().split(" ")[1] # Get time only
	
	# Format message with timestamp and color
	var formatted_message := "[color=gray][%s][/color] %s\n" % [timestamp, message]
	
	# Append message
	rich_text.append_text(formatted_message)
	
	# Auto-scroll to bottom
	var scroll: ScrollContainer = entity_consoles[entity_name]["scroll"]
	# Use call_deferred to ensure the scroll happens after the text is added
	call_deferred("_scroll_to_bottom", scroll)

# Helper function to scroll to bottom
func _scroll_to_bottom(scroll_container: ScrollContainer) -> void:
	var v_scroll := scroll_container.get_v_scroll_bar()
	v_scroll.value = v_scroll.max_value

# Public function to clear a specific entity's console
func clear_entity_console(entity_name: String) -> void:
	if entity_consoles.has(entity_name):
		entity_consoles[entity_name]["rich_text"].clear()

# Public function to clear all consoles
func clear_all_consoles() -> void:
	for entity_name in entity_consoles.keys():
		clear_entity_console(entity_name)

# Public function to remove an entity's console entirely
func remove_entity_console(entity_name: String) -> void:
	if entity_consoles.has(entity_name):
		entity_consoles[entity_name]["panel"].queue_free()
		entity_consoles.erase(entity_name)

# Public function to get all active entity names
func get_active_entities() -> Array[String]:
	var entities: Array[String] = []
	for entity in entity_consoles.keys():
		entities.append(entity)
	return entities

# Example usage function - you can remove this
func _example_usage():
	# Example of how to connect and use this system
	# In another script, you would do:
	# message_ui.receive_message("Player", "Hello world!")
	# message_ui.receive_message("Enemy", "Target acquired!")
	# message_ui.receive_message("Player", "Taking damage!")
	
	receive_message("Player", "Game started")
	receive_message("Enemy AI", "Patrolling area")
	receive_message("System", "Level loaded successfully")
	receive_message("Player", "Health: 100%")
	receive_message("Enemy AI", "Player detected!")
