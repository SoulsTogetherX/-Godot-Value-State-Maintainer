@tool
extends EditorPlugin

const PALLET_ACCESSOR := "res://addons/value_maintainer/scenes/singletons/PalletAccessor.gd"

const ColorAccess = preload("res://addons/value_maintainer/global_modals/color_access.gd")
const PopupManager = preload("res://addons/value_maintainer/global_modals/popup/popup_manager.gd")

var ColorStorage := preload("res://addons/value_maintainer/global_modals/color_storage.gd").new()
var PopupSettup := preload("res://addons/value_maintainer/global_modals/popup/popup_setup.gd").new()
var plugin := preload("res://addons/value_maintainer/inspector_plugin.gd").new()

var _swap_canvus_button : Button
var _swap_spatial_button : Button

func _get_plugin_name() -> String:
	return "Value State Maintainer"

func _enter_tree() -> void:
	if _swap_canvus_button: _swap_canvus_button.queue_free()
	if _swap_spatial_button: _swap_spatial_button.queue_free()
	
	add_autoload_singleton("PalletAccessor", PALLET_ACCESSOR)
	add_inspector_plugin(plugin)
	
	_swap_canvus_button = Button.new()
	_swap_canvus_button.text = "Swap Pallet"
	_swap_canvus_button.focus_mode = Control.FOCUS_NONE
	_swap_canvus_button.flat = true
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, _swap_canvus_button)
	
	_swap_spatial_button = Button.new()
	_swap_spatial_button.text = "Swap Pallet"
	_swap_spatial_button.focus_mode = Control.FOCUS_NONE
	_swap_spatial_button.flat = true
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, _swap_spatial_button)
	
	_swap_canvus_button.pressed.connect(_swap_pallet)
	_swap_spatial_button.pressed.connect(_swap_pallet)
	scene_changed.connect(_on_scene_change)
	
	call_deferred("_setup_singleton")
func _exit_tree() -> void:
	remove_autoload_singleton("PalletAccessor")
	remove_inspector_plugin(plugin)
	PopupSettup.popup_remove()
	
	remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, _swap_canvus_button)
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, _swap_spatial_button)
	
	scene_changed.disconnect(_on_scene_change)

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
	palletAccessor.change_state(!palletAccessor.isDark())

func _setup_singleton() -> void:
	var pallet_accessor := get_node("/root/PalletAccessor")
	ColorStorage.pallet_accessor = pallet_accessor
	PopupManager.pallet_accessor = pallet_accessor
	ColorAccess.pallet_accessor = pallet_accessor
	
	PopupSettup.popup_add()
