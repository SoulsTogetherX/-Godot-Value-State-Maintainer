@tool
extends Object

const CONSTANTS := preload("res://addons/value_state_maintainer/global_modals/global_values.gd")
const COLOR_STORAGE = preload("res://addons/value_state_maintainer/global_modals/color_storage.gd")
const DEFAULT_FILE_PATH := "res://addons/value_state_maintainer/pallet_save/pallet_data.json"

static var pallet_accessor : Node
static var pallet : Dictionary

static func get_direct(pathStr : String) -> Variant:
	var path := pathStr.split("/")
	
	var value : Variant = pallet
	for key in path.slice(1):
		if typeof(value) != TYPE_DICTIONARY || !value.has(key):
			return null
		value = value[key]
	return value
static func get_color(pathStr : String) -> Color:
	var value : Variant = get_direct(pathStr)
	match typeof(value):
		TYPE_PACKED_COLOR_ARRAY:
			return value[1 if pallet_accessor.isDark() else 0]
		TYPE_COLOR:
			return value
	return CONSTANTS.DEFAULT_COLOR
static func set_color(pathStr : String, set_val : Variant) -> void:
	var path := pathStr.split("/")
	var fileName := path[path.size() - 1]
	
	var value : Variant = pallet
	for key in path.slice(1, path.size() - 1):
		if typeof(value) != TYPE_DICTIONARY: return
		value = value.get_or_add(key, {})
	
	if value.has(fileName) && typeof(value[fileName]) != typeof(set_val):
		push_error("Attempted to set a value, in the 'Color Accessor', with an incompatible value type")
		return
	value[fileName] = set_val
	COLOR_STORAGE.queue_save()
static func remove_color(pathStr : String) -> void:
	var path := pathStr.split("/")
	var fileName := path[path.size() - 1]
	
	var value : Variant = pallet
	for key in path.slice(1, path.size() - 1):
		if typeof(value) != TYPE_DICTIONARY || !value.has(key): return
		value = value[key]
	value.erase(fileName)
	
	COLOR_STORAGE.queue_save()
static func rename_color(oldPathStr : String, newPathStr : String) -> bool:
	var oldPath := oldPathStr.split("/")
	var newPath := newPathStr.split("/")
	var oldFileName : String = oldPath[oldPath.size() - 1]
	var newFileName : String = newPath[newPath.size() - 1]
	
	var oldValue : Variant = pallet
	for key in oldPath.slice(1, oldPath.size() - 1):
		if !oldValue.has(key): return false
		oldValue = oldValue[key]
		if typeof(oldValue) != TYPE_DICTIONARY: return false
	if !oldValue.has(oldFileName): return false
	
	var newValue : Variant = pallet
	for key in newPath.slice(1, newPath.size() - 1):
		newValue = newValue.get_or_add(key, {})
		if typeof(newValue) != TYPE_DICTIONARY: return false
	if newValue.has(newFileName): return false
	
	newValue[newFileName] = oldValue[oldFileName]
	oldValue.erase(oldFileName)
	COLOR_STORAGE.queue_save()
	
	return true
static func rename_color_direct(pathStr : String, fileName : String) -> bool:
	var path := pathStr.split("/")
	var oldFileName : String = path[path.size() - 1]
	
	var value : Variant = pallet
	for key in value.slice(1, value.size() - 2):
		value = value.get_or_add(key, {})
		if typeof(value) != TYPE_DICTIONARY: return false
	if value.has(fileName): return false
	
	value[fileName] = value[oldFileName]
	value.erase(oldFileName)
	COLOR_STORAGE.queue_save()
	
	return true

static func file_exists(pathStr : String) -> bool:
	return get_direct(pathStr) != null
static func path_vaild(pathStr : String, filename : String) -> bool:
	var value = get_direct(pathStr)
	if typeof(value) == TYPE_DICTIONARY:
		return !value.has(filename)
	return false
static func get_path_to(item : TreeItem) -> String:
	var pathStr := ""
	var strStack : PackedStringArray = []
	
	while item:
		strStack.append(item.get_text(0))
		item = item.get_parent()
	for i in range(strStack.size() - 1, -1, -1):
		pathStr = pathStr.path_join(strStack[i])
	
	return pathStr
