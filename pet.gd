extends Node2D

# =========================
# 拖拽状态
# =========================

var is_dragging = false
var drag_offset = Vector2.ZERO
var current_anim = ""

# =========================
# 初始化
# =========================

func _ready():

	# ===== 窗口设置 =====

	# 无边框
	DisplayServer.window_set_flag(
		DisplayServer.WINDOW_FLAG_BORDERLESS,
		true
	)

	# 固定窗口大小
	DisplayServer.window_set_size(Vector2i(300, 300))

	# ===== 默认动画 =====

	play_anim("Default_Happy_1")

	# ===== 鼠标输入 =====

	$PetArea.input_pickable = true
	$PetArea.connect("input_event", _on_input)

	# ===== 右键菜单 =====

	$PopupMenu.add_item("退出", 0)
	$PopupMenu.id_pressed.connect(_on_menu_selected)

# =========================
# 每帧更新
# =========================

func _process(_delta):

	if is_dragging:

		# 桌面鼠标坐标
		var mouse_pos = Vector2(
			DisplayServer.mouse_get_position()
		)

		# 移动窗口
		DisplayServer.window_set_position(
			Vector2i(mouse_pos - drag_offset)
		)

		# ===== 左右拖动动画 =====

		var win_pos = DisplayServer.window_get_position()

		var center_x = win_pos.x + 150

		if mouse_pos.x > center_x:

			play_anim("Raised_Dynamic_Happy_Right")

		else:

			play_anim("Raised_Dynamic_Happy_Left")

# =========================
# 鼠标输入
# =========================

func _on_input(_viewport, event, _shape_idx):

	if event is InputEventMouseButton:

		# =========================
		# 左键拖动
		# =========================

		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:

				is_dragging = true

				# 桌面鼠标坐标
				var mouse_pos = Vector2(
					DisplayServer.mouse_get_position()
				)

				# 窗口左上角
				var win_pos = Vector2(
					DisplayServer.window_get_position()
				)

				# PetSprite 在窗口中的位置
				var sprite_pos = $PetSprite.position

				# GrabPoint 在 Sprite 中的位置
				var grab_local = $PetSprite/GrabPoint.position

				# GrabPoint 在窗口中的真实位置
				var grab_in_window = sprite_pos + grab_local

				# GrabPoint 在桌面中的真实位置
				var grab_screen = win_pos + grab_in_window

				# 鼠标偏移
				drag_offset = mouse_pos - grab_screen

			else:

				is_dragging = false

				play_anim("Default_Happy_1")

		# =========================
		# 右键菜单
		# =========================

		if event.button_index == MOUSE_BUTTON_RIGHT:

			if event.pressed:

				$PopupMenu.position = get_viewport().get_mouse_position()

				$PopupMenu.popup()

# =========================
# 菜单事件
# =========================

func _on_menu_selected(id):

	match id:

		0:
			get_tree().quit()

# =========================
# 动画播放
# =========================

func play_anim(anim_name):

	if current_anim == anim_name:
		return

	current_anim = anim_name

	$PetSprite/AnimationPlayer.play(anim_name)
