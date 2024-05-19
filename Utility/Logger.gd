extends Node

enum Verbosity { VERBOSE, DEBUG, NORMAL, IMPORTANT, WARNING, ERROR }

var settings: Resource = load("res://Settings.tres")
var events: Array[Event] = [] as Array[Event]

func log_event(message: String, sender: Node, verbosity: Logger.Verbosity = Logger.Verbosity.VERBOSE) -> void:
	if verbosity < settings.LOGGING_LEVEL:
		return
	if not sender:
		printerr("Problem logging event: No sender")
		return
	var event: Event = Event.new(
		message,
		sender,
		verbosity,
		Time.get_ticks_msec(),
		Time.get_datetime_string_from_datetime_dict(Time.get_datetime_dict_from_system(), true)
	)
	events.append(event)
	
	if not event in events:
		printerr("Problem logging event")
		return
	
	# Define fixed lengths for alignment
	var verbosity_length: int = 10
	var tick_length: int = 6
	var sender_name_length: int = 16
	
	var verbosity_str: String = "[" + Verbosity.keys()[verbosity] + "]"
	var tick_str: String = str(event.game_time_stamp)
	var sender_name_str: String = event.sender.name
	
	# Pad the strings to ensure alignment
	verbosity_str = verbosity_str.rpad(verbosity_length)
	tick_str = tick_str.rpad(tick_length)
	sender_name_str = sender_name_str.rpad(sender_name_length)
	
	var s: String = "%s: Tick %s: %s -> %s" % [
		verbosity_str,
		tick_str,
		sender_name_str,
		event.message
	]
	
	if verbosity == Verbosity.ERROR:
		printerr(s)
		push_error(s)
	elif verbosity == Verbosity.WARNING:
		print(s)
		push_warning(s)
	else:
		print(s)

func log_debug(message: String, sender: Node) -> void:
	log_event(message, sender, Verbosity.DEBUG)

func log_warning(message: String, sender: Node) -> void:
	log_event(message, sender, Verbosity.WARNING)
	
func log_verbose(message: String, sender: Node) -> void:
	log_event(message, sender, Verbosity.VERBOSE)
		
func log_error(message: String, sender: Node) -> void:
	log_event(message, sender, Verbosity.ERROR)

class Event:
	var message: String
	var sender: Node
	var verbosity: Verbosity
	var game_time_stamp: int
	var real_time_stamp: String
	
	func _init(message: String = "", sender: Node = null, verbosity: Verbosity = Verbosity.NORMAL, game_time_stamp: int = 0, real_time_stamp: String = "") -> void:
		self.message = message
		self.sender = sender
		self.verbosity = verbosity
		self.game_time_stamp = game_time_stamp
		self.real_time_stamp = real_time_stamp

	
