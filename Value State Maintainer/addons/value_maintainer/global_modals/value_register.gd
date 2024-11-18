@tool
extends Object

const META_KEY := "__theme_maintainer__"

static func register(obj : Object, property : StringName, val : Variant) -> void:
	if !(property in obj): return
	if obj.has_meta(META_KEY):
		obj.get_meta(META_KEY)[property] = val
	else:
		obj.set_meta(META_KEY, { property: val })
static func unregister(obj : Object, property : StringName) -> void:
	if obj.has_meta(META_KEY):
		var properties : Dictionary = obj.get_meta(META_KEY)
		properties.erase(property)
		if properties.is_empty():
			obj.remove_meta(META_KEY)
static func is_registered(obj : Object, property : StringName) -> bool:
	return obj && obj.get_meta(META_KEY, {}).has(property)
static func is_registered_object(obj : Object) -> bool:
	return obj && obj.has_meta(META_KEY)
static func get_registered_properties(obj : Object) -> Variant:
	return obj.get_meta(META_KEY, {}).keys()
static func get_registered_value(obj : Object, property : StringName) -> Variant:
	return obj.get_meta(META_KEY, {}).get(property, null)
