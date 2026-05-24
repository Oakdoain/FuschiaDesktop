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
# 本地设置保存
# =========================

const SETTINGS_PATH := "user://settings.json"

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
# 多语言文本
# =========================

const TEXTS := {
	"zh_CN": {
		"menu_apps": "小程序",
		"menu_settings": "设置",
		"menu_language": "语言",
		"menu_help": "帮助",
		"menu_exit": "退出程序",

		"app_status_timer": "状态计时器",
		"app_pomodoro": "番茄钟",
		"app_game_mode": "游戏模式",

		"setting_personal": "个性化设置",
		"setting_auto_start": "开机自启",
		"setting_always_on_top": "置顶",
		"setting_size": "窗口大小：",
		"setting_opacity": "透明度：",
		"setting_reset_position": "重置位置",
		"setting_clear_cache": "删除缓存",
		"setting_about": "关于应用",

		"language_zh_cn": "简中",
		"language_zh_tw": "繁中",
		"language_en": "EN",

		"title_feature": "功能预告",
		"title_cache": "删除缓存",
		"title_language": "语言",
		"title_about": "关于应用",
		"title_notice": "提示",

		"status_timer_soon": "状态计时器将在后续版本开放。",
		"pomodoro_soon": "番茄钟将在后续版本开放。",
		"game_mode_soon": "游戏模式将在后续版本开放。",
		"personal_soon": "个性化设置将在后续版本开放。",
		"auto_start_soon": "开机自启将在后续版本开放。",
		"cache_done": "缓存清理完成。",
		"language_changed": "当前语音语言已设置为：简中。"
	},

	"zh_TW": {
		"menu_apps": "小程式",
		"menu_settings": "設定",
		"menu_language": "語言",
		"menu_help": "幫助",
		"menu_exit": "退出程式",

		"app_status_timer": "狀態計時器",
		"app_pomodoro": "番茄鐘",
		"app_game_mode": "遊戲模式",

		"setting_personal": "個人化設定",
		"setting_auto_start": "開機自啟",
		"setting_always_on_top": "置頂",
		"setting_size": "視窗大小：",
		"setting_opacity": "透明度：",
		"setting_reset_position": "重設位置",
		"setting_clear_cache": "刪除快取",
		"setting_about": "關於應用",

		"language_zh_cn": "簡中",
		"language_zh_tw": "繁中",
		"language_en": "EN",

		"title_feature": "功能預告",
		"title_cache": "刪除快取",
		"title_language": "語言",
		"title_about": "關於應用",
		"title_notice": "提示",

		"status_timer_soon": "狀態計時器將在後續版本開放。",
		"pomodoro_soon": "番茄鐘將在後續版本開放。",
		"game_mode_soon": "遊戲模式將在後續版本開放。",
		"personal_soon": "個人化設定將在後續版本開放。",
		"auto_start_soon": "開機自啟將在後續版本開放。",
		"cache_done": "快取清理完成。",
		"language_changed": "當前語音語言已設定為：繁中。"
	},

	"en": {
		"menu_apps": "Apps",
		"menu_settings": "Settings",
		"menu_language": "Language",
		"menu_help": "Help",
		"menu_exit": "Exit",

		"app_status_timer": "Status Timer",
		"app_pomodoro": "Pomodoro",
		"app_game_mode": "Game Mode",

		"setting_personal": "Personalization",
		"setting_auto_start": "Launch on Startup",
		"setting_always_on_top": "Always on Top",
		"setting_size": "Window Size: ",
		"setting_opacity": "Opacity: ",
		"setting_reset_position": "Reset Position",
		"setting_clear_cache": "Clear Cache",
		"setting_about": "About",

		"language_zh_cn": "Simplified Chinese",
		"language_zh_tw": "Traditional Chinese",
		"language_en": "English",

		"title_feature": "Coming Soon",
		"title_cache": "Clear Cache",
		"title_language": "Language",
		"title_about": "About",
		"title_notice": "Notice",

		"status_timer_soon": "Status Timer will be available in a future version.",
		"pomodoro_soon": "Pomodoro will be available in a future version.",
		"game_mode_soon": "Game Mode will be available in a future version.",
		"personal_soon": "Personalization settings will be available in a future version.",
		"auto_start_soon": "Launch on Startup will be available in a future version.",
		"cache_done": "Cache cleared.",
		"language_changed": "Voice language has been set to English."
	}
}

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

	apply_default_settings()

	# =========================
	# 鼠标输入
	# =========================

	pet_area.input_pickable = true

	if not pet_area.input_event.is_connected(_on_pet_area_input):
		pet_area.input_event.connect(_on_pet_area_input)

	# =========================
	# 弹窗
	# =========================

	setup_about_dialog()
	setup_message_dialog()

	# =========================
	# 菜单
	# =========================

	setup_menu()

	# =========================
	# 读取本地设置
	# =========================

	load_settings()

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
# 多语言
# =========================

func t(key: String) -> String:

	var lang_data: Dictionary = TEXTS.get(current_language, TEXTS["zh_CN"])

	if lang_data.has(key):
		return lang_data[key]

	var fallback: Dictionary = TEXTS["zh_CN"]

	if fallback.has(key):
		return fallback[key]

	return key

# =========================
# 菜单系统
# =========================

func setup_menu():

	# =========================
	# 主菜单
	# =========================

	popup_menu.clear()

	popup_menu.add_submenu_item(t("menu_apps"), "AppMenu")
	popup_menu.add_submenu_item(t("menu_settings"), "SettingMenu")
	popup_menu.add_submenu_item(t("menu_language"), "LanguageMenu")

	popup_menu.add_separator()

	popup_menu.add_item(t("menu_help"), MENU_HELP)
	popup_menu.add_item(t("menu_exit"), MENU_EXIT)

	if not popup_menu.id_pressed.is_connected(_on_menu_selected):
		popup_menu.id_pressed.connect(_on_menu_selected)

	# =========================
	# 小程序菜单
	# =========================

	app_menu.clear()

	app_menu.add_item(t("app_status_timer"), APP_STATUS_TIMER)
	app_menu.add_item(t("app_pomodoro"), APP_POMODORO)
	app_menu.add_item(t("app_game_mode"), APP_GAME_MODE)

	if not app_menu.id_pressed.is_connected(_on_menu_selected):
		app_menu.id_pressed.connect(_on_menu_selected)

	# =========================
	# 设置菜单
	# =========================

	setting_menu.clear()

	setting_menu.add_item(t("setting_personal"), SETTING_PERSONAL)

	setting_menu.add_separator()

	setting_menu.add_check_item(t("setting_auto_start"), SETTING_AUTO_START)
	setting_menu.add_check_item(t("setting_always_on_top"), SETTING_ALWAYS_ON_TOP)

	setting_menu.add_separator()

	setting_menu.add_item(get_size_menu_text(), SETTING_SIZE_CYCLE)

	setting_menu.add_separator()

	setting_menu.add_item(get_opacity_menu_text(), SETTING_OPACITY_CYCLE)

	setting_menu.add_separator()

	setting_menu.add_item(t("setting_reset_position"), SETTING_RESET_POSITION)
	setting_menu.add_item(t("setting_clear_cache"), SETTING_CLEAR_CACHE)
	setting_menu.add_item(t("setting_about"), SETTING_ABOUT)

	if not setting_menu.id_pressed.is_connected(_on_menu_selected):
		setting_menu.id_pressed.connect(_on_menu_selected)

	# =========================
	# 语言菜单
	# =========================

	language_menu.clear()

	language_menu.add_check_item(t("language_zh_cn"), LANGUAGE_ZH_CN)
	language_menu.add_check_item(t("language_zh_tw"), LANGUAGE_ZH_TW)
	language_menu.add_check_item(t("language_en"), LANGUAGE_EN)

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
			show_feature_placeholder("status_timer_soon")

		APP_POMODORO:
			show_feature_placeholder("pomodoro_soon")

		APP_GAME_MODE:
			show_feature_placeholder("game_mode_soon")

		# =========================
		# 设置
		# =========================

		SETTING_PERSONAL:
			show_feature_placeholder("personal_soon")

		SETTING_AUTO_START:
			show_feature_placeholder("auto_start_soon")

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
# 本地设置保存 / 读取
# =========================

func apply_default_settings():

	is_always_on_top = false
	current_opacity = 1.0
	current_body_scale = 0.6
	current_language = "zh_CN"

	DisplayServer.window_set_flag(
		DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP,
		is_always_on_top
	)

	set_pet_size(current_body_scale, false)
	set_pet_opacity(current_opacity, false)

func save_settings():

	var window_pos := DisplayServer.window_get_position()

	var settings := {
		"window_position": {
			"x": window_pos.x,
			"y": window_pos.y
		},
		"body_scale": current_body_scale,
		"opacity": current_opacity,
		"always_on_top": is_always_on_top,
		"language": current_language
	}

	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)

	if file == null:
		push_warning("Failed to save settings: " + SETTINGS_PATH)
		return

	var json_text := JSON.stringify(settings, "\t")

	file.store_string(json_text)
	file.close()

func load_settings():

	if not FileAccess.file_exists(SETTINGS_PATH):
		return

	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)

	if file == null:
		push_warning("Failed to load settings: " + SETTINGS_PATH)
		return

	var json_text := file.get_as_text()
	file.close()

	var json := JSON.new()
	var error := json.parse(json_text)

	if error != OK:
		push_warning("Failed to parse settings.json")
		return

	var settings = json.data

	if typeof(settings) != TYPE_DICTIONARY:
		push_warning("settings.json is not a Dictionary")
		return

	if settings.has("always_on_top"):
		is_always_on_top = bool(settings["always_on_top"])

		DisplayServer.window_set_flag(
			DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP,
			is_always_on_top
		)

	if settings.has("opacity"):
		set_pet_opacity(float(settings["opacity"]), false)

	if settings.has("body_scale"):
		set_pet_size(float(settings["body_scale"]), false)

	if settings.has("language"):
		current_language = str(settings["language"])
		setup_menu()

	if settings.has("window_position"):
		var pos_data = settings["window_position"]

		if typeof(pos_data) == TYPE_DICTIONARY and pos_data.has("x") and pos_data.has("y"):

			DisplayServer.window_set_position(
				Vector2i(
					int(pos_data["x"]),
					int(pos_data["y"])
				)
			)

	update_menu_checks()

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
	save_settings()

func set_pet_opacity(value: float, should_save := true):

	current_opacity = value

	pet_body.modulate.a = value

	update_menu_checks()

	if should_save:
		save_settings()

func set_pet_size(value: float, should_save := true):

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

	if should_save:
		save_settings()

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

	return t("setting_size") + get_option_row_text(SIZE_VALUES, current_body_scale)

func get_opacity_menu_text() -> String:

	return t("setting_opacity") + get_option_row_text(OPACITY_VALUES, current_opacity)

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

	save_settings()

func request_exit():

	if is_shutting_down:
		return

	save_settings()

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

func show_feature_placeholder(message_key: String):

	show_message(
		t("title_feature"),
		t(message_key)
	)

func set_language(language_code: String, should_save := true, show_notice := true):

	current_language = language_code

	setup_menu()
	update_menu_checks()

	if should_save:
		save_settings()

	if show_notice:
		show_message(
			t("title_language"),
			t("language_changed")
		)

func clear_cache():

	var cache_path := "user://cache"

	if DirAccess.dir_exists_absolute(cache_path):
		_delete_directory_recursive(cache_path)
		DirAccess.remove_absolute(cache_path)

	show_message(
		t("title_cache"),
		t("cache_done")
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
	message_dialog.title = t("title_notice")
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
	about_dialog.title = t("title_about")
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

	about_dialog.title = t("title_about")

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

	if is_dragging:
		save_settings()

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
