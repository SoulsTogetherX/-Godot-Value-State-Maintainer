@tool
extends Object

const META_KEY := "__theme_maintainer__"

static func register(obj : Object, property : StringName, val : Variant) -> void:
	if !(property in obj): return
	print(obj, property)
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
static func validate_registered_properties(obj : Object) -> void:
	if is_registered_object(obj):
		var properties := get_registered_properties(obj)
		for property in properties:
			if not property in obj:
				unregister(obj, property)
static func get_resource_properties(obj : Object) -> Array:
	var ret : Array
	for property in obj.get_property_list():
		if property.hint == PROPERTY_HINT_RESOURCE_TYPE:
			var resource = obj[property.name]
			if (not resource is Node):
				ret.append(resource)
	return ret
static func is_registered(obj : Object, property : StringName) -> bool:
	return obj && obj.get_meta(META_KEY, {}).has(property)
static func is_registered_object(obj : Object) -> bool:
	return obj && obj.has_meta(META_KEY)
static func get_registered_properties(obj : Object) -> Array:
	return  obj.get_meta(META_KEY, {}).keys()
static func get_registered_value(obj : Object, property : StringName) -> Variant:
	return obj.get_meta(META_KEY, {}).get(property, null)
