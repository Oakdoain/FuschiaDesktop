extends Node2D

var is_dragging := false
var current_anim := ""

@onready var pet_sprite: Sprite2D = $PetSprite
@onready var anim_player: AnimationPlayer = $PetSprite/AnimationPlayer
@onready var grab_point: Marker2D = $PetSprite/GrabPoint
@onready var pet_area: Area2D = $PetArea
@onready var popup_menu: PopupMenu = $PopupMenu

func _ready():
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_size(Vector2i(300, 300))

	play_anim("Default_Happy_1")

	pet_area.input_pickable = true
	pet_area.input_event.connect(_on_pet_area_input)

	popup_menu.clear()
	popup_menu.add_item("退出", 0)
	popup_menu.id_pressed.connect(_on_menu_selected)

func _process(_delta):
	if is_dragging:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			stop_drag()
			return

		var mouse_screen := Vector2(DisplayServer.mouse_get_position())

		# GrabPoint 在窗口内部的真实坐标，自动包含 PetSprite 的 position / scale
		var grab_in_window := pet_sprite.to_global(grab_point.position)

		# 让 GrabPoint 精准吸附到鼠标
		var target_window_pos := mouse_screen - grab_in_window
		DisplayServer.window_set_position(Vector2i(target_window_pos))

		var window_pos := DisplayServer.window_get_position()
		var center_x := window_pos.x + 150

		if mouse_screen.x > center_x:
			play_anim("Raised_Dynamic_Happy_Right")
		else:
			play_anim("Raised_Dynamic_Happy_Left")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and is_dragging:
			stop_drag()

func _on_pet_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			is_dragging = true

		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			is_dragging = false
			play_anim("Default_Happy_1")

			var mouse_screen := DisplayServer.mouse_get_position()
			popup_menu.popup(Rect2i(mouse_screen, Vector2i(1, 1)))

func stop_drag():
	is_dragging = false
	play_anim("Default_Happy_1")

func _on_menu_selected(id):
	match id:
		0:
			get_tree().quit()

func play_anim(anim_name: String):
	if current_anim == anim_name:
		return

	current_anim = anim_name
	anim_player.play(anim_name)
