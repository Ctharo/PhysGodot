extends Resource
class_name Iterator
var _collection :
	set(value):
		_collection = value
		end = _collection.size()

var index: int = 0
var start: int = 0
var current: int
var end: int

var increment = 1

func _init(collection = []):
	_collection = collection
	current = start

func should_continue():
	return (current < end)

func _iter_init(_arg):
	current = start
	end = _collection.size()
	return should_continue()

func _iter_next(_arg):
	current += increment
	return should_continue()

func _iter_get(_arg):
	return _collection[current]
