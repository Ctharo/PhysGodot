extends Resource
class_name Iterator
var collection = []
var index = 0
var start = 0
var current
var end: int : get = collection.size()

var increment = 1

func _init(_collection):
	collection = _collection
	current = start
	end = collection.size()

func add_to_collection(item: Object):
	collection.add(item)
	end = collection.size()

func _next():
	if index >= collection.size():
		return null
	var result = collection[index]
	index += 1
	return result

func should_continue():
	return (current < end)

func _iter_init(_arg):
	current = start
	end = collection.size()
	return should_continue()

func _iter_next(_arg):
	current += increment
	return should_continue()

func _iter_get(_arg):
	return current
