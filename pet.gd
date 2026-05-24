extends Node2D

# =========================
# 拖拽状态
# =========================

var is_dragging := false
var current_anim := ""

# =========================
# 启动 / 关闭状态
# =========================

var can_interact := false
var is_shutting_down := false

# =========================
# 设置状态
# =========================

var is_always_on_top := false
var current_opacity := 1.0

# 60% 是默认尺寸，对应 300x300
var current_body_scale := 0.6

var current_language := "zh_CN"

# =========================
# 主菜单 ID
# =========================

const MENU_HELP := 1
const MENU_EXIT := 2

# =========================
# 小程序菜单 ID
# =========================

const APP_STATUS_TIMER := 101
const APP_POMODORO := 102
const APP_GAME_MODE := 103

# =========================
# 设置菜单 ID
# =========================

const SETTING_PERSONAL := 201
const SETTING_AUTO_START := 202
const SETTING_ALWAYS_ON_TOP := 203

const SETTING_SIZE_CYCLE := 211
const SETTING_OPACITY_CYCLE := 221

const SETTING_RESET_POSITION := 231
const SETTING_CLEAR_CACHE := 232
const SETTING_ABOUT := 233

# =========================
# 语言菜单 ID
# =========================

const LANGUAGE_ZH_CN := 301
const LANGUAGE_ZH_TW := 302
const LANGUAGE_EN := 303

# =========================
# 档位配置
# =========================

const SIZE_VALUES := [1.0, 0.8, 0.6, 0.4, 0.2]
const OPACITY_VALUES := [1.0, 0.8, 0.6, 0.4, 0.2]

# =========================
# 节点引用
# =========================

@onready var pet_body: Node2D = $PetBody
@onready var pet_sprite: Sprite2D = $PetBody/PetSprite
@onready var anim_player: AnimationPlayer = $PetBody/PetSprite/AnimationPlayer
@onready var grab_point: Marker2D = $PetBody/PetSprite/GrabPoint
@onready var pet_area: Area2D = $PetBody/PetArea

@onready var popup_menu: PopupMenu = $PopupMenu
@onready var app_menu: PopupMenu = $PopupMenu/AppMenu
@onready var setting_menu: PopupMenu = $PopupMenu/SettingMenu
@onready var language_menu: PopupMenu = $PopupMenu/LanguageMenu

# =========================
# 关于应用弹窗
# =========================

var about_dialog: AcceptDialog
var about_label: Label

# =========================
# 通用提示弹窗
# =========================

var message_dialog: AcceptDialog
var message_label: Label

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

	# 60% 档对应 300x300
	DisplayServer.window_set_size(Vector2i(300, 300))

	# =========================
	# 默认显示设置
	# =========================

	set_pet_size(0.6)
	set_pet_opacity(1.0)

	# =========================
	# 鼠标输入
	# =========================

	pet_area.input_pickable = true

	if not pet_area.input_event.is_connected(_on_pet_area_input):
		pet_area.input_event.connect(_on_pet_area_input)

	# =========================
	# 菜单
	# =========================

	setup_menu()

	# =========================
	# 弹窗
	# =========================

	setup_about_dialog()
	setup_message_dialog()

	# =========================
	# 动画完成信号
	# =========================

	if not anim_player.animation_finished.is_connected(_on_animation_finished):
		anim_player.animation_finished.connect(_on_animation_finished)

	# =========================
	# 启动动画
	# =========================

	can_interact = false
	is_shutting_down = false

	play_anim("StartUP_Happy")

# =========================
# 每帧更新
# =========================

func _process(_delta):

	if not can_interact:
		return

	if is_dragging:

		# 鼠标松开但窗口没有收到释放事件时，自动结束拖拽
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			stop_drag()
			return

		var mouse_screen := Vector2(
			DisplayServer.mouse_get_position()
		)

		# GrabPoint 在窗口内部的真实坐标
		# 会自动考虑 PetBody / PetSprite 的 position / scale / rotation
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
		var window_size := DisplayServer.window_get_size()
		var window_center_x := window_pos.x + window_size.x * 0.5

		if mouse_screen.x > window_center_x:
			play_anim("Raised_Dynamic_Happy_Right")
		else:
			play_anim("Raised_Dynamic_Happy_Left")

# =========================
# 全局输入
# =========================

func _input(event):

	if not can_interact:
		return

	# 防止鼠标松开时不在窗口内，导致拖拽状态卡住
	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:

			if is_dragging:
				stop_drag()

# =========================
# Area2D 输入
# =========================

func _on_pet_area_input(_viewport, event, _shape_idx):

	if not can_interact:
		return

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

	# =========================
	# 主菜单
	# =========================

	popup_menu.clear()

	popup_menu.add_submenu_item("小程序", "AppMenu")
	popup_menu.add_submenu_item("设置", "SettingMenu")
	popup_menu.add_submenu_item("语言", "LanguageMenu")

	popup_menu.add_separator()

	popup_menu.add_item("帮助", MENU_HELP)
	popup_menu.add_item("退出程序", MENU_EXIT)

	if not popup_menu.id_pressed.is_connected(_on_menu_selected):
		popup_menu.id_pressed.connect(_on_menu_selected)

	# =========================
	# 小程序菜单
	# =========================

	app_menu.clear()

	app_menu.add_item("状态计时器", APP_STATUS_TIMER)
	app_menu.add_item("番茄钟", APP_POMODORO)
	app_menu.add_item("游戏模式", APP_GAME_MODE)

	if not app_menu.id_pressed.is_connected(_on_menu_selected):
		app_menu.id_pressed.connect(_on_menu_selected)

	# =========================
	# 设置菜单
	# =========================

	setting_menu.clear()

	setting_menu.add_item("个性化设置", SETTING_PERSONAL)

	setting_menu.add_separator()

	setting_menu.add_check_item("开机自启", SETTING_AUTO_START)
	setting_menu.add_check_item("置顶", SETTING_ALWAYS_ON_TOP)

	setting_menu.add_separator()

	setting_menu.add_item(get_size_menu_text(), SETTING_SIZE_CYCLE)

	setting_menu.add_separator()

	setting_menu.add_item(get_opacity_menu_text(), SETTING_OPACITY_CYCLE)

	setting_menu.add_separator()

	setting_menu.add_item("重置位置", SETTING_RESET_POSITION)
	setting_menu.add_item("删除缓存", SETTING_CLEAR_CACHE)
	setting_menu.add_item("关于应用", SETTING_ABOUT)

	if not setting_menu.id_pressed.is_connected(_on_menu_selected):
		setting_menu.id_pressed.connect(_on_menu_selected)

	# =========================
	# 语言菜单
	# =========================

	language_menu.clear()

	language_menu.add_check_item("简中", LANGUAGE_ZH_CN)
	language_menu.add_check_item("繁中", LANGUAGE_ZH_TW)
	language_menu.add_check_item("EN", LANGUAGE_EN)

	if not language_menu.id_pressed.is_connected(_on_menu_selected):
		language_menu.id_pressed.connect(_on_menu_selected)

	update_menu_checks()

func _on_menu_selected(id):

	match id:

		# =========================
		# 主菜单
		# =========================

		MENU_HELP:
			open_help_page()

		MENU_EXIT:
			request_exit()

		# =========================
		# 小程序
		# =========================

		APP_STATUS_TIMER:
			show_feature_placeholder("状态计时器将在后续版本开放。")

		APP_POMODORO:
			show_feature_placeholder("番茄钟将在后续版本开放。")

		APP_GAME_MODE:
			show_feature_placeholder("游戏模式将在后续版本开放。")

		# =========================
		# 设置
		# =========================

		SETTING_PERSONAL:
			show_feature_placeholder("个性化设置将在后续版本开放。")

		SETTING_AUTO_START:
			show_feature_placeholder("开机自启将在后续版本开放。")

		SETTING_ALWAYS_ON_TOP:
			toggle_always_on_top()

		SETTING_SIZE_CYCLE:
			cycle_pet_size()

		SETTING_OPACITY_CYCLE:
			cycle_pet_opacity()

		SETTING_RESET_POSITION:
			reset_window_position()

		SETTING_CLEAR_CACHE:
			clear_cache()

		SETTING_ABOUT:
			show_about()

		# =========================
		# 语言
		# =========================

		LANGUAGE_ZH_CN:
			set_language("zh_CN")

		LANGUAGE_ZH_TW:
			set_language("zh_TW")

		LANGUAGE_EN:
			set_language("en")

func update_menu_checks():

	# =========================
	# 设置：置顶
	# =========================

	_set_menu_check(setting_menu, SETTING_ALWAYS_ON_TOP, is_always_on_top)

	# =========================
	# 设置：窗口大小
	# =========================

	_set_menu_text(setting_menu, SETTING_SIZE_CYCLE, get_size_menu_text())

	# =========================
	# 设置：透明度
	# =========================

	_set_menu_text(setting_menu, SETTING_OPACITY_CYCLE, get_opacity_menu_text())

	# =========================
	# 语言
	# =========================

	_set_menu_check(language_menu, LANGUAGE_ZH_CN, current_language == "zh_CN")
	_set_menu_check(language_menu, LANGUAGE_ZH_TW, current_language == "zh_TW")
	_set_menu_check(language_menu, LANGUAGE_EN, current_language == "en")

func _set_menu_check(menu: PopupMenu, id: int, checked: bool):

	var index := menu.get_item_index(id)

	if index != -1:
		menu.set_item_checked(index, checked)

func _set_menu_text(menu: PopupMenu, id: int, text: String):

	var index := menu.get_item_index(id)

	if index != -1:
		menu.set_item_text(index, text)

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

	pet_body.modulate.a = value

	update_menu_checks()

func set_pet_size(value: float):

	current_body_scale = value

	# 以 60% 作为原始视觉大小
	# 60% -> PetBody.scale = 1.0
	# 100% -> PetBody.scale ≈ 1.666
	# 20% -> PetBody.scale ≈ 0.333
	var visual_scale := value / 0.6

	pet_body.scale = Vector2(visual_scale, visual_scale)

	# 以 300x300 作为 60% 档
	# 所以 100% = 500x500
	var base_size_at_60 := Vector2i(300, 300)

	var new_window_size := Vector2i(
		int(base_size_at_60.x * value / 0.6),
		int(base_size_at_60.y * value / 0.6)
	)

	# 防止窗口过小
	new_window_size.x = max(new_window_size.x, 100)
	new_window_size.y = max(new_window_size.y, 100)

	DisplayServer.window_set_size(new_window_size)

	update_menu_checks()

func cycle_pet_size():

	var current_index := SIZE_VALUES.find(current_body_scale)

	if current_index == -1:
		current_index = 2

	var next_index := (current_index + 1) % SIZE_VALUES.size()

	set_pet_size(SIZE_VALUES[next_index])

func cycle_pet_opacity():

	var current_index := OPACITY_VALUES.find(current_opacity)

	if current_index == -1:
		current_index = 0

	var next_index := (current_index + 1) % OPACITY_VALUES.size()

	set_pet_opacity(OPACITY_VALUES[next_index])

func get_size_menu_text() -> String:

	return "窗口大小：" + get_option_row_text(SIZE_VALUES, current_body_scale)

func get_opacity_menu_text() -> String:

	return "透明度：" + get_option_row_text(OPACITY_VALUES, current_opacity)

func get_option_row_text(values: Array, current_value: float) -> String:

	var result := ""

	for i in range(values.size()):

		var value: float = values[i]
		var percent := str(int(value * 100)) + "%"

		if is_equal_approx(value, current_value):
			percent += " ●"
		else:
			percent += " ○"

		if i == 0:
			result = percent
		else:
			result += "  " + percent

	return result

func reset_window_position():

	var screen_id := DisplayServer.window_get_current_screen()
	var screen_rect := DisplayServer.screen_get_usable_rect(screen_id)
	var window_size := DisplayServer.window_get_size()

	var target_pos := screen_rect.position + Vector2i(
		int((screen_rect.size.x - window_size.x) * 0.5),
		int((screen_rect.size.y - window_size.y) * 0.5)
	)

	DisplayServer.window_set_position(target_pos)

func request_exit():

	if is_shutting_down:
		return

	is_shutting_down = true
	can_interact = false
	is_dragging = false

	popup_menu.hide()
	app_menu.hide()
	setting_menu.hide()
	language_menu.hide()

	play_anim("Shutdown_Happy_1")

func open_help_page():

	OS.shell_open("https://fuschiadigital.cn")

func show_feature_placeholder(message: String):

	show_message(
		"功能预告",
		message
	)

func set_language(language_code: String):

	current_language = language_code

	update_menu_checks()

	match language_code:

		"zh_CN":
			show_message("语言", "当前语音语言已设置为：简中。")

		"zh_TW":
			show_message("語言", "當前語音語言已設定為：繁中。")

		"en":
			show_message("Language", "Voice language has been set to English.")

func clear_cache():

	var cache_path := "user://cache"

	if DirAccess.dir_exists_absolute(cache_path):
		_delete_directory_recursive(cache_path)
		DirAccess.remove_absolute(cache_path)

	show_message(
		"删除缓存",
		"缓存清理完成。"
	)

func _delete_directory_recursive(path: String):

	var dir := DirAccess.open(path)

	if dir == null:
		return

	dir.list_dir_begin()

	var file_name := dir.get_next()

	while file_name != "":

		if file_name != "." and file_name != "..":

			var full_path := path.path_join(file_name)

			if dir.current_is_dir():

				_delete_directory_recursive(full_path)
				DirAccess.remove_absolute(full_path)

			else:

				DirAccess.remove_absolute(full_path)

		file_name = dir.get_next()

	dir.list_dir_end()

# =========================
# 通用提示弹窗
# =========================

func setup_message_dialog():

	message_dialog = AcceptDialog.new()
	message_dialog.title = "提示"
	message_dialog.min_size = Vector2i(320, 180)
	add_child(message_dialog)

	message_label = Label.new()
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message_label.custom_minimum_size = Vector2(280, 90)

	message_dialog.add_child(message_label)

func show_message(title: String, message: String):

	message_dialog.title = title
	message_label.text = message

	message_dialog.popup_centered(
		Vector2i(320, 180)
	)

# =========================
# 关于应用
# =========================

func setup_about_dialog():

	about_dialog = AcceptDialog.new()
	about_dialog.title = "关于应用"
	about_dialog.min_size = Vector2i(360, 220)
	add_child(about_dialog)

	about_label = Label.new()
	about_label.text = "FuschiaDesktop V0.1\n2026.5.24\nPrototype by Fuschia Digital\nSpecial Thanks to total_kk"
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
# 动画完成回调
# =========================

func _on_animation_finished(anim_name: StringName):

	if anim_name == "StartUP_Happy":

		can_interact = true
		play_anim("Default_Happy_1")

	elif anim_name == "Shutdown_Happy_1":

		get_tree().quit()

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

	if not anim_player.has_animation(anim_name):

		push_warning("Animation not found: " + anim_name)

		if anim_name == "StartUP_Happy":

			can_interact = true
			play_anim("Default_Happy_1")

		elif anim_name == "Shutdown_Happy_1":

			get_tree().quit()

		return

	current_anim = anim_name

	anim_player.play(anim_name)
