extends Object

const CONSTANTS = preload("res://addons/value_state_maintainer/global_modals/global_values.gd")
const POPUP_MANAGER = preload("res://addons/value_state_maintainer/global_modals/popup/popup_manager.gd")
const VALUE_REGISTER = preload("res://addons/value_state_maintainer/global_modals/value_register.gd")

const POPUP_COLOR = preload("res://addons/value_state_maintainer/scenes/popups/popup_register/popup_color/popup_color.tscn")
const POPUP_NUMBER = preload("res://addons/value_state_maintainer/scenes/popups/popup_register/popup_number/popup_number.tscn")

func popup_add() -> void:
	var color_popup : Window = POPUP_COLOR.instantiate()
	POPUP_MANAGER.add_to_cache(CONSTANTS.COLOR_POPUP_ID, color_popup)
	color_popup.register.connect(_on_register)
	color_popup.unregister.connect(_on_unregister)
	
	var number_popup : Window = POPUP_NUMBER.instantiate()
	POPUP_MANAGER.add_to_cache(CONSTANTS.NUMBER_POPUP_ID, number_popup)
	number_popup.register.connect(_on_register)
	number_popup.unregister.connect(_on_unregister)
func popup_remove() -> void:
	POPUP_MANAGER.remove_from_cache(CONSTANTS.COLOR_POPUP_ID)
	POPUP_MANAGER.remove_from_cache(CONSTANTS.NUMBER_POPUP_ID)

func _on_register(obj : Object, property : StringName, value : Variant) -> void:
	VALUE_REGISTER.register(obj, property, value)
func _on_unregister(obj : Object, property : StringName) -> void:
	VALUE_REGISTER.unregister(obj, property)
