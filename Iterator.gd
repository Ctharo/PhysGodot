extends Resource
class_name Iterator
var collection
var index = 0
var start
var current
var end
var increment

func _init(collection):
	self.collection = collection

func _iter():
	return self

func _next():
	if index >= collection.size():
		return null
	var result = collection[index]
	index += 1
	return result

func should_continue():
	return (current < end)

func _iter_init(arg):
	current = start
	return should_continue()

func _iter_next(arg):
	current += increment
	return should_continue()

func _iter_get(arg):
	return current
