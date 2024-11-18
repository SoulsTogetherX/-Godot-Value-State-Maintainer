extends BaseThemeEditorProperty

func init():
	_editor = ColorPickerButton.new()
	_editor.color_changed.connect(_on_value_change)
	_set_default(CONSTANTS.DEFAULT_COLOR)

func _set_edit_value(value : Variant) -> void:
	if value is Color:
		_editor.color = value
func _disable_edit_value(toggle : bool) -> void:
	_editor.disabled = toggle

func _open_popup() -> void:
	POPUP_MANAGER.show(CONSTANTS.COLOR_POPUP_ID)
	await POPUP_MANAGER.popup.close_requested

func _update_object_property() -> void:
	var path = VALUE_REGISTER.get_registered_value(
				get_edited_object(),
				get_edited_property()
				)
	if path == null:
		_toggle_button(false)
		return
	emit_changed(
		get_edited_property(),
		COLOR_ACCESS.get_color(path)
	)
