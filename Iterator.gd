extends Resource
class_name Iterator
var collection
var index = 0

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
