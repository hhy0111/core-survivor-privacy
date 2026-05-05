extends Node2D

const PlayerScript := preload("res://scripts/Player.gd")
const EnemyScript := preload("res://scripts/Enemy.gd")
const ProjectileScript := preload("res://scripts/Projectile.gd")
const ExperienceGemScript := preload("res://scripts/ExperienceGem.gd")
const DroneScript := preload("res://scripts/Drone.gd")
const EffectRingScript := preload("res://scripts/EffectRing.gd")
const TouchStickScript := preload("res://scripts/TouchStick.gd")
const AdServiceScript := preload("res://scripts/AdService.gd")
const KoreanFont := preload("res://assets/fonts/NotoSansCJKkr-Regular.otf")

const RUN_SECONDS := 300.0
const TOUCH_MAX_DISTANCE := 118.0
const MAX_ENEMIES := 240
const MAX_GEMS := 420
const AD_DAILY_BONUS := "daily_bonus"
const AD_FREE_CHEST := "free_chest"
const AD_LEVEL_REROLL := "level_reroll"
const AD_REVIVE := "revive"
const AD_RUN_REWARD_2X := "run_reward_2x"
const AD_TEMP_DRONE := "temp_drone"

enum ScreenState { OPENING, LOBBY, RUN }

var rng := RandomNumberGenerator.new()
var ad_service
var screen_state := ScreenState.OPENING
var player
var camera: Camera2D
var hud_layer: CanvasLayer
var hud_root: Control
var opening_screen: Control
var lobby_screen: Control
var run_hud: Control
var hp_fill: ColorRect
var xp_fill: ColorRect
var timer_label: Label
var level_label: Label
var kill_label: Label
var banner_label: Label
var upgrade_panel: PanelContainer
var upgrade_list: VBoxContainer
var game_over_panel: PanelContainer
var game_over_label: Label
var revive_ad_button: Button
var double_reward_ad_button: Button
var touch_stick
var ui_font
var lobby_status_label: Label
var lobby_resource_label: Label
var lobby_upgrade_label: Label
var core_card_buttons := {}
var selected_core_id := "purify"
var meta_currency := 620
var daily_reward_claimed := false
var daily_ad_bonus_claimed := false
var free_chest_claimed := false
var temp_drone_ready := false
var pending_ad_placement := ""
var permanent_upgrades := {
	"core_power": 0,
	"xp_magnet": 0,
	"start_hp": 0
}
var last_run_reward := 0
var run_reward_awarded := 0
var menu_time := 0.0

var enemies: Array = []
var projectiles: Array = []
var gems: Array = []
var drones: Array = []

var elapsed_time := 0.0
var spawn_timer := 0.0
var elite_timer := 35.0
var boss_spawned := false
var level := 1
var xp := 0
var xp_to_next := 12
var kills := 0
var run_paused := false
var run_finished := false
var last_run_cleared := false
var revive_used := false
var run_reward_doubled := false
var banner_timer := 0.0

var touch_index := -1
var touch_anchor := Vector2.ZERO
var touch_current := Vector2.ZERO
var touch_vector := Vector2.ZERO
var mouse_stick_active := false

var bolt_level := 1
var bolt_damage := 22.0
var bolt_cooldown := 0.52
var bolt_timer := 0.0
var bolt_pierce := 0
var pulse_level := 0
var pulse_damage := 0.0
var pulse_radius := 0.0
var pulse_cooldown := 4.2
var pulse_timer := 0.0
var drone_level := 0
var drone_damage := 0.0
var drone_cooldown := 0.95
var drone_timer := 0.0
var magnet_radius := 145.0
var upgrade_levels := {}

var enemy_defs := {}
var upgrade_defs: Array = []


func _ready() -> void:
	rng.randomize()
	_create_ad_service()
	_build_data()
	_create_ui()
	_show_opening_screen()


func _process(delta: float) -> void:
	menu_time += delta
	if Input.is_action_just_pressed("restart_run"):
		if screen_state == ScreenState.RUN:
			_return_to_lobby()
		else:
			_show_lobby_screen()

	if screen_state != ScreenState.RUN:
		queue_redraw()
		return

	_update_touch_view()

	if run_paused or run_finished:
		_update_banner(delta)
		queue_redraw()
		return

	elapsed_time += delta
	var movement := _movement_vector()
	player.move(movement, delta)
	camera.global_position = player.global_position

	_update_spawns(delta)
	_update_enemies(delta)
	_update_weapons(delta)
	_update_projectiles()
	_update_gems(delta)
	_update_player_contacts()
	_update_drones(delta)
	_compact_entities()
	_update_leveling()
	_update_hud()
	_update_banner(delta)

	if player.hp <= 0.0:
		_finish_run(false)
	elif elapsed_time >= RUN_SECONDS:
		_finish_run(true)

	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if screen_state != ScreenState.RUN:
		return

	if event is InputEventScreenTouch:
		if event.pressed and event.position.x < get_viewport_rect().size.x * 0.58 and touch_index == -1:
			touch_index = event.index
			touch_anchor = event.position
			touch_current = event.position
		elif not event.pressed and event.index == touch_index:
			touch_index = -1
			touch_vector = Vector2.ZERO
	elif event is InputEventScreenDrag and event.index == touch_index:
		touch_current = event.position
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and event.position.x < get_viewport_rect().size.x * 0.58:
				mouse_stick_active = true
				touch_anchor = event.position
				touch_current = event.position
			elif not event.pressed and mouse_stick_active:
				mouse_stick_active = false
				touch_vector = Vector2.ZERO
	elif event is InputEventMouseMotion and mouse_stick_active:
		touch_current = event.position

	if touch_index != -1 or mouse_stick_active:
		var offset := touch_current - touch_anchor
		if offset.length() > TOUCH_MAX_DISTANCE:
			offset = offset.normalized() * TOUCH_MAX_DISTANCE
		touch_vector = offset / TOUCH_MAX_DISTANCE


func _draw() -> void:
	var view_size := get_viewport_rect().size
	var half := view_size * 0.75
	var focus := Vector2.ZERO
	if player != null:
		focus = player.position
	else:
		focus = Vector2(sin(menu_time * 0.18) * 80.0, cos(menu_time * 0.14) * 70.0)

	var start_x := floorf((focus.x - half.x) / 160.0) * 160.0
	var start_y := floorf((focus.y - half.y) / 160.0) * 160.0
	var end_x: float = float(focus.x + half.x)
	var end_y: float = float(focus.y + half.y)
	var bg_rect := Rect2(focus - half, half * 2.0)
	if player == null:
		start_x = 0.0
		start_y = 0.0
		end_x = view_size.x
		end_y = view_size.y
		bg_rect = Rect2(Vector2.ZERO, view_size)

	draw_rect(bg_rect, Color(0.035, 0.043, 0.08), true)

	var x := start_x
	while x < end_x:
		draw_line(Vector2(x, start_y), Vector2(x, end_y), Color(0.15, 0.22, 0.34, 0.16), 1.0)
		x += 160.0

	var y := start_y
	while y < end_y:
		draw_line(Vector2(start_x, y), Vector2(end_x, y), Color(0.15, 0.22, 0.34, 0.16), 1.0)
		y += 160.0

	for i in range(80):
		var sx := start_x + float((i * 97) % 1280)
		var sy := start_y + float((i * 173) % 1920)
		draw_circle(Vector2(sx, sy), 1.5 + float(i % 3), Color(0.75, 0.9, 1.0, 0.22))

	if screen_state == ScreenState.OPENING:
		_draw_opening_art()
	elif screen_state == ScreenState.LOBBY:
		_draw_lobby_art()


func _draw_opening_art() -> void:
	var center := Vector2(360.0, 540.0)
	var pulse := 1.0 + sin(menu_time * 2.4) * 0.035
	draw_circle(center, 190.0 * pulse, Color(0.08, 0.55, 0.95, 0.08))
	draw_circle(center, 132.0 * pulse, Color(0.12, 0.95, 0.82, 0.12))
	for i in range(12):
		var angle := menu_time * 0.35 + TAU * float(i) / 12.0
		var p := center + Vector2(cos(angle), sin(angle)) * (218.0 + sin(menu_time + i) * 12.0)
		draw_circle(p, 5.0 + float(i % 3), Color(0.48, 0.9, 1.0, 0.55))
	_draw_core_symbol(center, Color(0.18, 0.94, 0.72), 2.4)

	var enemy_positions := [
		Vector2(126.0, 400.0),
		Vector2(580.0, 426.0),
		Vector2(158.0, 732.0),
		Vector2(610.0, 720.0)
	]
	var enemy_colors := [
		Color(0.95, 0.16, 0.42),
		Color(1.0, 0.42, 0.2),
		Color(0.52, 0.34, 0.96),
		Color(0.1, 0.72, 0.92)
	]
	for i in range(enemy_positions.size()):
		_draw_enemy_symbol(enemy_positions[i] + Vector2(0.0, sin(menu_time * 2.0 + i) * 8.0), enemy_colors[i], 1.0 + float(i % 2) * 0.18)


func _draw_lobby_art() -> void:
	var center := Vector2(360.0, 898.0)
	var accent := Color(0.18, 0.94, 0.72)
	if selected_core_id == "attack":
		accent = Color(1.0, 0.42, 0.2)
	elif selected_core_id == "absorb":
		accent = Color(0.48, 0.34, 0.96)
	draw_circle(center, 120.0, Color(accent.r, accent.g, accent.b, 0.08))
	draw_arc(center, 150.0 + sin(menu_time * 1.8) * 8.0, menu_time * 0.3, menu_time * 0.3 + TAU * 0.72, 80, Color(accent.r, accent.g, accent.b, 0.22), 8.0)
	_draw_core_symbol(center, accent, 1.6)
	for i in range(7):
		var angle := menu_time * 0.42 + TAU * float(i) / 7.0
		var p := center + Vector2(cos(angle), sin(angle)) * (184.0 + float(i % 2) * 18.0)
		draw_circle(p, 4.0, Color(0.7, 0.95, 1.0, 0.5))


func _draw_core_symbol(center: Vector2, body_color: Color, scale: float) -> void:
	var radius := 30.0 * scale
	draw_circle(center, radius + 15.0 * scale, Color(body_color.r, body_color.g, body_color.b, 0.18))
	draw_circle(center, radius, Color(0.04, 0.11, 0.14))
	draw_circle(center, radius - 4.0 * scale, body_color)
	draw_circle(center + Vector2(-10.0, -7.0) * scale, 5.5 * scale, Color.WHITE)
	draw_circle(center + Vector2(10.0, -7.0) * scale, 5.5 * scale, Color.WHITE)
	draw_circle(center + Vector2(-8.5, -6.2) * scale, 2.4 * scale, Color(0.03, 0.08, 0.1))
	draw_circle(center + Vector2(11.5, -6.2) * scale, 2.4 * scale, Color(0.03, 0.08, 0.1))
	draw_arc(center + Vector2(0.0, 5.0) * scale, 11.0 * scale, 0.2, PI - 0.2, 18, Color(0.03, 0.08, 0.1), 2.8 * scale)


func _draw_enemy_symbol(center: Vector2, body_color: Color, scale: float) -> void:
	var radius := 18.0 * scale
	draw_circle(center, radius + 6.0, Color(body_color.r, body_color.g, body_color.b, 0.14))
	draw_circle(center, radius, Color(0.09, 0.04, 0.08))
	draw_circle(center, radius - 3.0, body_color)
	draw_circle(center + Vector2(-5.0, -3.0) * scale, 2.5 * scale, Color(0.05, 0.02, 0.05))
	draw_circle(center + Vector2(6.0, -3.0) * scale, 2.5 * scale, Color(0.05, 0.02, 0.05))


func _build_data() -> void:
	enemy_defs = {
		"drifter": {"id": "drifter", "name": "오염 드리프터", "type": "normal", "hp": 22.0, "speed": 86.0, "damage": 9.0, "xp": 2, "radius": 20.0, "color": Color(0.9, 0.2, 0.46)},
		"chaser": {"id": "chaser", "name": "돌진 먼지", "type": "normal", "hp": 18.0, "speed": 130.0, "damage": 8.0, "xp": 2, "radius": 17.0, "color": Color(1.0, 0.42, 0.22)},
		"bulwark": {"id": "bulwark", "name": "오염 덩어리", "type": "normal", "hp": 56.0, "speed": 60.0, "damage": 15.0, "xp": 5, "radius": 27.0, "color": Color(0.55, 0.35, 0.95)},
		"splitter": {"id": "splitter", "name": "분열 찌꺼기", "type": "normal", "hp": 34.0, "speed": 102.0, "damage": 10.0, "xp": 4, "radius": 22.0, "color": Color(0.1, 0.78, 0.95)},
		"elite_guard": {"id": "elite_guard", "name": "엘리트 가드", "type": "elite", "hp": 180.0, "speed": 74.0, "damage": 22.0, "xp": 18, "radius": 35.0, "color": Color(1.0, 0.82, 0.18)},
		"boss_warden": {"id": "boss_warden", "name": "정화 방해자", "type": "boss", "hp": 1100.0, "speed": 46.0, "damage": 32.0, "xp": 90, "radius": 58.0, "color": Color(1.0, 0.12, 0.28)}
	}

	upgrade_defs = [
		{"id": "bolt", "title": "정화 볼트", "max": 8, "desc": "자동 탄환 피해와 발사 속도 증가"},
		{"id": "pulse", "title": "펄스 웨이브", "max": 6, "desc": "주기적으로 주변 오염체를 밀어내며 피해"},
		{"id": "drone", "title": "정화 드론", "max": 6, "desc": "궤도 드론이 가까운 적을 보조 사격"},
		{"id": "magnet", "title": "흡수 반경", "max": 5, "desc": "오염 에너지 자동 흡수 거리 증가"},
		{"id": "speed", "title": "회피 기동", "max": 5, "desc": "이동 속도 증가"},
		{"id": "core", "title": "코어 안정화", "max": 5, "desc": "최대 체력 증가 및 즉시 회복"}
	]


func _create_ad_service() -> void:
	ad_service = AdServiceScript.new()
	add_child(ad_service)
	ad_service.reward_granted.connect(_on_ad_reward_granted)
	ad_service.ad_failed.connect(_on_ad_failed)
	ad_service.ad_closed.connect(_on_ad_closed)
	ad_service.initialize()


func _create_world() -> void:
	player = PlayerScript.new()
	player.position = Vector2.ZERO
	add_child(player)

	camera = Camera2D.new()
	camera.enabled = true
	camera.position = Vector2.ZERO
	player.add_child(camera)


func _show_opening_screen() -> void:
	screen_state = ScreenState.OPENING
	opening_screen.visible = true
	lobby_screen.visible = false
	run_hud.visible = false
	_clear_run_entities()
	queue_redraw()


func _show_lobby_screen() -> void:
	screen_state = ScreenState.LOBBY
	opening_screen.visible = false
	lobby_screen.visible = true
	run_hud.visible = false
	_clear_run_entities()
	_update_lobby_ui()
	_show_lobby_notice("코어를 선택하고 영구 강화를 확인한 뒤 정화 런을 시작하세요.")
	queue_redraw()


func _start_run() -> void:
	var use_temp_drone := temp_drone_ready
	temp_drone_ready = false
	_clear_run_entities()
	_reset_run_values()
	_create_world()
	_apply_lobby_loadout()
	if use_temp_drone:
		_activate_temp_drone()
	screen_state = ScreenState.RUN
	opening_screen.visible = false
	lobby_screen.visible = false
	run_hud.visible = true
	upgrade_panel.visible = false
	game_over_panel.visible = false
	_update_hud()
	_update_lobby_ui()
	var banner_text := "%s 코어 출격" % _selected_core_name()
	if use_temp_drone:
		banner_text += " / 광고 드론 동행"
	_show_banner(banner_text)


func _return_to_lobby() -> void:
	_show_lobby_screen()


func _clear_run_entities() -> void:
	for child in get_children():
		if child != hud_layer and child != ad_service:
			child.queue_free()
	enemies.clear()
	projectiles.clear()
	gems.clear()
	drones.clear()
	player = null
	camera = null
	touch_index = -1
	mouse_stick_active = false
	touch_vector = Vector2.ZERO


func _reset_run_values() -> void:
	elapsed_time = 0.0
	spawn_timer = 0.0
	elite_timer = 35.0
	boss_spawned = false
	level = 1
	xp = 0
	xp_to_next = 12
	kills = 0
	run_paused = false
	run_finished = false
	last_run_cleared = false
	revive_used = false
	run_reward_doubled = false
	banner_timer = 0.0
	last_run_reward = 0
	run_reward_awarded = 0

	bolt_level = 1
	bolt_damage = 22.0
	bolt_cooldown = 0.52
	bolt_timer = 0.0
	bolt_pierce = 0
	pulse_level = 0
	pulse_damage = 0.0
	pulse_radius = 0.0
	pulse_cooldown = 4.2
	pulse_timer = 0.0
	drone_level = 0
	drone_damage = 0.0
	drone_cooldown = 0.95
	drone_timer = 0.0
	magnet_radius = 145.0
	upgrade_levels.clear()


func _apply_lobby_loadout() -> void:
	var hp_bonus := int(permanent_upgrades["start_hp"]) * 18
	var power_bonus := int(permanent_upgrades["core_power"]) * 4
	var magnet_bonus := int(permanent_upgrades["xp_magnet"]) * 24

	player.max_hp = 120.0 + hp_bonus
	bolt_damage += power_bonus
	magnet_radius += magnet_bonus

	match selected_core_id:
		"purify":
			player.max_hp += 20.0
			player.set_core_palette(Color(0.19, 0.93, 0.72), Color(0.15, 0.9, 1.0, 0.18))
		"attack":
			bolt_damage *= 1.15
			bolt_cooldown *= 0.94
			player.set_core_palette(Color(1.0, 0.38, 0.16), Color(1.0, 0.42, 0.12, 0.18))
		"absorb":
			magnet_radius += 45.0
			player.set_core_palette(Color(0.48, 0.34, 0.96), Color(0.46, 0.34, 1.0, 0.18))

	player.hp = player.max_hp
	player.queue_redraw()


func _activate_temp_drone() -> void:
	drone_level = max(1, drone_level)
	drone_damage = maxf(20.0, drone_damage)
	drone_cooldown = minf(0.86, drone_cooldown)
	_sync_drones()


func _selected_core_name() -> String:
	match selected_core_id:
		"attack":
			return "공격형"
		"absorb":
			return "흡수형"
		_:
			return "정화형"


func _create_ui() -> void:
	hud_layer = CanvasLayer.new()
	add_child(hud_layer)
	hud_root = Control.new()
	hud_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui_font = _load_ui_font()
	if ui_font != null:
		var ui_theme := Theme.new()
		ui_theme.default_font = ui_font
		hud_root.theme = ui_theme
	hud_layer.add_child(hud_root)

	_create_opening_screen()
	_create_lobby_screen()
	_create_run_hud()


func _create_run_hud() -> void:
	run_hud = Control.new()
	run_hud.set_anchors_preset(Control.PRESET_FULL_RECT)
	run_hud.visible = false
	hud_root.add_child(run_hud)

	timer_label = _make_label(run_hud, Vector2(24.0, 16.0), 24, Color.WHITE)
	level_label = _make_label(run_hud, Vector2(24.0, 92.0), 18, Color(0.82, 0.95, 1.0))
	kill_label = _make_label(run_hud, Vector2(24.0, 120.0), 18, Color(0.82, 0.95, 1.0))
	banner_label = _make_label(run_hud, Vector2(0.0, 190.0), 28, Color(1.0, 0.95, 0.55))
	banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	banner_label.size = Vector2(720.0, 42.0)

	var hp_back := _make_bar_back(run_hud, Vector2(24.0, 58.0), Vector2(320.0, 16.0))
	hp_fill = _make_bar_fill(hp_back, Color(0.28, 1.0, 0.45))
	var xp_back := _make_bar_back(run_hud, Vector2(24.0, 78.0), Vector2(320.0, 10.0))
	xp_fill = _make_bar_fill(xp_back, Color(0.3, 0.7, 1.0))

	touch_stick = TouchStickScript.new()
	touch_stick.set_anchors_preset(Control.PRESET_FULL_RECT)
	run_hud.add_child(touch_stick)

	_create_upgrade_panel()
	_create_game_over_panel()


func _create_opening_screen() -> void:
	opening_screen = Control.new()
	opening_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	hud_root.add_child(opening_screen)

	var title := _make_label(opening_screen, Vector2(40.0, 90.0), 44, Color(0.88, 1.0, 0.96))
	title.text = "Core Survivor\nCosmic Purge"
	title.size = Vector2(640.0, 130.0)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	var subtitle := _make_label(opening_screen, Vector2(66.0, 242.0), 22, Color(0.78, 0.94, 1.0))
	subtitle.text = "오염된 우주를 정화하는 자동 전투 생존 액션"
	subtitle.size = Vector2(588.0, 42.0)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	var start_button := _make_menu_button(opening_screen, Vector2(80.0, 960.0), Vector2(560.0, 88.0), "시작하기", Color(0.08, 0.74, 0.64))
	start_button.pressed.connect(_show_lobby_screen)

	var guide := _make_label(opening_screen, Vector2(80.0, 1062.0), 18, Color(0.62, 0.76, 0.84))
	guide.text = "로비에서 코어 선택, 강화, 보상을 준비한 뒤 런을 시작합니다."
	guide.size = Vector2(560.0, 70.0)
	guide.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	guide.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func _create_lobby_screen() -> void:
	lobby_screen = Control.new()
	lobby_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	lobby_screen.visible = false
	hud_root.add_child(lobby_screen)

	var title := _make_label(lobby_screen, Vector2(26.0, 24.0), 30, Color(0.9, 1.0, 0.96))
	title.text = "정화 로비"
	title.size = Vector2(260.0, 44.0)

	lobby_resource_label = _make_label(lobby_screen, Vector2(360.0, 28.0), 19, Color(1.0, 0.9, 0.45))
	lobby_resource_label.size = Vector2(330.0, 32.0)
	lobby_resource_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	var stage_panel := _make_panel(lobby_screen, Vector2(26.0, 82.0), Vector2(668.0, 90.0), Color(0.035, 0.08, 0.11, 0.86), Color(0.26, 0.88, 1.0, 0.6))
	var stage_title := _make_label(stage_panel, Vector2(20.0, 12.0), 19, Color(0.78, 0.96, 1.0))
	stage_title.text = "스테이지 1  클린 오비트"
	stage_title.size = Vector2(300.0, 30.0)
	var stage_desc := _make_label(stage_panel, Vector2(20.0, 44.0), 16, Color(0.74, 0.82, 0.88))
	stage_desc.text = "목표: 5분 생존  /  보스: 정화 방해자  /  추천 전투력: 120"
	stage_desc.size = Vector2(600.0, 30.0)

	_create_core_card("purify", "정화형", "체력 +20\n안정적인 초반 생존", Vector2(26.0, 196.0), Color(0.12, 0.82, 0.72))
	_create_core_card("attack", "공격형", "볼트 피해 +15%\n빠른 처치 중심", Vector2(250.0, 196.0), Color(0.94, 0.36, 0.18))
	_create_core_card("absorb", "흡수형", "흡수 반경 +45\n레벨업 가속", Vector2(474.0, 196.0), Color(0.48, 0.34, 0.95))

	var mission_panel := _make_panel(lobby_screen, Vector2(26.0, 396.0), Vector2(318.0, 228.0), Color(0.04, 0.07, 0.1, 0.88), Color(0.28, 0.9, 1.0, 0.48))
	var mission_title := _make_label(mission_panel, Vector2(18.0, 16.0), 21, Color(0.9, 1.0, 0.88))
	mission_title.text = "오늘의 준비"
	var mission_text := _make_label(mission_panel, Vector2(18.0, 56.0), 16, Color(0.74, 0.84, 0.9))
	mission_text.text = "일일 보급을 받고\n초반 영구 강화를 올린 뒤\n런을 시작하세요."
	mission_text.size = Vector2(270.0, 82.0)
	mission_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var daily_button := _make_menu_button(mission_panel, Vector2(18.0, 150.0), Vector2(282.0, 58.0), "일일 보급 받기", Color(0.12, 0.58, 0.88))
	daily_button.pressed.connect(_claim_daily_reward)

	var upgrade_panel_lobby := _make_panel(lobby_screen, Vector2(376.0, 396.0), Vector2(318.0, 258.0), Color(0.04, 0.07, 0.1, 0.88), Color(1.0, 0.78, 0.25, 0.45))
	var upgrade_title := _make_label(upgrade_panel_lobby, Vector2(18.0, 16.0), 21, Color(1.0, 0.9, 0.54))
	upgrade_title.text = "영구 강화"
	lobby_upgrade_label = _make_label(upgrade_panel_lobby, Vector2(18.0, 52.0), 15, Color(0.78, 0.86, 0.92))
	lobby_upgrade_label.size = Vector2(270.0, 38.0)
	var power_button := _make_menu_button(upgrade_panel_lobby, Vector2(18.0, 102.0), Vector2(282.0, 40.0), "코어 출력 +1", Color(0.12, 0.32, 0.44))
	power_button.pressed.connect(_buy_permanent_upgrade.bind("core_power"))
	var magnet_button := _make_menu_button(upgrade_panel_lobby, Vector2(18.0, 150.0), Vector2(282.0, 40.0), "흡수 반경 +1", Color(0.16, 0.28, 0.52))
	magnet_button.pressed.connect(_buy_permanent_upgrade.bind("xp_magnet"))
	var hp_button := _make_menu_button(upgrade_panel_lobby, Vector2(18.0, 198.0), Vector2(282.0, 40.0), "시작 체력 +1", Color(0.18, 0.44, 0.32))
	hp_button.pressed.connect(_buy_permanent_upgrade.bind("start_hp"))

	var nav_names := ["무기 도감", "드론", "상점", "설정"]
	for i in range(nav_names.size()):
		var nav_button := _make_menu_button(lobby_screen, Vector2(26.0 + i * 169.0, 676.0), Vector2(150.0, 58.0), nav_names[i], Color(0.08, 0.14, 0.2))
		nav_button.pressed.connect(_show_lobby_notice.bind("%s은 다음 개발 단계에서 상세 화면을 연결합니다." % nav_names[i]))

	_create_lobby_ad_reward_panel()

	lobby_status_label = _make_label(lobby_screen, Vector2(44.0, 958.0), 17, Color(0.7, 0.9, 1.0))
	lobby_status_label.size = Vector2(632.0, 62.0)
	lobby_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lobby_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var start_run_button := _make_menu_button(lobby_screen, Vector2(42.0, 1040.0), Vector2(636.0, 92.0), "정화 런 시작", Color(0.1, 0.76, 0.58))
	start_run_button.add_theme_font_size_override("font_size", 28)
	start_run_button.pressed.connect(_start_run)

	var footer := _make_label(lobby_screen, Vector2(50.0, 1148.0), 15, Color(0.56, 0.68, 0.76))
	footer.text = "광고 보상은 선택형입니다. 강제 광고 없이 보상만 추가로 받을 수 있습니다."
	footer.size = Vector2(620.0, 50.0)
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	footer.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	_update_lobby_ui()


func _create_lobby_ad_reward_panel() -> void:
	var ad_panel := _make_panel(lobby_screen, Vector2(26.0, 754.0), Vector2(668.0, 184.0), Color(0.035, 0.07, 0.1, 0.9), Color(0.4, 0.95, 1.0, 0.5))
	var ad_title := _make_label(ad_panel, Vector2(18.0, 12.0), 21, Color(0.88, 1.0, 0.95))
	ad_title.text = "광고 보상"
	ad_title.size = Vector2(220.0, 32.0)
	var ad_desc := _make_label(ad_panel, Vector2(18.0, 44.0), 15, Color(0.7, 0.84, 0.9))
	ad_desc.text = "필요할 때만 선택해서 보상을 받습니다."
	ad_desc.size = Vector2(520.0, 28.0)

	var daily_ad_button := _make_menu_button(ad_panel, Vector2(18.0, 90.0), Vector2(200.0, 64.0), "추가 보너스", Color(0.12, 0.48, 0.74))
	daily_ad_button.add_theme_font_size_override("font_size", 17)
	daily_ad_button.pressed.connect(_request_daily_ad_bonus)

	var chest_button := _make_menu_button(ad_panel, Vector2(234.0, 90.0), Vector2(200.0, 64.0), "무료 상자", Color(0.42, 0.28, 0.76))
	chest_button.add_theme_font_size_override("font_size", 17)
	chest_button.pressed.connect(_request_free_chest_ad)

	var temp_drone_button := _make_menu_button(ad_panel, Vector2(450.0, 90.0), Vector2(200.0, 64.0), "드론 체험", Color(0.62, 0.38, 0.14))
	temp_drone_button.add_theme_font_size_override("font_size", 17)
	temp_drone_button.pressed.connect(_request_temp_drone_ad)


func _make_label(parent: Control, pos: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.position = pos
	label.size = Vector2(360.0, 34.0)
	label.add_theme_font_size_override("font_size", font_size)
	_apply_ui_font(label)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	parent.add_child(label)
	return label


func _make_panel(parent: Control, pos: Vector2, panel_size: Vector2, bg: Color, border: Color) -> Panel:
	var panel := Panel.new()
	panel.position = pos
	panel.size = panel_size
	panel.add_theme_stylebox_override("panel", _panel_style(bg, border))
	parent.add_child(panel)
	return panel


func _make_menu_button(parent: Control, pos: Vector2, button_size: Vector2, text: String, color: Color) -> Button:
	var button := Button.new()
	button.position = pos
	button.size = button_size
	button.text = text
	button.add_theme_font_size_override("font_size", 20)
	_apply_ui_font(button)
	button.add_theme_stylebox_override("normal", _button_style(color))
	button.add_theme_stylebox_override("hover", _button_style(color.lightened(0.12)))
	button.add_theme_stylebox_override("pressed", _button_style(color.darkened(0.18)))
	parent.add_child(button)
	return button


func _create_core_card(core_id: String, title: String, desc: String, pos: Vector2, accent: Color) -> void:
	var button := _make_menu_button(lobby_screen, pos, Vector2(198.0, 166.0), "%s\n%s" % [title, desc], accent.darkened(0.35))
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.add_theme_font_size_override("font_size", 18)
	button.set_meta("accent", accent)
	button.pressed.connect(_select_core.bind(core_id))
	core_card_buttons[core_id] = button


func _select_core(core_id: String) -> void:
	selected_core_id = core_id
	_update_lobby_ui()


func _claim_daily_reward() -> void:
	if daily_reward_claimed:
		_show_lobby_notice("오늘의 보급은 이미 받았습니다. 다음 접속 보상은 저장 시스템 연결 후 초기화됩니다.")
		return
	daily_reward_claimed = true
	meta_currency += 240
	_update_lobby_ui()
	_show_lobby_notice("정화 코어 파편 240개를 받았습니다.")


func _request_daily_ad_bonus() -> void:
	if daily_ad_bonus_claimed:
		_show_lobby_notice("광고 추가 보너스는 이미 받았습니다.")
		return
	_request_ad_reward(AD_DAILY_BONUS)


func _request_free_chest_ad() -> void:
	if free_chest_claimed:
		_show_lobby_notice("무료 상자는 이미 열었습니다.")
		return
	_request_ad_reward(AD_FREE_CHEST)


func _request_temp_drone_ad() -> void:
	if temp_drone_ready:
		_show_lobby_notice("광고 드론 체험권이 준비되어 있습니다. 다음 런에 자동으로 사용됩니다.")
		return
	_request_ad_reward(AD_TEMP_DRONE)


func _request_ad_reward(placement: String) -> void:
	pending_ad_placement = placement
	if ad_service == null or not ad_service.request_reward(placement):
		pending_ad_placement = ""
		var message := "광고가 아직 준비되지 않았습니다. Android APK에서 잠시 후 다시 시도하세요."
		if screen_state == ScreenState.RUN:
			_show_banner(message)
		else:
			_show_lobby_notice(message)


func _buy_permanent_upgrade(upgrade_id: String) -> void:
	var current := int(permanent_upgrades.get(upgrade_id, 0))
	var cost := 120 + current * 90
	if meta_currency < cost:
		_show_lobby_notice("정화 코어 파편이 부족합니다. 런 보상이나 일일 보급으로 모을 수 있습니다.")
		return
	meta_currency -= cost
	permanent_upgrades[upgrade_id] = current + 1
	_update_lobby_ui()
	_show_lobby_notice("영구 강화가 적용되었습니다. 다음 런부터 바로 반영됩니다.")


func _show_lobby_notice(text: String) -> void:
	if lobby_status_label != null:
		lobby_status_label.text = text


func _update_lobby_ui() -> void:
	if lobby_resource_label != null:
		lobby_resource_label.text = "정화 코어 파편 %d" % meta_currency
	if lobby_upgrade_label != null:
		lobby_upgrade_label.text = "출력 Lv.%d  흡수 Lv.%d  체력 Lv.%d" % [
			int(permanent_upgrades["core_power"]),
			int(permanent_upgrades["xp_magnet"]),
			int(permanent_upgrades["start_hp"])
		]
	for core_id in core_card_buttons.keys():
		var button: Button = core_card_buttons[core_id]
		var accent: Color = button.get_meta("accent")
		if core_id == selected_core_id:
			button.add_theme_stylebox_override("normal", _button_style(accent.darkened(0.05)))
			button.add_theme_stylebox_override("hover", _button_style(accent.lightened(0.08)))
		else:
			button.add_theme_stylebox_override("normal", _button_style(Color(0.05, 0.12, 0.17)))
			button.add_theme_stylebox_override("hover", _button_style(Color(0.08, 0.18, 0.25)))
	if lobby_status_label != null and lobby_status_label.text.is_empty():
		lobby_status_label.text = "코어를 선택하고 영구 강화를 확인한 뒤 정화 런을 시작하세요."


func _on_ad_reward_granted(placement: String) -> void:
	pending_ad_placement = ""
	match placement:
		AD_DAILY_BONUS:
			_grant_daily_ad_bonus()
		AD_FREE_CHEST:
			_grant_free_chest()
		AD_TEMP_DRONE:
			_grant_temp_drone()
		AD_LEVEL_REROLL:
			_reroll_level_choices_from_ad()
		AD_REVIVE:
			_revive_from_ad()
		AD_RUN_REWARD_2X:
			_double_run_reward_from_ad()


func _on_ad_failed(placement: String, _message: String) -> void:
	if placement != pending_ad_placement:
		return
	pending_ad_placement = ""
	var notice := "광고를 표시하지 못했습니다. 네트워크 상태를 확인하고 다시 시도하세요."
	if screen_state == ScreenState.RUN:
		_show_banner(notice)
	else:
		_show_lobby_notice(notice)


func _on_ad_closed(_placement: String) -> void:
	pending_ad_placement = ""


func _grant_daily_ad_bonus() -> void:
	if daily_ad_bonus_claimed:
		return
	daily_ad_bonus_claimed = true
	meta_currency += 180
	_update_lobby_ui()
	_show_lobby_notice("광고 추가 보너스로 정화 코어 파편 180개를 받았습니다.")


func _grant_free_chest() -> void:
	if free_chest_claimed:
		return
	free_chest_claimed = true
	var reward := rng.randi_range(160, 260)
	meta_currency += reward
	_update_lobby_ui()
	_show_lobby_notice("무료 상자에서 정화 코어 파편 %d개를 얻었습니다." % reward)


func _grant_temp_drone() -> void:
	if temp_drone_ready:
		return
	temp_drone_ready = true
	_update_lobby_ui()
	_show_lobby_notice("광고 드론 체험권이 준비되었습니다. 다음 런 시작 시 드론 1기가 동행합니다.")


func _load_ui_font():
	return KoreanFont


func _apply_ui_font(control: Control) -> void:
	if ui_font != null:
		control.add_theme_font_override("font", ui_font)


func _make_bar_back(parent: Control, pos: Vector2, bar_size: Vector2) -> ColorRect:
	var back := ColorRect.new()
	back.position = pos
	back.size = bar_size
	back.color = Color(0.02, 0.04, 0.07, 0.78)
	parent.add_child(back)
	return back


func _make_bar_fill(parent: Control, color: Color) -> ColorRect:
	var fill := ColorRect.new()
	fill.position = Vector2(2.0, 2.0)
	fill.size = Vector2(parent.size.x - 4.0, parent.size.y - 4.0)
	fill.color = color
	parent.add_child(fill)
	return fill


func _create_upgrade_panel() -> void:
	upgrade_panel = PanelContainer.new()
	upgrade_panel.position = Vector2(50.0, 292.0)
	upgrade_panel.size = Vector2(620.0, 620.0)
	upgrade_panel.visible = false
	upgrade_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.04, 0.07, 0.11, 0.95), Color(0.3, 0.9, 1.0, 0.72)))
	run_hud.add_child(upgrade_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 22)
	margin.add_theme_constant_override("margin_right", 22)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	upgrade_panel.add_child(margin)

	upgrade_list = VBoxContainer.new()
	upgrade_list.add_theme_constant_override("separation", 14)
	margin.add_child(upgrade_list)


func _create_game_over_panel() -> void:
	game_over_panel = PanelContainer.new()
	game_over_panel.position = Vector2(70.0, 320.0)
	game_over_panel.size = Vector2(580.0, 610.0)
	game_over_panel.visible = false
	game_over_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.04, 0.06, 0.09, 0.96), Color(1.0, 0.8, 0.25, 0.8)))
	run_hud.add_child(game_over_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_bottom", 24)
	game_over_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 18)
	margin.add_child(box)

	game_over_label = Label.new()
	game_over_label.add_theme_font_size_override("font_size", 24)
	_apply_ui_font(game_over_label)
	game_over_label.add_theme_color_override("font_color", Color.WHITE)
	game_over_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	game_over_label.custom_minimum_size = Vector2(500.0, 188.0)
	box.add_child(game_over_label)

	revive_ad_button = Button.new()
	revive_ad_button.text = "광고 보고 1회 부활"
	revive_ad_button.custom_minimum_size = Vector2(500.0, 58.0)
	revive_ad_button.add_theme_font_size_override("font_size", 21)
	_apply_ui_font(revive_ad_button)
	revive_ad_button.add_theme_stylebox_override("normal", _button_style(Color(0.14, 0.44, 0.76)))
	revive_ad_button.add_theme_stylebox_override("hover", _button_style(Color(0.2, 0.58, 0.92)))
	revive_ad_button.add_theme_stylebox_override("pressed", _button_style(Color(0.08, 0.28, 0.56)))
	revive_ad_button.pressed.connect(_request_revive_ad)
	box.add_child(revive_ad_button)

	double_reward_ad_button = Button.new()
	double_reward_ad_button.text = "광고 보고 보상 2배"
	double_reward_ad_button.custom_minimum_size = Vector2(500.0, 58.0)
	double_reward_ad_button.add_theme_font_size_override("font_size", 21)
	_apply_ui_font(double_reward_ad_button)
	double_reward_ad_button.add_theme_stylebox_override("normal", _button_style(Color(0.5, 0.36, 0.12)))
	double_reward_ad_button.add_theme_stylebox_override("hover", _button_style(Color(0.68, 0.48, 0.16)))
	double_reward_ad_button.add_theme_stylebox_override("pressed", _button_style(Color(0.34, 0.24, 0.08)))
	double_reward_ad_button.pressed.connect(_request_run_reward_2x_ad)
	box.add_child(double_reward_ad_button)

	var retry := Button.new()
	retry.text = "바로 재도전"
	retry.custom_minimum_size = Vector2(500.0, 58.0)
	retry.add_theme_font_size_override("font_size", 22)
	_apply_ui_font(retry)
	retry.add_theme_stylebox_override("normal", _button_style(Color(0.12, 0.78, 0.65)))
	retry.add_theme_stylebox_override("hover", _button_style(Color(0.2, 0.92, 0.78)))
	retry.add_theme_stylebox_override("pressed", _button_style(Color(0.08, 0.62, 0.52)))
	retry.pressed.connect(_start_run)
	box.add_child(retry)

	var lobby_button := Button.new()
	lobby_button.text = "로비로 이동"
	lobby_button.custom_minimum_size = Vector2(500.0, 58.0)
	lobby_button.add_theme_font_size_override("font_size", 22)
	_apply_ui_font(lobby_button)
	lobby_button.add_theme_stylebox_override("normal", _button_style(Color(0.08, 0.18, 0.26)))
	lobby_button.add_theme_stylebox_override("hover", _button_style(Color(0.12, 0.26, 0.36)))
	lobby_button.add_theme_stylebox_override("pressed", _button_style(Color(0.05, 0.12, 0.18)))
	lobby_button.pressed.connect(_return_to_lobby)
	box.add_child(lobby_button)


func _panel_style(bg: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	return style


func _button_style(bg: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = Color(1.0, 1.0, 1.0, 0.16)
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	return style


func _request_revive_ad() -> void:
	if not run_finished or revive_used:
		return
	_request_ad_reward(AD_REVIVE)


func _request_run_reward_2x_ad() -> void:
	if not run_finished or run_reward_doubled or last_run_reward <= 0:
		return
	_request_ad_reward(AD_RUN_REWARD_2X)


func _movement_vector() -> Vector2:
	var keyboard := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	if keyboard.length_squared() > 1.0:
		keyboard = keyboard.normalized()
	if touch_vector.length_squared() > 0.02:
		return touch_vector.normalized()
	return keyboard


func _update_touch_view() -> void:
	var active := touch_index != -1 or mouse_stick_active
	touch_stick.set_stick(active, touch_anchor, touch_current, TOUCH_MAX_DISTANCE)


func _update_spawns(delta: float) -> void:
	spawn_timer -= delta
	var interval := maxf(0.18, 0.82 - elapsed_time * 0.0021)
	if spawn_timer <= 0.0 and enemies.size() < MAX_ENEMIES:
		spawn_timer = interval
		var batch := 1 + int(elapsed_time / 78.0)
		for i in range(batch):
			_spawn_enemy(_pick_enemy_id())

	elite_timer -= delta
	if elite_timer <= 0.0:
		elite_timer = 48.0
		_spawn_enemy("elite_guard")
		_show_banner("엘리트 오염체 출현")

	if elapsed_time >= 150.0 and not boss_spawned:
		boss_spawned = true
		_spawn_enemy("boss_warden")
		_show_banner("보스 출현")


func _pick_enemy_id() -> String:
	var roll := rng.randf()
	if elapsed_time < 45.0:
		return "drifter" if roll < 0.72 else "chaser"
	if elapsed_time < 110.0:
		if roll < 0.45:
			return "drifter"
		return "chaser" if roll < 0.78 else "bulwark"
	if roll < 0.34:
		return "drifter"
	if roll < 0.62:
		return "chaser"
	if roll < 0.84:
		return "splitter"
	return "bulwark"


func _spawn_enemy(enemy_id: String) -> void:
	if not enemy_defs.has(enemy_id):
		return
	var angle := rng.randf_range(0.0, TAU)
	var distance := rng.randf_range(760.0, 900.0)
	var spawn_position: Vector2 = player.position + Vector2(cos(angle), sin(angle)) * distance
	var enemy = EnemyScript.new()
	enemy.setup(enemy_defs[enemy_id], spawn_position)
	enemy.died.connect(_on_enemy_died)
	enemies.append(enemy)
	add_child(enemy)


func _update_enemies(delta: float) -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.update_ai(player.position, delta)


func _update_weapons(delta: float) -> void:
	bolt_timer -= delta
	if bolt_timer <= 0.0:
		var target = _nearest_enemy(player.position, 880.0)
		if target != null:
			bolt_timer = bolt_cooldown
			_fire_projectile(player.position, player.position.direction_to(target.position), bolt_damage, 760.0, bolt_pierce, Color(0.36, 0.96, 1.0))

	if pulse_level > 0:
		pulse_timer -= delta
		if pulse_timer <= 0.0:
			pulse_timer = pulse_cooldown
			_fire_pulse()

	if drone_level > 0:
		drone_timer -= delta
		if drone_timer <= 0.0:
			drone_timer = drone_cooldown
			for drone in drones:
				if is_instance_valid(drone):
					var target = _nearest_enemy(drone.position, 760.0)
					if target != null:
						_fire_projectile(drone.position, drone.position.direction_to(target.position), drone_damage, 680.0, 0, Color(1.0, 0.82, 0.25))


func _fire_projectile(spawn_position: Vector2, direction: Vector2, damage: float, speed: float, pierce: int, color: Color) -> void:
	if direction.length_squared() <= 0.001:
		return
	var projectile = ProjectileScript.new()
	projectile.setup(spawn_position, direction, damage, speed, pierce, color)
	projectiles.append(projectile)
	add_child(projectile)


func _fire_pulse() -> void:
	var effect = EffectRingScript.new()
	effect.setup(player.position, pulse_radius, Color(0.44, 0.95, 1.0))
	add_child(effect)
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		var distance: float = player.position.distance_to(enemy.position)
		if distance <= pulse_radius:
			var direction: Vector2 = player.position.direction_to(enemy.position)
			enemy.apply_damage(pulse_damage, direction)


func _update_projectiles() -> void:
	for projectile in projectiles:
		if not is_instance_valid(projectile):
			continue
		for enemy in enemies:
			if not is_instance_valid(enemy):
				continue
			if not projectile.can_hit(enemy):
				continue
			var hit_radius: float = projectile.radius + enemy.radius
			if projectile.position.distance_squared_to(enemy.position) <= hit_radius * hit_radius:
				enemy.apply_damage(projectile.damage, projectile.velocity)
				projectile.register_hit(enemy)
				if projectile.is_queued_for_deletion():
					break


func _update_gems(delta: float) -> void:
	for gem in gems:
		if not is_instance_valid(gem):
			continue
		var distance: float = player.position.distance_to(gem.position)
		if distance <= magnet_radius:
			var pull_speed: float = 340.0 + (magnet_radius - distance) * 3.2
			gem.attract_to(player.position, pull_speed, delta)
		if distance <= player.radius + gem.radius + 6.0:
			xp += gem.xp_value
			gem.collected = true
			gem.queue_free()


func _update_player_contacts() -> void:
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		var hit_radius: float = player.radius + enemy.radius
		if player.position.distance_squared_to(enemy.position) <= hit_radius * hit_radius:
			if player.take_damage(enemy.damage):
				var push: Vector2 = enemy.position.direction_to(player.position)
				player.position += push * 28.0
				enemy.position -= push * 18.0


func _update_drones(delta: float) -> void:
	for drone in drones:
		if is_instance_valid(drone):
			drone.update_orbit(delta)


func _nearest_enemy(origin: Vector2, max_distance: float):
	var best = null
	var best_distance := max_distance * max_distance
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		var distance := origin.distance_squared_to(enemy.position)
		if distance < best_distance:
			best = enemy
			best_distance = distance
	return best


func _on_enemy_died(enemy) -> void:
	kills += 1
	_spawn_xp(enemy.position, enemy.xp_value)
	if enemy.enemy_type == "boss":
		_show_banner("보스 정화 완료")


func _spawn_xp(spawn_position: Vector2, value: int) -> void:
	if gems.size() >= MAX_GEMS:
		return
	var gem = ExperienceGemScript.new()
	gem.setup(spawn_position + Vector2(rng.randf_range(-16.0, 16.0), rng.randf_range(-16.0, 16.0)), value)
	gems.append(gem)
	add_child(gem)


func _update_leveling() -> void:
	if xp < xp_to_next:
		return
	xp -= xp_to_next
	level += 1
	xp_to_next = int(12 + level * 7 + pow(float(level), 1.35) * 4.0)
	_show_level_up()


func _show_level_up() -> void:
	run_paused = true
	upgrade_panel.visible = true
	for child in upgrade_list.get_children():
		child.queue_free()

	var title := Label.new()
	title.text = "레벨 업 - 정화 방향 선택"
	title.add_theme_font_size_override("font_size", 26)
	_apply_ui_font(title)
	title.add_theme_color_override("font_color", Color(1.0, 0.96, 0.62))
	upgrade_list.add_child(title)

	var reroll_button := Button.new()
	reroll_button.text = "광고 보고 선택지 다시 뽑기"
	reroll_button.custom_minimum_size = Vector2(560.0, 54.0)
	reroll_button.add_theme_font_size_override("font_size", 19)
	_apply_ui_font(reroll_button)
	reroll_button.add_theme_stylebox_override("normal", _button_style(Color(0.16, 0.28, 0.48)))
	reroll_button.add_theme_stylebox_override("hover", _button_style(Color(0.2, 0.38, 0.62)))
	reroll_button.add_theme_stylebox_override("pressed", _button_style(Color(0.1, 0.18, 0.32)))
	reroll_button.pressed.connect(_request_level_reroll_ad)
	upgrade_list.add_child(reroll_button)

	var choices := _roll_upgrade_choices()
	for choice in choices:
		var current_level := int(upgrade_levels.get(choice["id"], 0))
		var button := Button.new()
		button.text = "%s  Lv.%d>%d\n%s" % [choice["title"], current_level, current_level + 1, choice["desc"]]
		button.custom_minimum_size = Vector2(560.0, 118.0)
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.add_theme_font_size_override("font_size", 21)
		_apply_ui_font(button)
		button.add_theme_stylebox_override("normal", _button_style(Color(0.08, 0.2, 0.28)))
		button.add_theme_stylebox_override("hover", _button_style(Color(0.11, 0.34, 0.42)))
		button.add_theme_stylebox_override("pressed", _button_style(Color(0.06, 0.14, 0.2)))
		button.set_meta("upgrade_id", choice["id"])
		button.pressed.connect(_on_upgrade_button_pressed.bind(button))
		upgrade_list.add_child(button)


func _roll_upgrade_choices() -> Array:
	var candidates: Array = []
	for upgrade in upgrade_defs:
		if int(upgrade_levels.get(upgrade["id"], 0)) < int(upgrade["max"]):
			candidates.append(upgrade)
	candidates.shuffle()
	return candidates.slice(0, mini(3, candidates.size()))


func _on_upgrade_button_pressed(button: Button) -> void:
	var upgrade_id := String(button.get_meta("upgrade_id"))
	_apply_upgrade(upgrade_id)
	upgrade_panel.visible = false
	run_paused = false
	_update_hud()


func _request_level_reroll_ad() -> void:
	if screen_state != ScreenState.RUN or not upgrade_panel.visible:
		return
	_request_ad_reward(AD_LEVEL_REROLL)


func _reroll_level_choices_from_ad() -> void:
	if screen_state != ScreenState.RUN or not upgrade_panel.visible:
		return
	_show_level_up()


func _apply_upgrade(upgrade_id: String) -> void:
	var next_level := int(upgrade_levels.get(upgrade_id, 0)) + 1
	upgrade_levels[upgrade_id] = next_level

	match upgrade_id:
		"bolt":
			bolt_level = next_level
			bolt_damage = 22.0 * pow(1.33, float(bolt_level - 1))
			bolt_cooldown = maxf(0.18, 0.52 * pow(0.92, float(bolt_level - 1)))
			bolt_pierce = int((bolt_level - 1) / 3)
		"pulse":
			pulse_level = next_level
			pulse_damage = 28.0 + pulse_level * 11.0
			pulse_radius = 120.0 + pulse_level * 22.0
			pulse_cooldown = maxf(2.4, 4.2 - pulse_level * 0.24)
			pulse_timer = minf(pulse_timer, 0.35)
		"drone":
			drone_level = next_level
			drone_damage = 12.0 + drone_level * 7.0
			drone_cooldown = maxf(0.42, 1.02 - drone_level * 0.08)
			_sync_drones()
		"magnet":
			magnet_radius = 145.0 + next_level * 56.0
		"speed":
			player.speed = 330.0 + next_level * 28.0
		"core":
			player.max_hp = 120.0 + next_level * 28.0
			player.heal(34.0 + next_level * 8.0)


func _sync_drones() -> void:
	var target_count := mini(3, 1 + int((drone_level - 1) / 2))
	while drones.size() < target_count:
		var drone = DroneScript.new()
		drone.setup(player, TAU * float(drones.size()) / float(target_count), drone_level)
		drones.append(drone)
		add_child(drone)
	for i in range(drones.size()):
		if is_instance_valid(drones[i]):
			drones[i].level = drone_level
			drones[i].orbit_radius = 74.0 + i * 10.0


func _update_hud() -> void:
	var remaining := maxf(0.0, RUN_SECONDS - elapsed_time)
	var minutes := int(remaining) / 60
	var seconds := int(remaining) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]
	level_label.text = "Lv.%d  XP %d/%d" % [level, xp, xp_to_next]
	kill_label.text = "정화 %d  HP %d/%d" % [kills, int(player.hp), int(player.max_hp)]
	hp_fill.size.x = 316.0 * clampf(player.hp / player.max_hp, 0.0, 1.0)
	xp_fill.size.x = 316.0 * clampf(float(xp) / float(xp_to_next), 0.0, 1.0)


func _show_banner(text: String) -> void:
	banner_label.text = text
	banner_label.visible = true
	banner_label.modulate.a = 1.0
	banner_timer = 2.2


func _update_banner(delta: float) -> void:
	if banner_timer <= 0.0:
		banner_label.visible = false
		return
	banner_timer -= delta
	banner_label.modulate.a = clampf(banner_timer, 0.0, 1.0)


func _finish_run(cleared: bool) -> void:
	run_finished = true
	run_paused = true
	last_run_cleared = cleared
	game_over_panel.visible = true
	last_run_reward = kills * 2 + level * 12
	if cleared:
		last_run_reward += 180
	run_reward_awarded = last_run_reward
	meta_currency += run_reward_awarded
	_update_lobby_ui()
	_update_game_over_panel()


func _update_game_over_panel() -> void:
	var result := "정화 완료" if last_run_cleared else "코어 붕괴"
	var minutes := int(elapsed_time) / 60
	var seconds := int(elapsed_time) % 60
	var bonus_text := ""
	if run_reward_doubled:
		bonus_text = "\n광고 2배 보상 적용 완료"
	game_over_label.text = "%s\n생존 시간 %02d:%02d\n정화 수 %d  도달 레벨 %d\n획득 파편 %d%s\n\n로비에서 강화 후 다시 도전하세요." % [result, minutes, seconds, kills, level, run_reward_awarded, bonus_text]
	if revive_ad_button != null:
		revive_ad_button.visible = not last_run_cleared and not revive_used
	if double_reward_ad_button != null:
		double_reward_ad_button.visible = not run_reward_doubled and last_run_reward > 0


func _double_run_reward_from_ad() -> void:
	if not run_finished or run_reward_doubled or last_run_reward <= 0:
		return
	run_reward_doubled = true
	run_reward_awarded += last_run_reward
	meta_currency += last_run_reward
	_update_lobby_ui()
	_update_game_over_panel()


func _revive_from_ad() -> void:
	if not run_finished or last_run_cleared or revive_used or player == null:
		return
	revive_used = true
	if run_reward_awarded > 0:
		meta_currency = maxi(0, meta_currency - run_reward_awarded)
	run_reward_awarded = 0
	last_run_reward = 0
	run_reward_doubled = false
	run_finished = false
	run_paused = false
	game_over_panel.visible = false
	player.hp = player.max_hp * 0.6
	_clear_enemies_near_player(320.0)
	_update_lobby_ui()
	_update_hud()
	_show_banner("광고 부활 완료")


func _clear_enemies_near_player(radius: float) -> void:
	var radius_squared := radius * radius
	for enemy in enemies:
		if is_instance_valid(enemy) and player.position.distance_squared_to(enemy.position) <= radius_squared:
			enemy.queue_free()


func _compact_entities() -> void:
	for i in range(enemies.size() - 1, -1, -1):
		if not is_instance_valid(enemies[i]) or enemies[i].is_queued_for_deletion():
			enemies.remove_at(i)
	for i in range(projectiles.size() - 1, -1, -1):
		if not is_instance_valid(projectiles[i]) or projectiles[i].is_queued_for_deletion():
			projectiles.remove_at(i)
	for i in range(gems.size() - 1, -1, -1):
		if not is_instance_valid(gems[i]) or gems[i].is_queued_for_deletion():
			gems.remove_at(i)
