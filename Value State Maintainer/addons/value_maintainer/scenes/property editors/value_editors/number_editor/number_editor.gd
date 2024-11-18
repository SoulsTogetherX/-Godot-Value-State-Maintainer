extends ValueThemeEditorProperty
func init():
	_editor = EditorSpinSlider.new()
	_editor.allow_greater = true
	_editor.allow_lesser = true
	
	_editor.value_changed.connect(_on_value_change)
	_set_default(0)

func _set_edit_value(value : Variant) -> void:
	if value is int || value is float:
		_editor.value = value
func _disable_edit_value(toggle : bool) -> void:
	_editor.read_only = toggle

func _open_popup() -> void:
	_light_editor = SpinBox.new()
	_light_editor.allow_greater = true
	_light_editor.allow_lesser = true
	
	_dark_editor = SpinBox.new()
	_dark_editor.allow_greater = true
	_dark_editor.allow_lesser = true
	
	if VALUE_REGISTER.is_registered(get_edited_object(), get_edited_property()):
		var values : Array = VALUE_REGISTER.get_registered_value(get_edited_object(), get_edited_property())
		_light_editor.value = values[0]
		_dark_editor.value = values[1]
	else:
		var value = get_edited_object()[get_edited_property()]
		_light_editor.value = value
		_dark_editor.value = value
	
	POPUP_MANAGER.show(CONSTANTS.NUMBER_POPUP_ID)
	POPUP_MANAGER.popup.init(_light_editor, _dark_editor, get_values)
	await POPUP_MANAGER.popup.close_requested

func get_values() -> Array:
	return [_light_editor.value, _dark_editor.value]
