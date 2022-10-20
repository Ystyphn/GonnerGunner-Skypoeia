extends Node


export (Vector2) var mouse_size = Vector2(18, 18)
export (Vector2) var pointer_hotspot = Vector2(9,9)

export (Dictionary) var cursor_textures

var cursor_image_textures: Dictionary
var cursor_images: Dictionary

var interactable

func _ready():
	# This block will get datas from the textures
	get_cursor_data()
	
	# This will resize the image data at will
	resize_cursor_image()
	
	# This will create image texture from the image data
	create_texture_from_images()
	
	set_cursor_texture("NormalCursor")

func get_cursor_data():
	# This method will get datas from the cursor textures
	for key in cursor_textures:
		cursor_images[key] = cursor_textures[key].get_data()
		if key == "HandCursor":
			for a in cursor_images[key].data["data"]:
				#print(a)
				pass

func resize_cursor_image():
	# This method will resize all the images in the cursor image data
	for key in cursor_images:
		cursor_images[key].resize(mouse_size.x, mouse_size.y)
		print(cursor_images[key].get_format())

func create_texture_from_images():
	# This method will create textures from the cursor_image_data
	for key in cursor_images:
		var cursor_texture: ImageTexture = ImageTexture.new()
		cursor_image_textures[key] = cursor_texture
		cursor_image_textures[key].create_from_image(cursor_images[key])

func set_cursor_texture(id: String):
	if !cursor_image_textures.has(id):
		print("No id named ", id)
		return
	Input.set_custom_mouse_cursor(cursor_image_textures[id], Input.CURSOR_ARROW,
			pointer_hotspot)
