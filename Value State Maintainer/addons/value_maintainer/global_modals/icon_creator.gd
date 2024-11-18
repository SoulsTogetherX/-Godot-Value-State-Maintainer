@tool
extends Object

const CONSTANTS := preload("res://addons/value_maintainer/global_modals/global_values.gd")
const ICON_FOLDER := "res://addons/value_maintainer/icons/"
const OUTLINE_LENGTH : int = 3

static var circle_data : Image
static var dual_data : Image

static func _static_init() -> void:
	if Engine.is_editor_hint():
		circle_data = get_icon("Circle").get_image()
		dual_data = get_icon("DualCircle").get_image()

static func get_circle_icon(color : Color) -> Texture2D:
	if color.a == 0:
		return get_icon("CircleEmpty")
	
	var color_inverted : Color = clamp_luminance(color.inverted())
	var image : Image = circle_data.duplicate()
	var base_image : Image = image.duplicate()
	var imageTexture := ImageTexture.new()
	
	var image_size := image.get_size()
	for row in image_size.y:
		for col in image_size.x:
			var pixel_alpha : float = base_image.get_pixel(col, row).a
			if is_zero_approx(pixel_alpha):
				pixel_alpha = 0
				for i in range(0, OUTLINE_LENGTH):
					if col + i < image_size.x:
						pixel_alpha += base_image.get_pixel(col + i, row).a
					if col - i > 0:
						pixel_alpha += base_image.get_pixel(col - i, row).a
					if row + i < image_size.y:
						pixel_alpha += base_image.get_pixel(col, row + i).a
					if row - i > 0:
						pixel_alpha += base_image.get_pixel(col, row - i).a
				image.set_pixel(col, row, Color(color_inverted, (pixel_alpha * 2) / OUTLINE_LENGTH))
			else:
				image.set_pixel(col, row, Color(color, pixel_alpha))
	
	imageTexture.set_image(image)
	return imageTexture
static func get_dualcircle_icon(colors : PackedColorArray) -> Texture2D:
	if colors[0].a == 0 && colors[1].a == 0:
		return get_icon("DualCircleEmpty")
	
	var colors_inverted : PackedColorArray = [clamp_luminance(colors[0].inverted()), clamp_luminance(colors[1].inverted())]
	var image : Image = dual_data.duplicate()
	var base_image : Image = image.duplicate()
	var imageTexture := ImageTexture.new()
	
	var image_size := image.get_size()
	for row in image_size.y:
		for col in image_size.x:
			var pixel_alpha : float = base_image.get_pixel(col, row).a
			if is_zero_approx(pixel_alpha):
				pixel_alpha = 0
				for i in range(0, OUTLINE_LENGTH):
					if col + i < image_size.x:
						pixel_alpha += base_image.get_pixel(col + i, row).a
					if col - i > 0:
						pixel_alpha += base_image.get_pixel(col - i, row).a
					if row + i < image_size.y:
						pixel_alpha += base_image.get_pixel(col, row + i).a
					if row - i > 0:
						pixel_alpha += base_image.get_pixel(col, row - i).a
				image.set_pixel(col, row, Color(colors_inverted[0 if row < col else 1], (pixel_alpha * 2) / OUTLINE_LENGTH))
			else:
				image.set_pixel(col, row, Color(colors[0 if row >= col else 1], pixel_alpha))
	
	imageTexture.set_image(image)
	return imageTexture

static func get_icon(icon_name : String) -> Texture2D:
	return load(ICON_FOLDER + icon_name + ".svg")
static func add_icon_to_item(item : TreeItem) -> void:
	var data : Variant = item.get_metadata(0)
	
	match typeof(data):
		TYPE_DICTIONARY:
			item.set_icon(0, get_icon("Folder"))
			item.set_icon_modulate(0, Color.DEEP_SKY_BLUE)
		TYPE_COLOR:
			item.set_icon(0, get_circle_icon(data))
		TYPE_PACKED_COLOR_ARRAY:
			item.set_icon(0, get_dualcircle_icon(data))
static func clamp_luminance(color : Color) -> Color:
	if color.get_luminance() < 0.5:
		return Color.BLACK
	return Color.WHITE
