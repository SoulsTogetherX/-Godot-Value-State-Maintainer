@tool
extends Node

signal update_tree(filename : String, value : Variant)

const COLOR_ACCESS := preload("res://addons/value_maintainer/global_modals/color_access.gd")
const CONSTANTS := COLOR_ACCESS.CONSTANTS

@onready var _popup_create: ConfirmationDialog = $"Popup Create"

var _valuetype : int

func _ready() -> void:
	_popup_create.confirmed.connect(create_file)

func open_popup(valuetype : int, filepath : String) -> void:
	_valuetype = valuetype
	
	_popup_create.set_labels(valuetype, filepath)
	_popup_create.show_select()
func close_popup() -> void:
	_popup_create.hide()
func create_file() -> void:
	var filename : String = _popup_create.get_filepath()
	var defaultValue : Variant
	match _valuetype:
		TYPE_COLOR:
			defaultValue = CONSTANTS.DEFAULT_COLOR
		TYPE_PACKED_COLOR_ARRAY:
			defaultValue = [
				CONSTANTS.DEFAULT_COLOR,
				CONSTANTS.DEFAULT_COLOR
			] as PackedColorArray
		TYPE_DICTIONARY:
			defaultValue = {}
	
	COLOR_ACCESS.set_color(filename, defaultValue)
	update_tree.emit(filename, defaultValue)
	_popup_create.hide()
