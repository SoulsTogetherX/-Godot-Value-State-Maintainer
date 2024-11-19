@tool
extends EditorPlugin

const PALLET_ACCESSOR := "res://addons/value_state_maintainer/scenes/singletons/PalletAccessor.gd"

var ColorStorage := preload("res://addons/value_state_maintainer/global_modals/color_storage.gd").new()
var PopupSettup := preload("res://addons/value_state_maintainer/global_modals/popup/popup_setup.gd").new()
var plugin := preload("res://addons/value_state_maintainer/inspector_plugin.gd").new()

const MOON_ICON := preload("res://addons/value_state_maintainer/icons/Moon.svg")
const SUN_ICON := preload("res://addons/value_state_maintainer/icons/Sun.svg")

var _swap_button : Button

func _get_plugin_name() -> String:
	return "Value State Maintainer"

func _enter_tree() -> void:
	add_autoload_singleton("PalletAccessor", PALLET_ACCESSOR)
	add_inspector_plugin(plugin)
	
	var shortcut := Shortcut.new()
	shortcut.events = [InputEventKey.new()]
	shortcut.events[0].keycode = 4194342
	
	_swap_button = Button.new()
	_swap_button.set_theme_type_variation("FlatButton")
	_swap_button.shortcut = shortcut
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, _swap_button)
	
	_swap_button.pressed.connect(_swap_pallet)
	scene_changed.connect(_on_scene_change)
	
	call_deferred("_setup_singleton")
func _exit_tree() -> void:
	remove_autoload_singleton("PalletAccessor")
	remove_inspector_plugin(plugin)
	PopupSettup.popup_remove()
	
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, _swap_button)
	_swap_button.free()

func _save_external_data() -> void:
	get_node("/root/PalletAccessor").get_color_storage().save_pallet()
func _get_unsaved_status(for_scene: String) -> String:
	if for_scene.is_empty() && !ColorStorage.is_saved():
		return "Save changes in '%s' before closing?" % _get_plugin_name()
	return ""

func _on_scene_change(_scene_root : Node) -> void:
	get_node("/root/PalletAccessor").scan()
func _swap_pallet() -> void:
	var palletAccessor := get_node("/root/PalletAccessor")
	var dark : bool = !palletAccessor.isDark()
	palletAccessor.set_state(dark)
	_set_button_icon(dark)
func _set_button_icon(dark : bool) -> void:
	_swap_button.set_button_icon(MOON_ICON if dark else SUN_ICON)
	_swap_button.tooltip_text = "Swaps the current pallet in the Editor.\nCurrent Mode: " + ("Dark" if dark else "Light")

func _setup_singleton() -> void:
	var pallet_accessor := get_node("/root/PalletAccessor")
	_set_button_icon(get_node("/root/PalletAccessor").isDark())
	PopupSettup.popup_add()
