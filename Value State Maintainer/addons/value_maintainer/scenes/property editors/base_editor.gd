class_name BaseThemeEditorProperty extends EditorProperty

const HIGHLIGHT_COLOR := Color.BURLYWOOD
const DEFAULT_COLOR := Color.WHITE
const BUTTON_ICON = preload("res://addons/value_maintainer/icons/Brush.svg")

const COLOR_ACCESS = preload("res://addons/value_maintainer/global_modals/color_access.gd")
const CONSTANTS = COLOR_ACCESS.CONSTANTS
const VALUE_REGISTER = preload("res://addons/value_maintainer/global_modals/value_register.gd")
const POPUP_MANAGER = preload("res://addons/value_maintainer/global_modals/popup/popup_manager.gd")

var _updating : bool = false
var _revert : bool = true
var _current_value

var _editor : Control
var _pallet_button_outline : StyleBoxFlat = StyleBoxFlat.new()
var _pallet_button : Button = Button.new()

func _ready() -> void:
	for c : Node in get_children(true):
		c.queue_free()
	
	var property_control = HBoxContainer.new()
	
	_editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	property_control.add_child(_editor)
	add_focusable(_editor)
	
	var panel_container : PanelContainer = PanelContainer.new()
	panel_container.custom_minimum_size = Vector2(32, 32)
	panel_container.add_theme_stylebox_override("panel", _pallet_button_outline)
	property_control.add_child(panel_container)
	
	_pallet_button_outline.bg_color.a = 0
	_pallet_button_outline.set_border_width_all(2)
	_pallet_button_outline.border_color = Color(1, 1, 1, 0)
	
	_pallet_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_pallet_button.icon = BUTTON_ICON
	_pallet_button.expand_icon = true
	_pallet_button.flat = true
	
	_pallet_button.pressed.connect(_on_pallet_button_pressed)
	add_focusable(_pallet_button)
	panel_container.add_child(_pallet_button)
	
	add_child(property_control)
	_toggle_button(VALUE_REGISTER.is_registered(get_edited_object(), get_edited_property()))
func _set_default(value) -> void:
	_current_value = value

func _update_property():
	var new_value = get_edited_object()[get_edited_property()]
	
	if !_revert: VALUE_REGISTER.unregister(get_edited_object(), get_edited_property())
	if new_value != _current_value:
		_current_value = new_value
		_set_edit_value(new_value)
	_toggle_button(VALUE_REGISTER.is_registered(get_edited_object(), get_edited_property()))
	_revert = false
func _set_read_only(read_only: bool) -> void:
	if read_only:
		_disable_edit_value(true)
		_pallet_button.disabled = true
		return
	_disable_edit_value(VALUE_REGISTER.is_registered(get_edited_object(), get_edited_property()))
	_pallet_button.disabled = false

func _on_value_change(value : Variant) -> void:
	if _updating || _revert: return
	emit_changed(get_edited_property(), value)
func _on_pallet_button_pressed() -> void:
	_revert = true
	await _open_popup()
	_update_object_property()

func _toggle_button(toggle : bool) -> void:
	if toggle:
		_pallet_button_outline.border_color.a = 0.5
		_pallet_button.modulate = HIGHLIGHT_COLOR
		_disable_edit_value(true)
		return
	_pallet_button_outline.border_color.a = 0
	_pallet_button.modulate = DEFAULT_COLOR
	_disable_edit_value(read_only)

func _set_edit_value(value : Variant) -> void: pass
func _open_popup() -> void: pass
func _disable_edit_value(toggle : bool) -> void: pass
func _update_object_property() -> void: pass
