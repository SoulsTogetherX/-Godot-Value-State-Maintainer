@tool
extends Object

const META_KEY := "__value_maintainer__"
const META_KEY_ARRAY := "__value_maintainer_array__"

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



static func register_array_index(
		obj : Object,
		array_path : StringName,
		index : int,
		val : Variant
	) -> void:
	if !(array_path in obj): return
	if obj.has_meta(META_KEY_ARRAY):
		obj.get_meta(META_KEY_ARRAY).get_or_add(array_path, {})[index] = val
	else:
		obj.set_meta(META_KEY_ARRAY, { array_path: { index: val } })
static func unregister_array(
		obj : Object,
		array_path : StringName
	) -> void:
	if obj.has_meta(META_KEY_ARRAY):
		var properties : Dictionary = obj.get_meta(META_KEY_ARRAY)
		properties[array_path].clear()
		properties.erase(array_path)
		if properties.is_empty():
			obj.remove_meta(META_KEY_ARRAY)
static func unregister_array_index(
		obj : Object,
		array_path : StringName,
		index : int
	) -> void:
	if obj.has_meta(META_KEY_ARRAY):
		var properties : Dictionary = obj.get_meta(META_KEY_ARRAY)
		if properties.has(array_path):
			var indexes : Dictionary = properties.get(array_path)
			indexes.erase(index)
			if indexes.is_empty():
				properties.erase(array_path)
				if properties.is_empty():
					obj.remove_meta(META_KEY_ARRAY)
static func is_registered_array_index(
		obj : Object,
		array_path : StringName,
		index : int
	) -> bool:
	return obj && obj.get_meta(META_KEY_ARRAY, {}).get(array_path, {}).has(index)
static func is_registered_array(
		obj : Object,
		array_path : StringName
	) -> bool:
	return obj && obj.get_meta(META_KEY_ARRAY, {}).has(array_path)
static func get_registered_arrays(
		obj : Object
	) -> Array:
	return obj.get_meta(META_KEY_ARRAY, {}).keys()
static func get_registered_array_indexes(
		obj : Object,
		array_path : StringName
	) -> Array:
	return  obj.get_meta(META_KEY_ARRAY, {}).get(array_path, {}).keys()
static func get_registered_array_value(
		obj : Object,
		array_path : StringName,
		index : int
	) -> Variant:
	return obj.get_meta(META_KEY_ARRAY, {}).get(array_path, {}).get(index, null)
