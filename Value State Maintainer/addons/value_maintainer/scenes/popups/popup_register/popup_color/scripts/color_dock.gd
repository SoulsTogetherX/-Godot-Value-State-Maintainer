@tool
extends PanelContainer

const COLOR_ACCESS = preload("res://addons/value_maintainer/global_modals/color_access.gd")

@onready var _color_picker : ColorPicker = $"VBoxContainer/Color Dock/ColorPicker"
@onready var _tab_bar : TabBar = $VBoxContainer/MarginContainer/HBoxContainer/TabBar
@onready var _revert_button : Button = $"../../Bottom Dialog/CenterContainer/HBoxContainer/Revert"
@onready var _save_button : Button = $"../../Bottom Dialog/CenterContainer/HBoxContainer/Save"

var _unsaved_light_color : Color
var _unsaved_dark_color : Color

var _light_color : Color
var _dark_color : Color

var _current_item : TreeItem

func _ready() -> void:
	_color_picker.color_changed.connect(_color_changed)
	_tab_bar.tab_changed.connect(_switch_color)
	_revert_button.pressed.connect(_revert_color)
	_save_button.pressed.connect(_save_color)
	
	owner.close_requested.connect(hide_dock)

func open_dock(item : TreeItem) -> void:
	_save_color()
	
	var value : Variant = item.get_metadata(0)
	match typeof(value):
		TYPE_COLOR:
			_unsaved_light_color = value
			_light_color = value
			
			_tab_bar.visible = false
			_color_picker.color = value
		TYPE_PACKED_COLOR_ARRAY:
			if value.size() < 2: return
			
			_unsaved_light_color = value[0]
			_light_color = value[0]
			_unsaved_dark_color = value[1]
			_dark_color = value[1]
			
			_tab_bar.visible = true
			_color_picker.color = _dark_color if _tab_bar.current_tab == 1 else _light_color
		_:
			return
	
	_current_item = item
	visible = true
func hide_dock() -> void:
	_save_color()
	
	visible = false
	_current_item = null

func get_color() -> Color:
	return _light_color
func get_duel_colors() -> PackedColorArray:
	return [_light_color, _dark_color]
func get_duel_color(dark : bool) -> Color:
	return _dark_color if dark else _light_color

func _color_changed(color : Color) -> void:
	if _tab_bar.current_tab == 1 && _tab_bar.visible:
		_dark_color = color
	else:
		_light_color = color
	_update_revert()
func _switch_color(tab : int) -> void:
	_color_picker.color = _dark_color if (tab == 1) else _light_color
	_save_color()
	_update_revert()

func _save_color() -> void:
	if !_current_item: return
	
	var color_value : Variant
	match typeof(_current_item.get_metadata(0)):
		TYPE_COLOR:
			color_value = get_color()
		TYPE_PACKED_COLOR_ARRAY:
			color_value = get_duel_colors()
		_:
			return
	
	_unsaved_light_color = _light_color
	_unsaved_dark_color = _dark_color
	_disable_buttons()
	
	COLOR_ACCESS.set_color(
		COLOR_ACCESS.get_path_to(_current_item),
		color_value
		)
	_current_item.set_metadata(0, color_value)
	owner.update_icon(_current_item)

func _update_revert() -> void:
	_revert_button.disabled = (_color_picker.color == (_unsaved_dark_color if (_tab_bar.current_tab == 1) else _unsaved_light_color))
	_save_button.disabled = _revert_button.disabled
func _revert_color() -> void:
	_color_picker.color = (_unsaved_dark_color if (_tab_bar.current_tab == 1) else _unsaved_light_color)
	_light_color = _unsaved_light_color
	_dark_color = _unsaved_dark_color
	_disable_buttons()
func _disable_buttons() -> void:
	_revert_button.disabled = true
	_save_button.disabled = true
