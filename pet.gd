extends Node2D

# =========================
# 拖拽状态
# =========================

var is_dragging := false
var current_anim := ""

# =========================
# 设置状态
# =========================

var is_always_on_top := false
var current_opacity := 1.0

# =========================
# 菜单 ID
# =========================

const MENU_ALWAYS_ON_TOP := 1
const MENU_OPACITY_100 := 2
const MENU_OPACITY_80 := 3
const MENU_OPACITY_60 := 4
const MENU_RESET_POSITION := 5
const MENU_ABOUT := 6
const MENU_EXIT := 7

# =========================
# 节点引用
# =========================

@onready var pet_sprite: Sprite2D = $PetSprite
@onready var anim_player: AnimationPlayer = $PetSprite/AnimationPlayer
@onready var grab_point: Marker2D = $PetSprite/GrabPoint
@onready var pet_area: Area2D = $PetArea
@onready var popup_menu: PopupMenu = $PopupMenu

# =========================
# 关于项目弹窗
# =========================

var about_dialog: AcceptDialog
var about_label: Label

# =========================
# 初始化
# =========================

func _ready():

	# =========================
	# 窗口设置
	# =========================

	DisplayServer.window_set_flag(
		DisplayServer.WINDOW_FLAG_BORDERLESS,
		true
	)

	DisplayServer.window_set_flag(
		DisplayServer.WINDOW_FLAG_TRANSPARENT,
		true
	)

	get_viewport().transparent_bg = true

	DisplayServer.window_set_size(Vector2i(300, 300))

	# =========================
	# 默认动画
	# =========================

	play_anim("Default_Happy_1")

	# =========================
	# 鼠标输入
	# =========================

	pet_area.input_pickable = true

	if not pet_area.input_event.is_connected(_on_pet_area_input):
		pet_area.input_event.connect(_on_pet_area_input)

	# =========================
	# 右键菜单
	# =========================

	setup_menu()

	# =========================
	# 关于项目弹窗
	# =========================

	setup_about_dialog()

# =========================
# 每帧更新
# =========================

func _process(_delta):

	if is_dragging:

		# 鼠标松开但窗口没有收到释放事件时，自动结束拖拽
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			stop_drag()
			return

		var mouse_screen := Vector2(
			DisplayServer.mouse_get_position()
		)

		# GrabPoint 在窗口内部的真实坐标
		# 会自动考虑 PetSprite 的 position / scale / rotation
		var grab_in_window := pet_sprite.to_global(
			grab_point.position
		)

		# 让 GrabPoint 精准吸附到鼠标
		var target_window_pos := mouse_screen - grab_in_window

		DisplayServer.window_set_position(
			Vector2i(target_window_pos)
		)

		# =========================
		# 左右拖拽动画
		# =========================

		var window_pos := DisplayServer.window_get_position()
		var window_center_x := window_pos.x + 150

		if mouse_screen.x > window_center_x:
			play_anim("Raised_Dynamic_Happy_Right")
		else:
			play_anim("Raised_Dynamic_Happy_Left")

# =========================
# 全局输入
# =========================

func _input(event):

	# 防止鼠标松开时不在窗口内，导致拖拽状态卡住
	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:

			if is_dragging:
				stop_drag()

# =========================
# Area2D 输入
# =========================

func _on_pet_area_input(_viewport, event, _shape_idx):

	if event is InputEventMouseButton:

		# =========================
		# 左键拖拽
		# =========================

		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:

				is_dragging = true

		# =========================
		# 右键菜单
		# =========================

		if event.button_index == MOUSE_BUTTON_RIGHT:

			if event.pressed:

				stop_drag()

				var mouse_screen := DisplayServer.mouse_get_position()

				popup_menu.popup(
					Rect2i(mouse_screen, Vector2i(1, 1))
				)

# =========================
# 菜单系统
# =========================

func setup_menu():

	popup_menu.clear()

	popup_menu.add_check_item("置顶", MENU_ALWAYS_ON_TOP)

	popup_menu.add_separator()

	popup_menu.add_check_item("透明度：100%", MENU_OPACITY_100)
	popup_menu.add_check_item("透明度：80%", MENU_OPACITY_80)
	popup_menu.add_check_item("透明度：60%", MENU_OPACITY_60)

	popup_menu.add_separator()

	popup_menu.add_item("重置位置", MENU_RESET_POSITION)

	popup_menu.add_separator()

	popup_menu.add_item("关于项目", MENU_ABOUT)
	popup_menu.add_item("退出", MENU_EXIT)

	if not popup_menu.id_pressed.is_connected(_on_menu_selected):
		popup_menu.id_pressed.connect(_on_menu_selected)

	update_menu_checks()

func _on_menu_selected(id):

	match id:

		MENU_ALWAYS_ON_TOP:
			toggle_always_on_top()

		MENU_OPACITY_100:
			set_pet_opacity(1.0)

		MENU_OPACITY_80:
			set_pet_opacity(0.8)

		MENU_OPACITY_60:
			set_pet_opacity(0.6)

		MENU_RESET_POSITION:
			reset_window_position()

		MENU_ABOUT:
			show_about()

		MENU_EXIT:
			get_tree().quit()

func update_menu_checks():

	var always_on_top_index := popup_menu.get_item_index(MENU_ALWAYS_ON_TOP)
	var opacity_100_index := popup_menu.get_item_index(MENU_OPACITY_100)
	var opacity_80_index := popup_menu.get_item_index(MENU_OPACITY_80)
	var opacity_60_index := popup_menu.get_item_index(MENU_OPACITY_60)

	if always_on_top_index != -1:
		popup_menu.set_item_checked(always_on_top_index, is_always_on_top)

	if opacity_100_index != -1:
		popup_menu.set_item_checked(opacity_100_index, is_equal_approx(current_opacity, 1.0))

	if opacity_80_index != -1:
		popup_menu.set_item_checked(opacity_80_index, is_equal_approx(current_opacity, 0.8))

	if opacity_60_index != -1:
		popup_menu.set_item_checked(opacity_60_index, is_equal_approx(current_opacity, 0.6))

# =========================
# 菜单功能
# =========================

func toggle_always_on_top():

	is_always_on_top = not is_always_on_top

	DisplayServer.window_set_flag(
		DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP,
		is_always_on_top
	)

	update_menu_checks()

func set_pet_opacity(value: float):

	current_opacity = value

	# 控制桌宠本体透明度
	pet_sprite.modulate.a = value

	update_menu_checks()

func reset_window_position():

	DisplayServer.window_set_position(
		Vector2i(100, 100)
	)

# =========================
# 关于项目
# =========================

func setup_about_dialog():

	about_dialog = AcceptDialog.new()
	about_dialog.title = "关于项目"
	about_dialog.min_size = Vector2i(360, 220)
	add_child(about_dialog)

	about_label = Label.new()
	about_label.text = "FuschiaDesktop V0.1\nPrototype by Fuschia Digital\nSpecial Thanks to total_kk\n2026.5.24"
	about_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	about_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	about_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	about_label.custom_minimum_size = Vector2(320, 120)

	about_dialog.add_child(about_label)

func show_about():

	about_dialog.popup_centered(
		Vector2i(360, 220)
	)

# =========================
# 拖拽结束
# =========================

func stop_drag():

	is_dragging = false

	play_anim("Default_Happy_1")

# =========================
# 动画播放
# =========================

func play_anim(anim_name: String):

	if current_anim == anim_name:
		return

	current_anim = anim_name

	anim_player.play(anim_name)
