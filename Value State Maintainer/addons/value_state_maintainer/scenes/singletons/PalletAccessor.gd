@tool
extends Node

signal pallet_loaded
signal pallet_saved
signal mode_switched

const CONSTANTS := preload("res://addons/value_state_maintainer/global_modals/global_values.gd")
const _VALUE_REGISTER = preload("res://addons/value_state_maintainer/global_modals/value_register.gd")

var _color_storage := preload("res://addons/value_state_maintainer/global_modals/color_storage.gd").new()

var _isDark : bool = false

func _ready() -> void:
	preload("res://addons/value_state_maintainer/global_modals/color_access.gd").pallet_accessor = self
	preload("res://addons/value_state_maintainer/global_modals/color_storage.gd").pallet_accessor = self
	preload("res://addons/value_state_maintainer/global_modals/popup/popup_manager.gd").pallet_accessor = self
	
	_color_storage.pallet_loaded.connect(pallet_loaded.emit)
	_color_storage.pallet_saved.connect(pallet_saved.emit)
	_color_storage.load_pallet()
func free() -> void:
	_color_storage.free()
	super()

## Gets the color storage module currently in use.
##
## Do not free this or else a crash is likely
func get_color_storage():
	return _color_storage
## Swaps the current pallet to a newly saved color pallet, or creates a new color pallet at given file location
##
## All saves are stored from the base folder '"res://addons/value_state_maintainer/pallet_save/"'
##
## load_state, if true, will overwrite the current light/dark mode with the mode this pallet had before being swapped
##
## save, if false, the color pallet will not automatically save upon being swapped
func swap_pallet(filepath : String, load_state : bool = false, save : bool = true) -> void:
	_color_storage.swap_pallet(filepath, load_state, save)
	scan()
## Gets the current pallet of saved colors (Shallow copy)
func get_color_pallet() -> Dictionary:
	return _color_storage.pallet
## Returns if the color pallet has been saved
func is_color_pallet_saved() -> bool:
	return _color_storage.saved

## Sets the current mode to light or dark
func set_state(dark : bool) -> void:
	if _isDark == dark: return
	_isDark = dark
	scan()
## Swaps the mode form dark to light, or light to dark
func swap_state() -> void:
	_isDark = !_isDark
	scan()
## Returns true if the mose is dark
func isDark() -> bool:
	return _isDark

## Updates all the node values in the current scene tree
func scan() -> void:
	if Engine.is_editor_hint():
		_scan_recursive(EditorInterface.get_edited_scene_root())
	else:
		_scan_recursive(get_tree().current_scene)
	
	if Engine.is_editor_hint():
		var edited_obj : Object = EditorInterface.get_inspector().get_edited_object()
		if edited_obj: edited_obj.notify_property_list_changed()
func _scan_recursive(obj : Object) -> void:
	if !obj: return
	_VALUE_REGISTER.validate_registered_properties(obj)
	
	for property in _VALUE_REGISTER.get_registered_properties(obj):
		match typeof(obj[property]):
			TYPE_COLOR:
				obj[property] = _color_storage.COLOR_ACCESS.get_color(_VALUE_REGISTER.get_registered_value(obj, property))
			_:
				obj[property] = _VALUE_REGISTER.get_registered_value(obj, property)[1 if _isDark else 0]
	
	for resource in _VALUE_REGISTER.get_resource_properties(obj):
		_scan_recursive(resource)
	if obj is Node:
		var children : Array[Node] = obj.get_children(true)
		for child in children: _scan_recursive(child)
