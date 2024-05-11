extends Node

enum Verbosity { VERBOSE, DEBUG, NORMAL, IMPORTANT, WARNING, ERROR }

var events: Array[Event] = [] as Array[Event]

func log_event(message: String, sender: Node, verbosity: Logger.Verbosity = Logger.Verbosity.VERBOSE) -> void:
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
		
	if verbosity == Verbosity.ERROR:
		printerr("Tick %s: %s -> %s" % [event.game_time_stamp, event.sender.name, event.message])
	else:
		print("Tick %s: %s -> %s" % [event.game_time_stamp, event.sender.name, event.message])

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

	
