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
var is_game_mode := false
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

const MENU_SETTINGS := 1
const MENU_HELP := 2
const MENU_EXIT := 3

# =========================
# 小程序菜单 ID
# =========================

const APP_STATUS_TIMER := 101
const APP_POMODORO := 102
const APP_GAME_MODE := 103

# =========================
# 多语言文本
# =========================

const TEXTS := {
	"zh_CN": {
		"menu_apps": "小程序",
		"menu_settings": "设置...",
		"menu_help": "帮助",
		"menu_exit": "退出程序",

		"app_status_timer": "状态计时器",
		"app_pomodoro": "番茄钟",
		"app_game_mode": "游戏模式",

		"setting_title": "设置",
		"setting_other": "其他设置",
		"setting_personal": "个性化设置",
		"setting_auto_start": "开机自启",
		"setting_always_on_top": "置顶",
		"setting_game_mode": "游戏模式",
		"setting_reset_position": "重置位置",
		"setting_clear_cache": "删除缓存",

		"setting_display": "显示设置",
		"setting_size": "窗口大小",
		"setting_opacity": "透明度",

		"setting_language": "语言设置",

		"setting_about": "关于项目",
		"about_app": "FuschiaDesktop V0.1\nSpecial Thanks to total_kk",

		"title_feature": "功能预告",
		"title_notice": "提示",
		"button_done": "完成",

		"status_timer_soon": "状态计时器将在后续版本开放。",
		"pomodoro_soon": "番茄钟将在后续版本开放。",
		"game_mode_soon": "游戏模式将在后续版本完善。",
		"personal_soon": "个性化设置将在后续版本开放。",
		"auto_start_soon": "开机自启将在后续版本开放。"
	},

	"zh_TW": {
		"menu_apps": "小程式",
		"menu_settings": "設定...",
		"menu_help": "幫助",
		"menu_exit": "退出程式",

		"app_status_timer": "狀態計時器",
		"app_pomodoro": "番茄鐘",
		"app_game_mode": "遊戲模式",

		"setting_title": "設定",
		"setting_other": "其他設定",
		"setting_personal": "個人化設定",
		"setting_auto_start": "開機自啟",
		"setting_always_on_top": "置頂",
		"setting_game_mode": "遊戲模式",
		"setting_reset_position": "重設位置",
		"setting_clear_cache": "刪除快取",

		"setting_display": "顯示設定",
		"setting_size": "視窗大小",
		"setting_opacity": "透明度",

		"setting_language": "語言設定",

		"setting_about": "關於項目",
		"about_app": "FuschiaDesktop V0.1\nSpecial Thanks to total_kk",

		"title_feature": "功能預告",
		"title_notice": "提示",
		"button_done": "完成",

		"status_timer_soon": "狀態計時器將在後續版本開放。",
		"pomodoro_soon": "番茄鐘將在後續版本開放。",
		"game_mode_soon": "遊戲模式將在後續版本完善。",
		"personal_soon": "個人化設定將在後續版本開放。",
		"auto_start_soon": "開機自啟將在後續版本開放。"
	},

	"en": {
		"menu_apps": "Apps",
		"menu_settings": "Settings...",
		"menu_help": "Help",
		"menu_exit": "Exit",

		"app_status_timer": "Status Timer",
		"app_pomodoro": "Pomodoro",
		"app_game_mode": "Game Mode",

		"setting_title": "Settings",
		"setting_other": "Other Settings",
		"setting_personal": "Personalization",
		"setting_auto_start": "Startup",
		"setting_always_on_top": "Top",
		"setting_game_mode": "Game Mode",
		"setting_reset_position": "Reset Position",
		"setting_clear_cache": "Clear Cache",

		"setting_display": "Display Settings",
		"setting_size": "Size",
		"setting_opacity": "Opacity",

		"setting_language": "Language Settings",

		"setting_about": "About Project",
		"about_app": "FuschiaDesktop V0.1\nSpecial Thanks to total_kk",

		"title_feature": "Coming Soon",
		"title_notice": "Notice",
		"button_done": "Done",

		"status_timer_soon": "Status Timer will be available in a future version.",
		"pomodoro_soon": "Pomodoro will be available in a future version.",
		"game_mode_soon": "Game Mode will be improved in a future version.",
		"personal_soon": "Personalization settings will be available in a future version.",
		"auto_start_soon": "Launch at Startup will be available in a future version."
	},

	"ja_JP": {
		"menu_apps": "ミニアプリ",
		"menu_settings": "設定...",
		"menu_help": "ヘルプ",
		"menu_exit": "終了",

		"app_status_timer": "ステータスタイマー",
		"app_pomodoro": "ポモドーロ",
		"app_game_mode": "ゲームモード",

		"setting_title": "設定",
		"setting_other": "その他の設定",
		"setting_personal": "個人設定",
		"setting_auto_start": "自動起動",
		"setting_always_on_top": "最前面",
		"setting_game_mode": "ゲーム",
		"setting_reset_position": "位置をリセット",
		"setting_clear_cache": "キャッシュ削除",

		"setting_display": "表示設定",
		"setting_size": "サイズ",
		"setting_opacity": "透明度",

		"setting_language": "言語設定",

		"setting_about": "プロジェクト情報",
		"about_app": "FuschiaDesktop V0.1\nSpecial Thanks to total_kk",

		"title_feature": "今後の機能",
		"title_notice": "通知",
		"button_done": "完了",

		"status_timer_soon": "ステータスタイマーは今後のバージョンで利用可能になります。",
		"pomodoro_soon": "ポモドーロは今後のバージョンで利用可能になります。",
		"game_mode_soon": "ゲームモードは今後のバージョンで改善されます。",
		"personal_soon": "個人設定は今後のバージョンで利用可能になります。",
		"auto_start_soon": "起動時に実行は今後のバージョンで利用可能になります。"
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
@onready var setting_menu: AcceptDialog = $SettingMenu

# =========================
# 通用提示弹窗
# =========================

var message_dialog: AcceptDialog
var message_label: Label

# =========================
# 设置窗口控件
# =========================

var auto_start_check: CheckBox
var always_on_top_check: CheckBox
var game_mode_check: CheckBox

var size_slider: HSlider
var size_value_label: Label

var opacity_slider: HSlider
var opacity_value_label: Label

var language_option: OptionButton
var about_text_label: Label

var setting_scroll: ScrollContainer
var setting_content: VBoxContainer

var scrollbar_fade_timer: Timer
var scrollbar_fade_tween: Tween

# =========================
# 初始化
# =========================

func _ready():

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

	apply_default_settings()

	pet_area.input_pickable = true

	if not pet_area.input_event.is_connected(_on_pet_area_input):
		pet_area.input_event.connect(_on_pet_area_input)

	setup_message_dialog()
	setup_setting_menu()
	setup_menu()

	load_settings()

	if not anim_player.animation_finished.is_connected(_on_animation_finished):
		anim_player.animation_finished.connect(_on_animation_finished)

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

		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			stop_drag()
			return

		var mouse_screen := Vector2(
			DisplayServer.mouse_get_position()
		)

		var grab_in_window := pet_sprite.to_global(
			grab_point.position
		)

		var target_window_pos := mouse_screen - grab_in_window

		DisplayServer.window_set_position(
			Vector2i(target_window_pos)
		)

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

		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:
				is_dragging = true

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
# 右键菜单
# =========================

func setup_menu():

	popup_menu.clear()

	popup_menu.add_submenu_item(t("menu_apps"), "AppMenu")
	popup_menu.add_item(t("menu_settings"), MENU_SETTINGS)

	popup_menu.add_separator()

	popup_menu.add_item(t("menu_help"), MENU_HELP)
	popup_menu.add_item(t("menu_exit"), MENU_EXIT)

	if not popup_menu.id_pressed.is_connected(_on_menu_selected):
		popup_menu.id_pressed.connect(_on_menu_selected)

	app_menu.clear()

	app_menu.add_item(t("app_status_timer"), APP_STATUS_TIMER)
	app_menu.add_item(t("app_pomodoro"), APP_POMODORO)
	app_menu.add_item(t("app_game_mode"), APP_GAME_MODE)

	if not app_menu.id_pressed.is_connected(_on_menu_selected):
		app_menu.id_pressed.connect(_on_menu_selected)

	update_menu_checks()

func _on_menu_selected(id):

	match id:

		MENU_SETTINGS:
			show_setting_menu()

		MENU_HELP:
			open_help_page()

		MENU_EXIT:
			request_exit()

		APP_STATUS_TIMER:
			show_feature_placeholder("status_timer_soon")

		APP_POMODORO:
			show_feature_placeholder("pomodoro_soon")

		APP_GAME_MODE:
			toggle_game_mode()

func update_menu_checks():

	refresh_setting_menu_values()

# =========================
# 本地设置保存 / 读取
# =========================

func apply_default_settings():

	is_always_on_top = false
	is_game_mode = false
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
		"game_mode": is_game_mode,
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

	if settings.has("game_mode"):
		is_game_mode = bool(settings["game_mode"])

	if settings.has("opacity"):
		set_pet_opacity(float(settings["opacity"]), false)

	if settings.has("body_scale"):
		set_pet_size(float(settings["body_scale"]), false)

	if settings.has("language"):
		current_language = str(settings["language"])
		setup_menu()
		rebuild_setting_menu_text()

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
# 设置功能
# =========================

func toggle_always_on_top():

	is_always_on_top = not is_always_on_top

	DisplayServer.window_set_flag(
		DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP,
		is_always_on_top
	)

	refresh_setting_menu_values()
	save_settings()

func set_pet_opacity(value: float, should_save := true):

	current_opacity = clamp(value, 0.2, 1.0)

	pet_body.modulate.a = current_opacity

	refresh_setting_menu_values()

	if should_save:
		save_settings()

func set_pet_size(value: float, should_save := true):

	current_body_scale = clamp(value, 0.2, 1.0)

	var old_window_pos := DisplayServer.window_get_position()
	var old_window_size := DisplayServer.window_get_size()
	var old_window_center := Vector2(old_window_pos) + Vector2(old_window_size) * 0.5

	var visual_scale := current_body_scale / 0.6

	pet_body.scale = Vector2(visual_scale, visual_scale)

	var base_size_at_60 := Vector2i(300, 300)

	var new_window_size := Vector2i(
		int(base_size_at_60.x * current_body_scale / 0.6),
		int(base_size_at_60.y * current_body_scale / 0.6)
	)

	new_window_size.x = max(new_window_size.x, 100)
	new_window_size.y = max(new_window_size.y, 100)

	var new_window_pos := Vector2i(
		int(old_window_center.x - new_window_size.x * 0.5),
		int(old_window_center.y - new_window_size.y * 0.5)
	)

	DisplayServer.window_set_size(new_window_size)
	DisplayServer.window_set_position(new_window_pos)

	refresh_setting_menu_values()

	if should_save:
		save_settings()

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

	play_anim("Shutdown_Happy_1")

func open_help_page():

	OS.shell_open("https://fuschiadigital.cn")

func show_feature_placeholder(message_key: String):

	show_message(
		t("title_feature"),
		t(message_key)
	)

func set_language(language_code: String, should_save := true):

	current_language = language_code

	setup_menu()
	rebuild_setting_menu_text()
	refresh_setting_menu_values()
	update_dialog_button_texts()

	if should_save:
		save_settings()

func clear_cache():

	var cache_path := "user://cache"

	if DirAccess.dir_exists_absolute(cache_path):
		_delete_directory_recursive(cache_path)
		DirAccess.remove_absolute(cache_path)

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

	update_dialog_button_texts()

func show_message(title: String, message: String):

	message_dialog.title = title
	message_label.text = message

	update_dialog_button_texts()

	message_dialog.popup_centered(
		Vector2i(320, 180)
	)

func update_dialog_button_texts():

	if message_dialog != null:
		message_dialog.get_ok_button().text = t("button_done")

	if setting_menu != null:
		setting_menu.get_ok_button().text = t("button_done")

# =========================
# 设置窗口
# =========================

func setup_setting_menu():

	setting_menu.title = t("setting_title")
	setting_menu.min_size = Vector2i(360, 520)
	setting_menu.size = Vector2i(360, 520)

	update_dialog_button_texts()

	# 防止编辑器里残留的窗口尺寸影响第一次打开
	setting_menu.hide()

	# 清空 SettingMenu 里旧的自动生成内容，避免重复生成
	for child in setting_menu.get_children():
		child.queue_free()

	setting_scroll = ScrollContainer.new()
	setting_scroll.custom_minimum_size = Vector2(320, 430)
	setting_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	setting_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	setting_scroll.gui_input.connect(_on_setting_scroll_gui_input)
	setting_menu.add_child(setting_scroll)

	var vertical_scrollbar := setting_scroll.get_v_scroll_bar()
	vertical_scrollbar.modulate.a = 0.0

	scrollbar_fade_timer = Timer.new()
	scrollbar_fade_timer.one_shot = true
	scrollbar_fade_timer.wait_time = 0.6
	scrollbar_fade_timer.timeout.connect(_fade_out_setting_scrollbar)
	setting_menu.add_child(scrollbar_fade_timer)

	setting_content = VBoxContainer.new()
	setting_content.custom_minimum_size = Vector2(300, 430)
	setting_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	setting_content.add_theme_constant_override("separation", 10)
	setting_scroll.add_child(setting_content)

	build_setting_menu_content()

func build_setting_menu_content():

	for child in setting_content.get_children():
		child.queue_free()

	add_section_title(t("setting_other"))

	var check_row := HBoxContainer.new()
	check_row.alignment = BoxContainer.ALIGNMENT_CENTER
	check_row.add_theme_constant_override("separation", 12)
	setting_content.add_child(check_row)

	auto_start_check = CheckBox.new()
	auto_start_check.text = t("setting_auto_start")
	auto_start_check.toggled.connect(_on_auto_start_toggled)
	check_row.add_child(auto_start_check)

	always_on_top_check = CheckBox.new()
	always_on_top_check.text = t("setting_always_on_top")
	always_on_top_check.toggled.connect(_on_always_on_top_toggled)
	check_row.add_child(always_on_top_check)

	game_mode_check = CheckBox.new()
	game_mode_check.text = t("setting_game_mode")
	game_mode_check.toggled.connect(_on_game_mode_toggled)
	check_row.add_child(game_mode_check)

	var reset_button := Button.new()
	reset_button.text = t("setting_reset_position")
	reset_button.pressed.connect(reset_window_position)
	setting_content.add_child(reset_button)

	var clear_cache_button := Button.new()
	clear_cache_button.text = t("setting_clear_cache")
	clear_cache_button.pressed.connect(clear_cache)
	setting_content.add_child(clear_cache_button)

	add_separator_line()

	add_section_title(t("setting_display"))

	var size_row := HBoxContainer.new()
	size_row.add_theme_constant_override("separation", 8)
	setting_content.add_child(size_row)

	var size_label := Label.new()
	size_label.text = t("setting_size")
	size_label.custom_minimum_size = Vector2(100, 0)
	size_row.add_child(size_label)

	size_slider = HSlider.new()
	size_slider.min_value = 20
	size_slider.max_value = 100
	size_slider.step = 1
	size_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_slider.mouse_filter = Control.MOUSE_FILTER_STOP
	size_slider.gui_input.connect(_on_size_slider_gui_input)
	size_slider.value_changed.connect(_on_size_slider_changed)
	size_row.add_child(size_slider)

	size_value_label = Label.new()
	size_value_label.custom_minimum_size = Vector2(50, 0)
	size_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	size_row.add_child(size_value_label)

	var opacity_row := HBoxContainer.new()
	opacity_row.add_theme_constant_override("separation", 8)
	setting_content.add_child(opacity_row)

	var opacity_label := Label.new()
	opacity_label.text = t("setting_opacity")
	opacity_label.custom_minimum_size = Vector2(100, 0)
	opacity_row.add_child(opacity_label)

	opacity_slider = HSlider.new()
	opacity_slider.min_value = 20
	opacity_slider.max_value = 100
	opacity_slider.step = 1
	opacity_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	opacity_slider.mouse_filter = Control.MOUSE_FILTER_STOP
	opacity_slider.gui_input.connect(_on_opacity_slider_gui_input)
	opacity_slider.value_changed.connect(_on_opacity_slider_changed)
	opacity_row.add_child(opacity_slider)

	opacity_value_label = Label.new()
	opacity_value_label.custom_minimum_size = Vector2(50, 0)
	opacity_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	opacity_row.add_child(opacity_value_label)

	add_separator_line()

	add_section_title(t("setting_language"))

	language_option = OptionButton.new()
	language_option.add_item("简体中文", 0)
	language_option.add_item("繁體中文", 1)
	language_option.add_item("English", 2)
	language_option.add_item("日本語", 3)
	language_option.item_selected.connect(_on_language_selected)
	setting_content.add_child(language_option)

	add_separator_line()

	add_section_title(t("setting_about"))

	about_text_label = Label.new()
	about_text_label.text = t("about_app")
	about_text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	about_text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	about_text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	setting_content.add_child(about_text_label)

	refresh_setting_menu_values()
	update_dialog_button_texts()

func add_section_title(text: String):

	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 18)
	setting_content.add_child(label)

func add_separator_line():

	var separator := HSeparator.new()
	setting_content.add_child(separator)

func show_setting_menu():

	refresh_setting_menu_values()
	update_dialog_button_texts()

	# 每次打开前强制重置尺寸，避免第一次打开继承异常大小
	setting_menu.size = Vector2i(360, 520)
	setting_menu.min_size = Vector2i(360, 520)

	setting_menu.popup_centered(
		Vector2i(360, 520)
	)

func _on_setting_scroll_gui_input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:

			_show_setting_scrollbar_temporarily()

	if event is InputEventPanGesture:

		_show_setting_scrollbar_temporarily()

func _on_size_slider_gui_input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_WHEEL_UP:

			size_slider.value = clamp(size_slider.value + 1, size_slider.min_value, size_slider.max_value)
			size_slider.accept_event()

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:

			size_slider.value = clamp(size_slider.value - 1, size_slider.min_value, size_slider.max_value)
			size_slider.accept_event()

func _on_opacity_slider_gui_input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_WHEEL_UP:

			opacity_slider.value = clamp(opacity_slider.value + 1, opacity_slider.min_value, opacity_slider.max_value)
			opacity_slider.accept_event()

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:

			opacity_slider.value = clamp(opacity_slider.value - 1, opacity_slider.min_value, opacity_slider.max_value)
			opacity_slider.accept_event()

func _show_setting_scrollbar_temporarily():

	if setting_scroll == null:
		return

	var vertical_scrollbar := setting_scroll.get_v_scroll_bar()

	if vertical_scrollbar == null:
		return

	if scrollbar_fade_tween != null:
		scrollbar_fade_tween.kill()

	scrollbar_fade_tween = create_tween()
	scrollbar_fade_tween.tween_property(
		vertical_scrollbar,
		"modulate:a",
		1.0,
		0.12
	)

	if scrollbar_fade_timer != null:
		scrollbar_fade_timer.start()

func _fade_out_setting_scrollbar():

	if setting_scroll == null:
		return

	var vertical_scrollbar := setting_scroll.get_v_scroll_bar()

	if vertical_scrollbar == null:
		return

	if scrollbar_fade_tween != null:
		scrollbar_fade_tween.kill()

	scrollbar_fade_tween = create_tween()
	scrollbar_fade_tween.tween_property(
		vertical_scrollbar,
		"modulate:a",
		0.0,
		0.25
	)

func rebuild_setting_menu_text():

	if setting_content == null:
		return

	setting_menu.title = t("setting_title")

	build_setting_menu_content()

	# 语言切换后也强制恢复窗口尺寸
	setting_menu.size = Vector2i(360, 520)
	setting_menu.min_size = Vector2i(360, 520)

	update_dialog_button_texts()

func refresh_setting_menu_values():

	if setting_content == null:
		return

	if auto_start_check != null:
		auto_start_check.set_block_signals(true)
		auto_start_check.button_pressed = false
		auto_start_check.set_block_signals(false)

	if always_on_top_check != null:
		always_on_top_check.set_block_signals(true)
		always_on_top_check.button_pressed = is_always_on_top
		always_on_top_check.set_block_signals(false)

	if game_mode_check != null:
		game_mode_check.set_block_signals(true)
		game_mode_check.button_pressed = is_game_mode
		game_mode_check.set_block_signals(false)

	if size_slider != null:
		size_slider.set_block_signals(true)
		size_slider.value = int(current_body_scale * 100)
		size_slider.set_block_signals(false)

	if size_value_label != null:
		size_value_label.text = str(int(current_body_scale * 100)) + "%"

	if opacity_slider != null:
		opacity_slider.set_block_signals(true)
		opacity_slider.value = int(current_opacity * 100)
		opacity_slider.set_block_signals(false)

	if opacity_value_label != null:
		opacity_value_label.text = str(int(current_opacity * 100)) + "%"

	if language_option != null:
		language_option.set_block_signals(true)

		match current_language:
			"zh_CN":
				language_option.select(0)
			"zh_TW":
				language_option.select(1)
			"en":
				language_option.select(2)
			"ja_JP":
				language_option.select(3)

		language_option.set_block_signals(false)

func _on_auto_start_toggled(_enabled: bool):

	show_feature_placeholder("auto_start_soon")

	if auto_start_check != null:
		auto_start_check.set_block_signals(true)
		auto_start_check.button_pressed = false
		auto_start_check.set_block_signals(false)

func _on_always_on_top_toggled(enabled: bool):

	is_always_on_top = enabled

	DisplayServer.window_set_flag(
		DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP,
		is_always_on_top
	)

	refresh_setting_menu_values()
	save_settings()

func _on_game_mode_toggled(enabled: bool):

	is_game_mode = enabled

	refresh_setting_menu_values()
	save_settings()

func toggle_game_mode():

	is_game_mode = not is_game_mode

	refresh_setting_menu_values()
	save_settings()

	show_feature_placeholder("game_mode_soon")

func _on_size_slider_changed(value: float):

	set_pet_size(value / 100.0)

func _on_opacity_slider_changed(value: float):

	set_pet_opacity(value / 100.0)

func _on_language_selected(index: int):

	match index:
		0:
			set_language("zh_CN")
		1:
			set_language("zh_TW")
		2:
			set_language("en")
		3:
			set_language("ja_JP")

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
