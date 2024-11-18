@tool
extends Node

signal pallet_loaded
signal pallet_saved
signal mode_switched

const CONSTANTS := preload("res://addons/value_maintainer/global_modals/global_values.gd")
const VALUE_REGISTER = preload("res://addons/value_maintainer/global_modals/value_register.gd")

var _color_storage := preload("res://addons/value_maintainer/global_modals/color_storage.gd").new()

var _isDark : bool = false

func _ready() -> void:
	_color_storage.pallet_loaded.connect(pallet_loaded.emit)
	_color_storage.pallet_saved.connect(pallet_saved.emit)
	_color_storage.load_pallet()
func free() -> void:
	_color_storage.free()

func get_color_storage():
	return _color_storage
func swap_pallet(filepath : String, load_state : bool = false, save : bool = true) -> void:
	_color_storage.swap_pallet(filepath, load_state, save)
	scan()
func get_color_pallet() -> Dictionary:
	return _color_storage.pallet
func is_color_pallet_saved() -> bool:
	return _color_storage.saved

func change_state(dark : bool) -> void:
	if _isDark == dark: return
	_isDark = dark
	scan()
func isDark() -> bool:
	return _isDark

func scan() -> void:
	if Engine.is_editor_hint():
		_scan_recursive(EditorInterface.get_edited_scene_root())
	else:
		_scan_recursive(get_tree().current_scene)
	
	if Engine.is_editor_hint():
		var edited_obj : Object = EditorInterface.get_inspector().get_edited_object()
		if edited_obj: edited_obj.notify_property_list_changed()
func _scan_recursive(parent : Node) -> void:
	if !parent: return
	for property in VALUE_REGISTER.get_registered_properties(parent):
		match typeof(parent[property]):
			TYPE_COLOR:
				parent[property] = _color_storage.COLOR_ACCESS.get_color(VALUE_REGISTER.get_registered_value(parent, property))
			_:
				parent[property] = VALUE_REGISTER.get_registered_value(parent, property)[1 if _isDark else 0]
	
	var children : Array[Node] = parent.get_children(true)
	for child in children: _scan_recursive(child)
