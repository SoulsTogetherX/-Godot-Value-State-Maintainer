@tool
extends Object

signal pallet_loaded
signal pallet_saved

const COLOR_ACCESS = preload("res://addons/value_state_maintainer/global_modals/color_access.gd")

const BASE_FOLDER := "res://addons/value_state_maintainer/pallet_save/"
const DEFAULT_SAVE_PATH := "pallet_data.json"

static var pallet_accessor : Node
static var _storage_path := DEFAULT_SAVE_PATH
static var _saved : bool = false

static func queue_save() -> void:
	_saved = false
func is_saved() -> bool:
	return _saved

func swap_pallet(newFile : String, load_state: bool = false, save : bool = true) -> void:
	if save: save_pallet()
	_storage_path = newFile
	_saved = false
	load_pallet(load_state)
func save_pallet() -> void:
	if _saved: return
	_saved = true
	
	var filepath := BASE_FOLDER + _storage_path
	var file := FileAccess.open(filepath, FileAccess.WRITE)
	var save_pallet := COLOR_ACCESS.pallet.duplicate(true)
	_reformate_save(save_pallet)
	file.store_string(JSON.stringify({
		"data": save_pallet,
		"state": pallet_accessor.isDark()
	}))
	file.close()
	EditorInterface.get_resource_filesystem().scan()
	pallet_saved.emit()
func load_pallet(load_state : bool = false) -> void:
	if _saved: return
	_saved = true
	var filepath := BASE_FOLDER + _storage_path
	
	if FileAccess.file_exists(filepath):
		var file := FileAccess.open(filepath, FileAccess.READ)
		var data : Dictionary = JSON.parse_string(file.get_line())
		COLOR_ACCESS.pallet = data.data
		if load_state:
			pallet_accessor.set_state(data.state)
		file.close()
		_reformate_load(COLOR_ACCESS.pallet)
		pallet_loaded.emit()
		return
	
	var file := FileAccess.open(filepath, FileAccess.WRITE)
	file.store_string(JSON.stringify({}))
	file.close()
	EditorInterface.get_resource_filesystem().scan()
	COLOR_ACCESS.pallet = {}
	pallet_accessor.set_state(false)
	pallet_loaded.emit()

func _reformate_save(curr : Variant) -> void:
	for key in curr.keys():
		var val : Variant = curr[key]
		match typeof(val):
			TYPE_DICTIONARY:
				_reformate_save(val)
			TYPE_COLOR:
				if val.a != 1.0:
					curr[key] = val.to_html(true)
				else:
					curr[key] = val.to_html()
			TYPE_PACKED_COLOR_ARRAY:
				var arr := []
				for color : Color in val:
					if color.a != 1.0:
						arr.append(color.to_html(true))
					else:
						arr.append(color.to_html())
				curr[key] = arr
func _reformate_load(curr : Dictionary) -> void:
	for key in curr.keys():
		var val : Variant = curr[key]
		match typeof(val):
			TYPE_DICTIONARY:
				_reformate_load(val)
			TYPE_STRING:
				curr[key] = Color(val)
			TYPE_ARRAY:
				var arr : PackedColorArray = []
				for code : String in val:
					arr.append(Color(code))
				curr[key] = arr
