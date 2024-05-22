extends Node
class_name Cacheable

var cache: Dictionary = {}

# Method to get a cached value or calculate it if not present
func get_cached_value(key: String, calculator: Callable) -> Variant:
	if cache.has(key):
		return cache[key]
	@warning_ignore("untyped_declaration")
	var value = calculator.call()
	cache[key] = value
	return value

# Method to invalidate the cache
func invalidate_cache(key: String) -> void:
	cache.erase(key)

# Method to invalidate all cache
func invalidate_all_cache() -> void:
	cache.clear()
