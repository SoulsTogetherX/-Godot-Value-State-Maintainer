class_name ValueThemeEditorProperty extends BaseThemeEditorProperty

var _light_editor : Control
var _dark_editor : Control

func _update_object_property() -> void:
	var value : Variant = (
		VALUE_REGISTER.get_registered_array_value(array_object, property_path, index)
		if is_array else
		VALUE_REGISTER.get_registered_value(get_edited_object(), get_edited_property())
	)
	if value == null:
		_toggle_button(false)
		return
	
	emit_changed(
		get_edited_property(),
		value[1 if get_node("/root/PalletAccessor").isDark() else 0]
	)

func get_values() -> Array:
	return [null, null]
