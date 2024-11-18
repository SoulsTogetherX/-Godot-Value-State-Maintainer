@tool
extends Object

static func get_long_name(type : int) -> Variant:
	match type:
		TYPE_COLOR:
			return "Color"
		TYPE_PACKED_COLOR_ARRAY:
			return "Dual"
		TYPE_DICTIONARY:
			return "Group"
	return null
static func get_extension(type : int) -> Variant:
	match type:
		TYPE_COLOR:
			return "c"
		TYPE_PACKED_COLOR_ARRAY:
			return "d"
		TYPE_DICTIONARY:
			return ""
	return null
static func is_vaild_filename(filename : String, type : int) -> bool:
	if !filename: return false
	
	var suffix : String = get_extension(type)
	if filename.ends_with(suffix):
		return true
	return false
static func vaildate_filename(filename : String, type : int) -> String:
	if !filename: return ""
	
	var suffix : String = get_extension(type)
	if filename.ends_with(suffix):
		return filename
	if filename.ends_with("."):
		return filename + suffix
	return filename + "." + suffix
