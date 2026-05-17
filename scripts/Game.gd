extends Node2D

const PlayerScript := preload("res://scripts/Player.gd")
const EnemyScript := preload("res://scripts/Enemy.gd")
const ProjectileScript := preload("res://scripts/Projectile.gd")
const ExperienceGemScript := preload("res://scripts/ExperienceGem.gd")
const DroneScript := preload("res://scripts/Drone.gd")
const EffectRingScript := preload("res://scripts/EffectRing.gd")
const SpriteSheetEffectScript := preload("res://scripts/SpriteSheetEffect.gd")
const TouchStickScript := preload("res://scripts/TouchStick.gd")
const AdServiceScript := preload("res://scripts/AdService.gd")
const BillingServiceScript := preload("res://scripts/BillingService.gd")
const TextureLoaderScript := preload("res://scripts/TextureLoader.gd")
const UiTextureSkinScript := preload("res://scripts/UiTextureSkin.gd")
const KoreanFont := preload("res://assets/fonts/NotoSansCJKkr-Regular.otf")

const RUN_SECONDS := 300.0
const TOUCH_MAX_DISTANCE := 118.0
const MAX_ENEMIES := 240
const MAX_GEMS := 420
const CORE_PURIFY_SHEET := "res://assets/images/normalized/core_purify_sheet.png"
const CORE_ATTACK_SHEET := "res://assets/images/normalized/core_attack_sheet.png"
const CORE_ABSORB_SHEET := "res://assets/images/normalized/core_absorb_sheet.png"
const PROJECTILE_BOLT_SHEET := "res://assets/images/normalized/projectile_purify_bolt_sheet.png"
const PROJECTILE_COMET_MISSILE_SHEET := "res://assets/images/normalized/comet_missile_sheet.png"
const PROJECTILE_COMET_FRAGMENT_SHEET := "res://assets/images/normalized/comet_fragment_sheet.png"
const FX_COMET_EXPLOSION_SHEET := "res://assets/images/normalized/comet_explosion_sheet.png"
const WEAPON_PLASMA_RING_SHEET := "res://assets/images/normalized/weapon_plasma_ring_sheet.png"
const WEAPON_SPARK_CHAIN_SHEET := "res://assets/images/normalized/weapon_spark_chain_sheet.png"
const WEAPON_LASER_LANCE_SHEET := "res://assets/images/normalized/weapon_laser_lance_sheet.png"
const WEAPON_PURGE_BOMB_SHEET := "res://assets/images/normalized/weapon_purge_bomb_sheet.png"
const FX_PURGE_BOMB_EXPLOSION_SHEET := "res://assets/images/normalized/weapon_purge_bomb_explosion_sheet.png"
const EVOLUTION_PHOTON_STORM_SHEET := "res://assets/images/normalized/evolution_photon_storm_sheet.png"
const EVOLUTION_COMET_BATTERY_SHEET := "res://assets/images/normalized/evolution_comet_battery_sheet.png"
const EVOLUTION_SOLAR_HALO_SHEET := "res://assets/images/normalized/evolution_solar_halo_sheet.png"
const EVOLUTION_THUNDER_WEB_SHEET := "res://assets/images/normalized/evolution_thunder_web_sheet.png"
const EVOLUTION_RAIL_PRISM_SHEET := "res://assets/images/normalized/evolution_rail_prism_sheet.png"
const EVOLUTION_CLEANSER_NOVA_SHEET := "res://assets/images/normalized/evolution_cleanser_nova_sheet.png"
const DRONE_TARGETING_SHEET := "res://assets/images/normalized/drone_targeting_sheet.png"
const DRONE_CAPACITOR_SHEET := "res://assets/images/normalized/drone_capacitor_sheet.png"
const DRONE_SHIELD_SHEET := "res://assets/images/normalized/drone_shield_sheet.png"
const DRONE_MAGNET_SHEET := "res://assets/images/normalized/drone_magnet_sheet.png"
const DRONE_REPAIR_SHEET := "res://assets/images/normalized/drone_repair_sheet.png"
const AD_DAILY_BONUS := "daily_bonus"
const AD_FREE_CHEST := "free_chest"
const AD_LEVEL_REROLL := "level_reroll"
const AD_REVIVE := "revive"
const AD_RUN_REWARD_2X := "run_reward_2x"
const AD_TEMP_DRONE := "temp_drone"
const AD_RUN_END_5TH := "run_end_5th"
const BUTTON_SKIN_SOURCE_RECT := Rect2(0.0, 96.0, 1344.0, 436.0)
const PANEL_SKIN_SOURCE_RECT := Rect2(0.0, 276.0, 1416.0, 486.0)
const CORE_CARD_PREVIEW_SOURCE_RECT := Rect2(24.0, 16.0, 208.0, 206.0)
const BUTTON_SKIN_VISUAL_PADDING := Vector4(2.0, 2.0, 2.0, 2.0)
const BUTTON_SKIN_SLICE_MARGINS := Vector4(120.0, 70.0, 120.0, 70.0)
const PANEL_SKIN_SLICE_MARGINS := Vector4(160.0, 108.0, 160.0, 108.0)
const LOBBY_PANEL_SKIN_ALPHA := 0.38
const LOBBY_BUTTON_SKIN_ALPHA := 1.0
const LOBBY_PRIMARY_BUTTON_SKIN_ALPHA := 1.0
const UI_PANEL_BORDER_ALPHA := 0.42
const UI_FLAT_BUTTON_BORDER_ALPHA := 0.14
const UI_PROMINENT_BUTTON_BORDER_ALPHA := 0.34
const UI_CHOICE_BUTTON_BORDER_ALPHA := 0.38
const TOUCH_STICK_BASE_X := 116.0
const TOUCH_STICK_BOTTOM_MARGIN := 150.0
const TOUCH_STICK_START_RADIUS := 174.0
const SAVE_PATH := "user://core_survivor_save.json"
const ARENA_HALF_WIDTH := 1200.0
const ARENA_HALF_HEIGHT := 1700.0
const ARENA_EDGE_PADDING := 34.0
const ARENA_SPAWN_PADDING := 120.0
const WEAPON_UPGRADE_IDS := ["bolt", "missile", "pulse", "drone", "plasma", "chain", "laser", "bomb"]
const WEAPON_UNLOCK_COSTS := {
	"pulse": 2800,
	"plasma": 3000,
	"chain": 3300,
	"drone": 3600,
	"laser": 3900,
	"bomb": 4200
}
const STARTING_META_CURRENCY := 0
const DAILY_REWARD_BASE := 80
const MONTHLY_DAILY_REWARD_BONUS := 40
const DAILY_AD_REWARD_BASE := 70
const FREE_CHEST_REWARD_MIN := 70
const FREE_CHEST_REWARD_MAX := 130
const MONTHLY_AD_REWARD_BONUS := 30
const RUN_REWARD_PER_KILL := 0.5
const RUN_REWARD_PER_LEVEL := 10
const RUN_CLEAR_BONUS := 120

enum ScreenState { OPENING, LOBBY, RUN }

var rng := RandomNumberGenerator.new()
var ad_service
var billing_service
var title_key_art: Texture2D
var lobby_background: Texture2D
var stage1_background: Texture2D
var stage1_far_stars_layer: Texture2D
var stage1_asteroid_layer: Texture2D
var stage1_energy_ring_layer: Texture2D
var stage2_background: Texture2D
var stage2_far_heat_layer: Texture2D
var stage2_asteroid_layer: Texture2D
var stage2_solar_crack_layer: Texture2D
var core_purify_icon: Texture2D
var core_attack_icon: Texture2D
var core_absorb_icon: Texture2D
var core_purify_preview_sheet: Texture2D
var core_attack_preview_sheet: Texture2D
var core_absorb_preview_sheet: Texture2D
var reroll_icon: Texture2D
var ad_reward_badge: Texture2D
var daily_reward_badge: Texture2D
var ui_button_skin: Texture2D
var ui_panel_skin: Texture2D
var upgrade_icon_textures := {}
var product_icon_textures := {}
var drone_icon_textures := {}
var evolution_icon_textures := {}
var settings_icon_textures := {}
var screen_state := ScreenState.OPENING
var player
var camera: Camera2D
var hud_layer: CanvasLayer
var hud_root: Control
var opening_screen: Control
var lobby_screen: Control
var lobby_detail_overlay: Control
var lobby_detail_title_label: Label
var lobby_detail_list: VBoxContainer
var run_hud: Control
var hp_fill: ColorRect
var xp_fill: ColorRect
var timer_label: Label
var level_label: Label
var kill_label: Label
var banner_label: Label
var upgrade_panel: PanelContainer
var upgrade_list: VBoxContainer
var game_over_backdrop: ColorRect
var game_over_panel: PanelContainer
var game_over_label: Label
var revive_ad_button: Button
var double_reward_ad_button: Button
var touch_stick
var ui_font
var lobby_core_summary_label: Label
var lobby_status_label: Label
var lobby_resource_label: Label
var lobby_upgrade_label: Label
var core_card_buttons := {}
var core_card_panels := {}
var core_card_title_labels := {}
var core_card_desc_labels := {}
var core_card_preview_nodes := {}
var core_badge_panels := {}
var selected_core_id := "purify"
var meta_currency := STARTING_META_CURRENCY
var daily_reward_claimed := false
var daily_ad_bonus_claimed := false
var free_chest_claimed := false
var daily_reward_date := ""
var daily_ad_bonus_date := ""
var free_chest_date := ""
var temp_drone_ready := false
var premium_core_skin_unlocked := false
var special_drone_unlocked := false
var monthly_pass_active := false
var sound_enabled := true
var vibration_enabled := true
var active_lobby_detail := ""
var pending_ad_placement := ""
var run_end_interstitial_counter := 0
var pending_run_end_interstitial := false
var purchase_reward_claimed := {}
var weapon_unlocks := {
	"bolt": true,
	"missile": true,
	"pulse": false,
	"drone": false,
	"plasma": false,
	"chain": false,
	"laser": false,
	"bomb": false
}
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
var support_drones: Array = []

var elapsed_time := 0.0
var spawn_timer := 0.0
var elite_timer := 35.0
var boss_spawned := false
var current_stage := 1
var stage2_started := false
var stage2_boss_spawned := false
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
var missile_level := 0
var missile_damage := 0.0
var missile_cooldown := 3.6
var missile_timer := 0.0
var missile_blast_radius := 0.0
var missile_fragments := 0
var pulse_level := 0
var pulse_damage := 0.0
var pulse_radius := 0.0
var pulse_cooldown := 4.2
var pulse_timer := 0.0
var drone_level := 0
var drone_damage := 0.0
var drone_cooldown := 0.95
var drone_timer := 0.0
var plasma_level := 0
var plasma_damage := 0.0
var plasma_radius := 0.0
var plasma_cooldown := 0.78
var plasma_timer := 0.0
var chain_level := 0
var chain_damage := 0.0
var chain_cooldown := 1.25
var chain_timer := 0.0
var chain_jumps := 0
var laser_level := 0
var laser_damage := 0.0
var laser_cooldown := 2.0
var laser_timer := 0.0
var bomb_level := 0
var bomb_damage := 0.0
var bomb_cooldown := 3.35
var bomb_timer := 0.0
var bomb_radius := 0.0
var targeting_drone_level := 0
var capacitor_drone_level := 0
var shield_drone_level := 0
var magnet_drone_level := 0
var repair_drone_level := 0
var shield_hp := 0.0
var shield_max_hp := 0.0
var shield_recharge_timer := 0.0
var repair_timer := 0.0
var photon_storm_level := 0
var comet_battery_level := 0
var solar_halo_level := 0
var thunder_web_level := 0
var rail_prism_level := 0
var cleanser_nova_level := 0
var photon_storm_timer := 0.0
var comet_battery_timer := 0.0
var solar_halo_timer := 0.0
var thunder_web_timer := 0.0
var rail_prism_timer := 0.0
var cleanser_nova_timer := 0.0
var magnet_radius := 145.0
var upgrade_levels := {}

var enemy_defs := {}
var upgrade_defs: Array = []


func _ready() -> void:
	rng.randomize()
	_load_runtime_textures()
	_load_game()
	_create_ad_service()
	_create_billing_service()
	_build_data()
	_create_ui()
	_show_opening_screen()


func _load_runtime_textures() -> void:
	title_key_art = TextureLoaderScript.load_texture("res://assets/images/title_key_art.png")
	lobby_background = TextureLoaderScript.load_texture("res://assets/images/lobby_background_v2.png")
	stage1_background = TextureLoaderScript.load_texture("res://assets/images/stage1_background.png")
	stage1_far_stars_layer = TextureLoaderScript.load_texture("res://assets/images/stage1_far_stars_layer.png")
	stage1_asteroid_layer = TextureLoaderScript.load_texture("res://assets/images/stage1_asteroid_layer.png")
	stage1_energy_ring_layer = TextureLoaderScript.load_texture("res://assets/images/stage1_energy_ring_layer.png")
	stage2_background = TextureLoaderScript.load_texture("res://assets/images/stage2_background.png")
	stage2_far_heat_layer = TextureLoaderScript.load_texture("res://assets/images/stage2_far_heat_layer.png")
	stage2_asteroid_layer = TextureLoaderScript.load_texture("res://assets/images/stage2_asteroid_layer.png")
	stage2_solar_crack_layer = TextureLoaderScript.load_texture("res://assets/images/stage2_solar_crack_layer.png")
	core_purify_icon = TextureLoaderScript.load_texture("res://assets/images/core_purify_icon.png")
	core_attack_icon = TextureLoaderScript.load_texture("res://assets/images/core_attack_icon.png")
	core_absorb_icon = TextureLoaderScript.load_texture("res://assets/images/core_absorb_icon.png")
	core_purify_preview_sheet = TextureLoaderScript.load_texture(CORE_PURIFY_SHEET)
	core_attack_preview_sheet = TextureLoaderScript.load_texture(CORE_ATTACK_SHEET)
	core_absorb_preview_sheet = TextureLoaderScript.load_texture(CORE_ABSORB_SHEET)
	reroll_icon = TextureLoaderScript.load_texture("res://assets/images/reroll_button_icon.png")
	ad_reward_badge = TextureLoaderScript.load_texture("res://assets/images/ui_ad_reward_badge_v2.png")
	daily_reward_badge = TextureLoaderScript.load_texture("res://assets/images/ui_daily_reward_badge.png")
	ui_button_skin = TextureLoaderScript.load_texture("res://assets/images/ui_button_teal.png")
	ui_panel_skin = TextureLoaderScript.load_texture("res://assets/images/ui_panel_cosmic.png")
	upgrade_icon_textures = {
		"bolt": TextureLoaderScript.load_texture("res://assets/images/upgrade_bolt_icon.png"),
		"pulse": TextureLoaderScript.load_texture("res://assets/images/upgrade_pulse_icon.png"),
		"drone": TextureLoaderScript.load_texture("res://assets/images/upgrade_drone_icon.png"),
		"magnet": TextureLoaderScript.load_texture("res://assets/images/upgrade_magnet_icon.png"),
		"speed": TextureLoaderScript.load_texture("res://assets/images/upgrade_speed_icon.png"),
		"core": TextureLoaderScript.load_texture("res://assets/images/upgrade_core_icon.png"),
		"missile": TextureLoaderScript.load_texture("res://assets/images/upgrade_missile_icon.png"),
		"plasma": TextureLoaderScript.load_texture("res://assets/images/upgrade_plasma_icon.png"),
		"chain": TextureLoaderScript.load_texture("res://assets/images/upgrade_chain_icon.png"),
		"laser": TextureLoaderScript.load_texture("res://assets/images/upgrade_laser_icon.png"),
		"bomb": TextureLoaderScript.load_texture("res://assets/images/upgrade_bomb_icon.png")
	}
	product_icon_textures = {
		BillingServiceScript.PRODUCT_REMOVE_ADS: TextureLoaderScript.load_texture("res://assets/images/shop_remove_ads_icon.png"),
		BillingServiceScript.PRODUCT_MONTHLY_SUPPLY_PASS: TextureLoaderScript.load_texture("res://assets/images/shop_monthly_pass_icon.png")
	}
	drone_icon_textures = {
		"purify": upgrade_icon_textures.get("drone", null),
		"targeting": TextureLoaderScript.load_texture("res://assets/images/drone_targeting_icon.png"),
		"capacitor": TextureLoaderScript.load_texture("res://assets/images/drone_capacitor_icon.png"),
		"shield": TextureLoaderScript.load_texture("res://assets/images/drone_shield_icon.png"),
		"magnet": TextureLoaderScript.load_texture("res://assets/images/drone_magnet_icon.png"),
		"repair": TextureLoaderScript.load_texture("res://assets/images/drone_repair_icon.png")
	}
	evolution_icon_textures = {
		"photon_storm": TextureLoaderScript.load_texture("res://assets/images/evolution_photon_storm_icon.png"),
		"comet_battery": TextureLoaderScript.load_texture("res://assets/images/evolution_comet_battery_icon.png"),
		"solar_halo": TextureLoaderScript.load_texture("res://assets/images/evolution_solar_halo_icon.png"),
		"thunder_web": TextureLoaderScript.load_texture("res://assets/images/evolution_thunder_web_icon.png"),
		"rail_prism": TextureLoaderScript.load_texture("res://assets/images/evolution_rail_prism_icon.png"),
		"cleanser_nova": TextureLoaderScript.load_texture("res://assets/images/evolution_cleanser_nova_icon.png")
	}
	settings_icon_textures = {
		"sound": TextureLoaderScript.load_texture("res://assets/images/settings_sound_icon.png"),
		"haptic": TextureLoaderScript.load_texture("res://assets/images/settings_haptic_icon.png")
	}


func _load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var data = JSON.parse_string(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		return
	meta_currency = int(data.get("meta_currency", meta_currency))
	selected_core_id = str(data.get("selected_core_id", selected_core_id))
	daily_reward_claimed = bool(data.get("daily_reward_claimed", daily_reward_claimed))
	daily_ad_bonus_claimed = bool(data.get("daily_ad_bonus_claimed", daily_ad_bonus_claimed))
	free_chest_claimed = bool(data.get("free_chest_claimed", free_chest_claimed))
	daily_reward_date = str(data.get("daily_reward_date", daily_reward_date))
	daily_ad_bonus_date = str(data.get("daily_ad_bonus_date", daily_ad_bonus_date))
	free_chest_date = str(data.get("free_chest_date", free_chest_date))
	temp_drone_ready = bool(data.get("temp_drone_ready", temp_drone_ready))
	run_end_interstitial_counter = int(data.get("run_end_interstitial_counter", run_end_interstitial_counter))
	premium_core_skin_unlocked = bool(data.get("premium_core_skin_unlocked", premium_core_skin_unlocked))
	special_drone_unlocked = bool(data.get("special_drone_unlocked", special_drone_unlocked))
	monthly_pass_active = bool(data.get("monthly_pass_active", monthly_pass_active))
	sound_enabled = bool(data.get("sound_enabled", sound_enabled))
	vibration_enabled = bool(data.get("vibration_enabled", vibration_enabled))
	if typeof(data.get("permanent_upgrades", {})) == TYPE_DICTIONARY:
		var loaded_upgrades: Dictionary = data["permanent_upgrades"]
		for key in permanent_upgrades.keys():
			permanent_upgrades[key] = int(loaded_upgrades.get(key, permanent_upgrades[key]))
	if typeof(data.get("purchase_reward_claimed", {})) == TYPE_DICTIONARY:
		purchase_reward_claimed = data["purchase_reward_claimed"]
	if typeof(data.get("weapon_unlocks", {})) == TYPE_DICTIONARY:
		var loaded_weapon_unlocks: Dictionary = data["weapon_unlocks"]
		for key in weapon_unlocks.keys():
			weapon_unlocks[key] = bool(loaded_weapon_unlocks.get(key, weapon_unlocks[key]))
	weapon_unlocks["bolt"] = true
	weapon_unlocks["missile"] = true
	_refresh_daily_reward_state()


func _save_game() -> void:
	var data := {
		"meta_currency": meta_currency,
		"selected_core_id": selected_core_id,
		"daily_reward_claimed": daily_reward_claimed,
		"daily_ad_bonus_claimed": daily_ad_bonus_claimed,
		"free_chest_claimed": free_chest_claimed,
		"daily_reward_date": daily_reward_date,
		"daily_ad_bonus_date": daily_ad_bonus_date,
		"free_chest_date": free_chest_date,
		"temp_drone_ready": temp_drone_ready,
		"run_end_interstitial_counter": run_end_interstitial_counter,
		"premium_core_skin_unlocked": premium_core_skin_unlocked,
		"special_drone_unlocked": special_drone_unlocked,
		"monthly_pass_active": monthly_pass_active,
		"sound_enabled": sound_enabled,
		"vibration_enabled": vibration_enabled,
		"permanent_upgrades": permanent_upgrades,
		"purchase_reward_claimed": purchase_reward_claimed,
		"weapon_unlocks": weapon_unlocks
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(data))


func _current_date_key() -> String:
	var date := Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d" % [int(date["year"]), int(date["month"]), int(date["day"])]


func _refresh_daily_reward_state() -> void:
	var today := _current_date_key()
	if daily_reward_date != today:
		daily_reward_claimed = false
	if daily_ad_bonus_date != today:
		daily_ad_bonus_claimed = false
	if free_chest_date != today:
		free_chest_claimed = false


func _process(delta: float) -> void:
	menu_time += delta

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
	_clamp_player_to_arena()
	_update_camera_position()

	_update_spawns(delta)
	_update_enemies(delta)
	_update_weapons(delta)
	_update_projectiles()
	_update_gems(delta)
	_update_player_contacts()
	_clamp_player_to_arena()
	_update_drones(delta)
	_update_camera_position()
	_compact_entities()
	_update_leveling()
	_update_hud()
	_update_banner(delta)

	if player.hp <= 0.0:
		_finish_run(false)
	elif elapsed_time >= RUN_SECONDS:
		_finish_run(true)

	queue_redraw()


func _input(event: InputEvent) -> void:
	if screen_state != ScreenState.RUN or run_paused or run_finished:
		return

	if event is InputEventScreenTouch:
		if event.pressed and touch_index == -1 and _is_touch_stick_position(event.position):
			touch_index = event.index
			touch_anchor = _touch_stick_base()
			touch_current = event.position
		elif not event.pressed and event.index == touch_index:
			touch_index = -1
			touch_vector = Vector2.ZERO
	elif event is InputEventScreenDrag and event.index == touch_index:
		touch_current = event.position
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and _is_touch_stick_position(event.position):
				mouse_stick_active = true
				touch_anchor = _touch_stick_base()
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
	if screen_state == ScreenState.RUN and player != null:
		focus = _camera_focus_position()
	elif player != null:
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

	var background_texture: Texture2D = stage2_background if current_stage >= 2 and screen_state == ScreenState.RUN else stage1_background
	var overlay_alpha := 0.18
	if screen_state == ScreenState.OPENING:
		background_texture = title_key_art
		overlay_alpha = 0.12
	elif screen_state == ScreenState.LOBBY:
		background_texture = lobby_background
		overlay_alpha = 0.28
	_draw_cover_texture(background_texture, bg_rect)
	if screen_state == ScreenState.RUN:
		if current_stage >= 2:
			_draw_parallax_texture(stage2_far_heat_layer, bg_rect, focus, 0.025, Color(1.0, 0.82, 0.56, 0.64))
			_draw_parallax_texture(stage2_asteroid_layer, bg_rect, focus, 0.055, Color(1.0, 0.78, 0.54, 0.42))
			_draw_parallax_texture(stage2_solar_crack_layer, bg_rect, focus, 0.095, Color(1.0, 0.46, 0.22, 0.36))
		else:
			_draw_parallax_texture(stage1_far_stars_layer, bg_rect, focus, 0.025, Color(1.0, 1.0, 1.0, 0.74))
			_draw_parallax_texture(stage1_asteroid_layer, bg_rect, focus, 0.055, Color(1.0, 1.0, 1.0, 0.46))
			_draw_parallax_texture(stage1_energy_ring_layer, bg_rect, focus, 0.095, Color(0.72, 1.0, 1.0, 0.42))
	draw_rect(bg_rect, Color(0.01, 0.018, 0.04, overlay_alpha), true)

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

	if screen_state == ScreenState.RUN:
		_draw_arena_boundary(bg_rect)
	elif screen_state == ScreenState.OPENING:
		_draw_opening_art()
	elif screen_state == ScreenState.LOBBY:
		_draw_lobby_art()


func _draw_arena_boundary(visible_rect: Rect2) -> void:
	var arena := _arena_rect()
	var outer_alpha := 0.46
	var top_rect := Rect2(visible_rect.position, Vector2(visible_rect.size.x, maxf(0.0, arena.position.y - visible_rect.position.y)))
	var bottom_y := arena.position.y + arena.size.y
	var bottom_rect := Rect2(Vector2(visible_rect.position.x, bottom_y), Vector2(visible_rect.size.x, maxf(0.0, visible_rect.end.y - bottom_y)))
	var left_rect := Rect2(Vector2(visible_rect.position.x, arena.position.y), Vector2(maxf(0.0, arena.position.x - visible_rect.position.x), arena.size.y))
	var right_x := arena.position.x + arena.size.x
	var right_rect := Rect2(Vector2(right_x, arena.position.y), Vector2(maxf(0.0, visible_rect.end.x - right_x), arena.size.y))
	for rect in [top_rect, bottom_rect, left_rect, right_rect]:
		if rect.size.x > 0.0 and rect.size.y > 0.0:
			draw_rect(rect, Color(0.0, 0.0, 0.0, outer_alpha), true)

	for width in [28.0, 16.0, 7.0]:
		draw_rect(arena, Color(0.16, 0.92, 1.0, 0.08 + width * 0.006), false, width)
	draw_rect(arena, Color(0.82, 1.0, 1.0, 0.9), false, 2.0)

	var tick_spacing := 240.0
	var x := arena.position.x
	while x <= arena.end.x:
		draw_line(Vector2(x, arena.position.y), Vector2(x + 48.0, arena.position.y + 48.0), Color(0.32, 0.95, 1.0, 0.28), 2.0)
		draw_line(Vector2(x, arena.end.y), Vector2(x + 48.0, arena.end.y - 48.0), Color(0.32, 0.95, 1.0, 0.28), 2.0)
		x += tick_spacing
	var y := arena.position.y
	while y <= arena.end.y:
		draw_line(Vector2(arena.position.x, y), Vector2(arena.position.x + 48.0, y + 48.0), Color(0.32, 0.95, 1.0, 0.28), 2.0)
		draw_line(Vector2(arena.end.x, y), Vector2(arena.end.x - 48.0, y + 48.0), Color(0.32, 0.95, 1.0, 0.28), 2.0)
		y += tick_spacing


func _draw_cover_texture(texture: Texture2D, target_rect: Rect2, modulate: Color = Color.WHITE) -> void:
	if texture == null:
		draw_rect(target_rect, Color(0.035, 0.043, 0.08), true)
		return
	var texture_size := Vector2(texture.get_width(), texture.get_height())
	var target_ratio := target_rect.size.x / target_rect.size.y
	var texture_ratio := texture_size.x / texture_size.y
	var source_rect := Rect2(Vector2.ZERO, texture_size)
	if texture_ratio > target_ratio:
		var source_width := texture_size.y * target_ratio
		source_rect.position.x = (texture_size.x - source_width) * 0.5
		source_rect.size.x = source_width
	else:
		var source_height := texture_size.x / target_ratio
		source_rect.position.y = (texture_size.y - source_height) * 0.5
		source_rect.size.y = source_height
	draw_texture_rect_region(texture, target_rect, source_rect, modulate)


func _draw_parallax_texture(texture: Texture2D, target_rect: Rect2, focus: Vector2, factor: float, modulate: Color) -> void:
	if texture == null:
		return
	var tile_size := target_rect.size * 1.08
	var offset := Vector2(fposmod(focus.x * factor, tile_size.x), fposmod(focus.y * factor, tile_size.y))
	var start := target_rect.position - tile_size - offset
	for ix in range(4):
		for iy in range(4):
			var tile_rect := Rect2(start + Vector2(tile_size.x * ix, tile_size.y * iy), tile_size)
			_draw_cover_texture(texture, tile_rect, modulate)


func _draw_opening_art() -> void:
	for i in range(10):
		var angle := menu_time * 0.28 + TAU * float(i) / 10.0
		var p := Vector2(360.0, 540.0) + Vector2(cos(angle), sin(angle)) * (230.0 + sin(menu_time + i) * 10.0)
		draw_circle(p, 4.0 + float(i % 3), Color(0.48, 0.9, 1.0, 0.45))


func _draw_lobby_art() -> void:
	var accent := Color(0.18, 0.94, 0.72)
	if selected_core_id == "attack":
		accent = Color(1.0, 0.42, 0.2)
	elif selected_core_id == "absorb":
		accent = Color(0.48, 0.34, 0.96)
	for i in range(12):
		var angle := menu_time * 0.32 + TAU * float(i) / 12.0
		var p := Vector2(360.0, 760.0) + Vector2(cos(angle), sin(angle)) * (310.0 + sin(menu_time + i) * 10.0)
		draw_circle(p, 2.6 + float(i % 3), Color(accent.r, accent.g, accent.b, 0.24))


func _selected_core_icon_texture() -> Texture2D:
	match selected_core_id:
		"attack":
			return core_attack_icon
		"absorb":
			return core_absorb_icon
		_:
			return core_purify_icon


func _core_icon_texture(core_id: String) -> Texture2D:
	match core_id:
		"attack":
			return core_attack_icon
		"absorb":
			return core_absorb_icon
		_:
			return core_purify_icon


func _core_preview_texture(core_id: String) -> Texture2D:
	match core_id:
		"attack":
			return core_attack_preview_sheet
		"absorb":
			return core_absorb_preview_sheet
		_:
			return core_purify_preview_sheet


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
		"drifter": {"id": "drifter", "name": "오염 드리프터", "type": "normal", "hp": 22.0, "speed": 86.0, "damage": 9.0, "xp": 2, "radius": 20.0, "color": Color(0.9, 0.2, 0.46), "sprite_path": "res://assets/images/normalized/enemy_drifter_sheet.png", "sprite_scale": 0.46},
		"chaser": {"id": "chaser", "name": "돌진 먼지", "type": "normal", "hp": 18.0, "speed": 130.0, "damage": 8.0, "xp": 2, "radius": 17.0, "color": Color(1.0, 0.42, 0.22), "sprite_path": "res://assets/images/normalized/enemy_chaser_sheet.png", "sprite_scale": 0.43},
		"bulwark": {"id": "bulwark", "name": "오염 덩어리", "type": "normal", "hp": 56.0, "speed": 60.0, "damage": 15.0, "xp": 5, "radius": 27.0, "color": Color(0.55, 0.35, 0.95), "sprite_path": "res://assets/images/normalized/enemy_bulwark_sheet.png", "sprite_scale": 0.56},
		"splitter": {"id": "splitter", "name": "분열 찌꺼기", "type": "normal", "hp": 34.0, "speed": 102.0, "damage": 10.0, "xp": 4, "radius": 22.0, "color": Color(0.1, 0.78, 0.95), "sprite_path": "res://assets/images/normalized/enemy_splitter_sheet.png", "sprite_scale": 0.5},
		"elite_guard": {"id": "elite_guard", "name": "엘리트 가드", "type": "elite", "hp": 180.0, "speed": 74.0, "damage": 22.0, "xp": 18, "radius": 35.0, "color": Color(1.0, 0.82, 0.18), "sprite_path": "res://assets/images/normalized/enemy_elite_guard_sheet.png", "sprite_scale": 0.64},
		"boss_warden": {"id": "boss_warden", "name": "정화 방해자", "type": "boss", "hp": 1100.0, "speed": 46.0, "damage": 32.0, "xp": 90, "radius": 58.0, "color": Color(1.0, 0.12, 0.28), "sprite_path": "res://assets/images/normalized/enemy_boss_warden_sheet.png", "sprite_scale": 1.0, "sprite_frame_sequence": [0, 1, 2, 3]},
		"stage2_solar_imp": {"id": "stage2_solar_imp", "name": "태양 임프", "type": "normal", "hp": 42.0, "speed": 112.0, "damage": 14.0, "xp": 5, "radius": 22.0, "color": Color(1.0, 0.46, 0.16), "sprite_path": "res://assets/images/normalized/enemy_stage2_solar_imp_sheet.png", "sprite_columns": 6, "sprite_rows": 4, "sprite_scale": 0.5},
		"stage2_flare_chaser": {"id": "stage2_flare_chaser", "name": "플레어 체이서", "type": "normal", "hp": 34.0, "speed": 148.0, "damage": 13.0, "xp": 5, "radius": 21.0, "color": Color(1.0, 0.3, 0.12), "sprite_path": "res://assets/images/normalized/enemy_stage2_flare_chaser_sheet.png", "sprite_columns": 6, "sprite_rows": 4, "sprite_scale": 0.5},
		"stage2_ember_tank": {"id": "stage2_ember_tank", "name": "엠버 탱크", "type": "normal", "hp": 92.0, "speed": 58.0, "damage": 22.0, "xp": 10, "radius": 33.0, "color": Color(0.9, 0.28, 0.16), "sprite_path": "res://assets/images/normalized/enemy_stage2_ember_tank_sheet.png", "sprite_columns": 6, "sprite_rows": 4, "sprite_scale": 0.65},
		"stage2_splitter": {"id": "stage2_splitter", "name": "태양 분열체", "type": "normal", "hp": 58.0, "speed": 98.0, "damage": 16.0, "xp": 8, "radius": 27.0, "color": Color(1.0, 0.58, 0.18), "sprite_path": "res://assets/images/normalized/enemy_stage2_splitter_sheet.png", "sprite_columns": 6, "sprite_rows": 4, "sprite_scale": 0.58},
		"stage2_elite_guard": {"id": "stage2_elite_guard", "name": "솔라 가드", "type": "elite", "hp": 300.0, "speed": 70.0, "damage": 30.0, "xp": 28, "radius": 40.0, "color": Color(1.0, 0.72, 0.18), "sprite_path": "res://assets/images/normalized/enemy_stage2_elite_guard_sheet.png", "sprite_columns": 6, "sprite_rows": 4, "sprite_scale": 0.72},
		"stage2_boss_solar_devourer": {"id": "stage2_boss_solar_devourer", "name": "솔라 디바우러", "type": "boss", "hp": 1900.0, "speed": 38.0, "damage": 42.0, "xp": 140, "radius": 68.0, "color": Color(1.0, 0.38, 0.12), "sprite_path": "res://assets/images/normalized/enemy_stage2_boss_solar_devourer_sheet.png", "sprite_columns": 6, "sprite_rows": 4, "sprite_scale": 1.06, "sprite_frame_sequence": [0, 1, 2, 3, 4, 5]}
	}

	upgrade_defs = [
		{"id": "bolt", "title": "정화 볼트", "max": 8, "desc": "자동 탄환 피해와 발사 속도 증가"},
		{"id": "missile", "title": "코멧 미사일", "max": 6, "desc": "느리지만 강한 추적 미사일과 광역 폭발"},
		{"id": "pulse", "title": "펄스 웨이브", "max": 6, "desc": "주기적으로 주변 오염체를 밀어내며 피해"},
		{"id": "drone", "title": "정화 드론", "max": 6, "desc": "궤도 드론이 가까운 적을 보조 사격"},
		{"id": "plasma", "title": "플라즈마 링", "max": 6, "desc": "주변을 회전하는 근접 방어 피해"},
		{"id": "chain", "title": "스파크 체인", "max": 6, "desc": "적 사이를 연쇄하는 전기 공격"},
		{"id": "laser", "title": "레이저 랜스", "max": 6, "desc": "긴 직선 관통 빔으로 보스와 라인을 타격"},
		{"id": "bomb", "title": "퍼지 밤", "max": 6, "desc": "지연 폭발로 넓은 정화 지대를 생성"},
		{"id": "targeting_drone", "title": "타겟팅 드론", "max": 2, "desc": "보스 우선 조준과 관통 화력을 보조"},
		{"id": "capacitor_drone", "title": "캐패시터 드론", "max": 2, "desc": "공격 속도와 전기 피해를 보조"},
		{"id": "shield_drone", "title": "실드 드론", "max": 2, "desc": "피해를 흡수하는 보호막 충전"},
		{"id": "magnet_drone", "title": "마그넷 드론", "max": 2, "desc": "오염 에너지 흡수 범위 확장"},
		{"id": "repair_drone", "title": "리페어 드론", "max": 2, "desc": "전투 중 천천히 체력 회복"},
		{"id": "photon_storm", "title": "포톤 스톰", "max": 1, "desc": "전방 다중 관통탄으로 라인과 보스를 압박"},
		{"id": "comet_battery", "title": "코멧 배터리", "max": 1, "desc": "플레이어 주변 우선 낙하와 흡수 보조"},
		{"id": "solar_halo", "title": "솔라 헤일로", "max": 1, "desc": "이중 회전 링으로 근접 방어 강화"},
		{"id": "thunder_web", "title": "썬더 웹", "max": 1, "desc": "연쇄 번개의 마지막 타격이 폭발"},
		{"id": "rail_prism", "title": "레일 프리즘", "max": 1, "desc": "보스 우선 장거리 관통 레이저"},
		{"id": "cleanser_nova", "title": "클렌저 노바", "max": 1, "desc": "대형 폭발 후 정화 지대를 남김"},
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
	ad_service.interstitial_loaded.connect(_on_interstitial_loaded)
	ad_service.interstitial_failed.connect(_on_interstitial_failed)
	ad_service.interstitial_closed.connect(_on_interstitial_closed)
	ad_service.initialize()


func _create_billing_service() -> void:
	billing_service = BillingServiceScript.new()
	add_child(billing_service)
	billing_service.billing_ready.connect(_on_billing_ready)
	billing_service.billing_error.connect(_on_billing_error)
	billing_service.product_loaded.connect(_on_billing_product_loaded)
	billing_service.product_unavailable.connect(_on_billing_product_unavailable)
	billing_service.purchase_completed.connect(_on_billing_purchase_completed)
	billing_service.purchase_pending.connect(_on_billing_purchase_pending)
	billing_service.purchase_cancelled.connect(_on_billing_purchase_cancelled)
	billing_service.purchase_failed.connect(_on_billing_purchase_failed)
	billing_service.purchase_restored.connect(_on_billing_purchase_restored)
	billing_service.initialize()


func _create_world() -> void:
	player = PlayerScript.new()
	player.position = Vector2.ZERO
	player.z_index = 20
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
	if game_over_backdrop != null:
		game_over_backdrop.visible = false
	if game_over_panel != null:
		game_over_panel.visible = false
	_clear_run_entities()
	_update_lobby_ui()
	_show_lobby_notice("코어를 선택하고 영구 강화를 확인한 뒤 정화 런을 시작하세요.")
	queue_redraw()


func _start_run() -> void:
	var use_temp_drone := temp_drone_ready
	temp_drone_ready = false
	_save_game()
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
	game_over_backdrop.visible = false
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
		if child != hud_layer and child != ad_service and child != billing_service:
			child.queue_free()
	enemies.clear()
	projectiles.clear()
	gems.clear()
	drones.clear()
	support_drones.clear()
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
	current_stage = 1
	stage2_started = false
	stage2_boss_spawned = false
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
	_set_missile_level(1)
	missile_timer = 1.2
	pulse_level = 0
	pulse_damage = 0.0
	pulse_radius = 0.0
	pulse_cooldown = 4.2
	pulse_timer = 0.0
	drone_level = 0
	drone_damage = 0.0
	drone_cooldown = 0.95
	drone_timer = 0.0
	plasma_level = 0
	plasma_damage = 0.0
	plasma_radius = 0.0
	plasma_cooldown = 0.78
	plasma_timer = 0.0
	chain_level = 0
	chain_damage = 0.0
	chain_cooldown = 1.25
	chain_timer = 0.0
	chain_jumps = 0
	laser_level = 0
	laser_damage = 0.0
	laser_cooldown = 2.0
	laser_timer = 0.0
	bomb_level = 0
	bomb_damage = 0.0
	bomb_cooldown = 3.35
	bomb_timer = 0.0
	bomb_radius = 0.0
	targeting_drone_level = 0
	capacitor_drone_level = 0
	shield_drone_level = 0
	magnet_drone_level = 0
	repair_drone_level = 0
	shield_hp = 0.0
	shield_max_hp = 0.0
	shield_recharge_timer = 0.0
	repair_timer = 0.0
	photon_storm_level = 0
	comet_battery_level = 0
	solar_halo_level = 0
	thunder_web_level = 0
	rail_prism_level = 0
	cleanser_nova_level = 0
	photon_storm_timer = 0.6
	comet_battery_timer = 1.2
	solar_halo_timer = 0.4
	thunder_web_timer = 1.0
	rail_prism_timer = 1.5
	cleanser_nova_timer = 2.2
	magnet_radius = 145.0
	upgrade_levels.clear()
	upgrade_levels["missile"] = 1


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
			player.set_sprite_sheet(CORE_PURIFY_SHEET)
		"attack":
			bolt_damage *= 1.15
			bolt_cooldown *= 0.94
			player.set_core_palette(Color(1.0, 0.38, 0.16), Color(1.0, 0.42, 0.12, 0.18))
			player.set_sprite_sheet(CORE_ATTACK_SHEET)
		"absorb":
			magnet_radius += 45.0
			player.set_core_palette(Color(0.48, 0.34, 0.96), Color(0.46, 0.34, 1.0, 0.18))
			player.set_sprite_sheet(CORE_ABSORB_SHEET)

	if premium_core_skin_unlocked or _is_product_owned(BillingServiceScript.PRODUCT_PREMIUM_CORE_SKIN_PACK):
		player.core_aura_color = Color(1.0, 0.82, 0.24, 0.28)
	if bool(weapon_unlocks.get("drone", false)):
		_activate_unlocked_drone()
	if special_drone_unlocked or _is_product_owned(BillingServiceScript.PRODUCT_SPECIAL_DRONE_PACK):
		_activate_pack_drone()

	player.hp = player.max_hp
	player.queue_redraw()


func _activate_temp_drone() -> void:
	drone_level = max(1, drone_level)
	drone_damage = maxf(20.0, drone_damage)
	drone_cooldown = minf(0.86, drone_cooldown)
	upgrade_levels["drone"] = maxi(1, int(upgrade_levels.get("drone", 0)))
	_sync_drones()


func _activate_unlocked_drone() -> void:
	drone_level = max(1, drone_level)
	drone_damage = maxf(18.0, drone_damage)
	drone_cooldown = minf(0.9, drone_cooldown)
	upgrade_levels["drone"] = maxi(1, int(upgrade_levels.get("drone", 0)))
	_sync_drones()


func _activate_pack_drone() -> void:
	drone_level = max(1, drone_level)
	drone_damage = maxf(24.0, drone_damage)
	drone_cooldown = minf(0.82, drone_cooldown)
	upgrade_levels["drone"] = maxi(1, int(upgrade_levels.get("drone", 0)))
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
	touch_stick.mouse_filter = Control.MOUSE_FILTER_IGNORE
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

	lobby_core_summary_label = _make_label(lobby_screen, Vector2(42.0, 174.0), 16, Color(0.86, 1.0, 0.96))
	lobby_core_summary_label.size = Vector2(636.0, 26.0)
	lobby_core_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

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
	daily_button.add_theme_font_size_override("font_size", 18)
	daily_button.pressed.connect(_claim_daily_reward)

	var upgrade_panel_lobby := _make_panel(lobby_screen, Vector2(376.0, 396.0), Vector2(318.0, 258.0), Color(0.04, 0.07, 0.1, 0.88), Color(1.0, 0.78, 0.25, 0.45))
	var upgrade_title := _make_label(upgrade_panel_lobby, Vector2(18.0, 16.0), 21, Color(1.0, 0.9, 0.54))
	upgrade_title.text = "영구 강화"
	lobby_upgrade_label = _make_label(upgrade_panel_lobby, Vector2(18.0, 52.0), 15, Color(0.78, 0.86, 0.92))
	lobby_upgrade_label.size = Vector2(270.0, 38.0)
	var power_button := _make_menu_button(upgrade_panel_lobby, Vector2(18.0, 102.0), Vector2(282.0, 40.0), "코어 출력 +1", Color(0.12, 0.32, 0.44))
	power_button.add_theme_font_size_override("font_size", 17)
	power_button.pressed.connect(_buy_permanent_upgrade.bind("core_power"))
	var magnet_button := _make_menu_button(upgrade_panel_lobby, Vector2(18.0, 150.0), Vector2(282.0, 40.0), "흡수 반경 +1", Color(0.16, 0.28, 0.52))
	magnet_button.add_theme_font_size_override("font_size", 17)
	magnet_button.pressed.connect(_buy_permanent_upgrade.bind("xp_magnet"))
	var hp_button := _make_menu_button(upgrade_panel_lobby, Vector2(18.0, 198.0), Vector2(282.0, 40.0), "시작 체력 +1", Color(0.18, 0.44, 0.32))
	hp_button.add_theme_font_size_override("font_size", 17)
	hp_button.pressed.connect(_buy_permanent_upgrade.bind("start_hp"))

	var nav_names := ["무기 도감", "드론", "상점", "설정"]
	var nav_ids := ["weapons", "drones", "shop", "settings"]
	for i in range(nav_names.size()):
		var nav_button := _make_menu_button(lobby_screen, Vector2(26.0 + i * 169.0, 676.0), Vector2(150.0, 58.0), nav_names[i], Color(0.06, 0.12, 0.16))
		nav_button.add_theme_font_size_override("font_size", 17)
		nav_button.pressed.connect(_open_lobby_detail.bind(nav_ids[i]))

	_create_lobby_ad_reward_panel()

	var notice_panel := _make_panel(lobby_screen, Vector2(42.0, 948.0), Vector2(636.0, 66.0), Color(0.018, 0.04, 0.06, 0.78), Color(0.24, 0.72, 0.88, 0.3), false)
	lobby_status_label = _make_label(notice_panel, Vector2(18.0, 10.0), 16, Color(0.7, 0.9, 1.0))
	lobby_status_label.size = Vector2(600.0, 46.0)
	lobby_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lobby_status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lobby_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var start_run_button := _make_menu_button(lobby_screen, Vector2(42.0, 1032.0), Vector2(636.0, 92.0), "정화 런 시작", Color(0.1, 0.76, 0.58))
	start_run_button.add_theme_font_size_override("font_size", 28)
	start_run_button.pressed.connect(_start_run)

	var footer := _make_label(lobby_screen, Vector2(50.0, 1142.0), 14, Color(0.56, 0.68, 0.76))
	footer.text = "광고 보상은 선택형입니다. 강제 광고 없이 보상만 추가로 받을 수 있습니다."
	footer.size = Vector2(620.0, 50.0)
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	footer.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	_create_lobby_detail_overlay()
	_update_lobby_ui()


func _create_lobby_ad_reward_panel() -> void:
	var ad_panel := _make_panel(lobby_screen, Vector2(26.0, 754.0), Vector2(668.0, 184.0), Color(0.035, 0.07, 0.1, 0.9), Color(0.4, 0.95, 1.0, 0.5))
	var ad_title := _make_label(ad_panel, Vector2(18.0, 12.0), 21, Color(0.88, 1.0, 0.95))
	ad_title.text = "광고 보상"
	ad_title.size = Vector2(220.0, 32.0)
	var ad_desc := _make_label(ad_panel, Vector2(18.0, 44.0), 15, Color(0.7, 0.84, 0.9))
	ad_desc.text = "필요할 때만 선택해서 보상을 받습니다."
	ad_desc.size = Vector2(520.0, 28.0)

	var daily_ad_button := _make_menu_button(ad_panel, Vector2(18.0, 90.0), Vector2(200.0, 64.0), "추가 보너스", Color(0.08, 0.28, 0.38))
	daily_ad_button.add_theme_font_size_override("font_size", 17)
	daily_ad_button.pressed.connect(_request_daily_ad_bonus)

	var chest_button := _make_menu_button(ad_panel, Vector2(234.0, 90.0), Vector2(200.0, 64.0), "무료 상자", Color(0.14, 0.18, 0.34))
	chest_button.add_theme_font_size_override("font_size", 17)
	chest_button.pressed.connect(_request_free_chest_ad)

	var temp_drone_button := _make_menu_button(ad_panel, Vector2(450.0, 90.0), Vector2(200.0, 64.0), "드론 체험", Color(0.28, 0.2, 0.1))
	temp_drone_button.add_theme_font_size_override("font_size", 17)
	temp_drone_button.pressed.connect(_request_temp_drone_ad)


func _create_lobby_detail_overlay() -> void:
	lobby_detail_overlay = Control.new()
	lobby_detail_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	lobby_detail_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	lobby_detail_overlay.visible = false
	lobby_screen.add_child(lobby_detail_overlay)

	var dim := ColorRect.new()
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0.0, 0.0, 0.0, 0.62)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lobby_detail_overlay.add_child(dim)

	var panel := Panel.new()
	panel.position = Vector2(36.0, 76.0)
	panel.size = Vector2(648.0, 1058.0)
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.025, 0.05, 0.07, 0.98), Color(0.36, 0.94, 1.0, 0.86), false))
	lobby_detail_overlay.add_child(panel)

	lobby_detail_title_label = _make_label(panel, Vector2(28.0, 24.0), 28, Color(0.96, 1.0, 0.82))
	lobby_detail_title_label.size = Vector2(440.0, 46.0)

	var close_button := _make_menu_button(panel, Vector2(506.0, 20.0), Vector2(112.0, 50.0), "닫기", Color(0.1, 0.2, 0.28))
	close_button.add_theme_font_size_override("font_size", 16)
	close_button.pressed.connect(_close_lobby_detail)

	var scroll := ScrollContainer.new()
	scroll.position = Vector2(24.0, 86.0)
	scroll.size = Vector2(600.0, 920.0)
	panel.add_child(scroll)

	lobby_detail_list = VBoxContainer.new()
	lobby_detail_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lobby_detail_list.add_theme_constant_override("separation", 12)
	scroll.add_child(lobby_detail_list)


func _open_lobby_detail(detail_id: String) -> void:
	active_lobby_detail = detail_id
	lobby_detail_overlay.visible = true
	_refresh_lobby_detail()


func _close_lobby_detail() -> void:
	active_lobby_detail = ""
	if lobby_detail_overlay != null:
		lobby_detail_overlay.visible = false


func _refresh_lobby_detail() -> void:
	if lobby_detail_list == null:
		return
	for child in lobby_detail_list.get_children():
		child.queue_free()
	match active_lobby_detail:
		"weapons":
			_populate_weapon_codex()
		"drones":
			_populate_drone_screen()
		"shop":
			_populate_shop_screen()
		"settings":
			_populate_settings_screen()


func _make_detail_label(text: String, font_size: int = 17, color: Color = Color(0.82, 0.92, 0.96)) -> Label:
	var label := Label.new()
	label.text = text
	label.custom_minimum_size = Vector2(572.0, 0.0)
	label.add_theme_font_size_override("font_size", font_size)
	_apply_ui_font(label)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.72))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lobby_detail_list.add_child(label)
	return label


func _make_detail_card(title: String, body: String, accent: Color = Color(0.36, 0.92, 1.0), icon_texture: Texture2D = null) -> VBoxContainer:
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(588.0, 0.0)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_theme_stylebox_override("panel", _panel_style(Color(0.035, 0.075, 0.1, 0.94), Color(accent.r, accent.g, accent.b, 0.72), false))
	lobby_detail_list.add_child(card)

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	card.add_child(margin)

	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_theme_constant_override("separation", 6)
	margin.add_child(box)

	var title_label := Label.new()
	title_label.text = title
	title_label.add_theme_font_size_override("font_size", 20)
	_apply_ui_font(title_label)
	title_label.add_theme_color_override("font_color", Color(accent.r, accent.g, accent.b, 1.0))
	title_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.76))
	title_label.add_theme_constant_override("shadow_offset_x", 1)
	title_label.add_theme_constant_override("shadow_offset_y", 2)
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if icon_texture != null:
		var title_row := HBoxContainer.new()
		title_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		title_row.add_theme_constant_override("separation", 12)
		box.add_child(title_row)

		var icon := TextureRect.new()
		icon.texture = icon_texture
		icon.custom_minimum_size = Vector2(58.0, 58.0)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		title_row.add_child(icon)
		title_row.add_child(title_label)
	else:
		box.add_child(title_label)

	var body_label := Label.new()
	body_label.text = body
	body_label.custom_minimum_size = Vector2(540.0, 0.0)
	body_label.add_theme_font_size_override("font_size", 16)
	_apply_ui_font(body_label)
	body_label.add_theme_color_override("font_color", Color(0.82, 0.92, 0.96))
	body_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.68))
	body_label.add_theme_constant_override("shadow_offset_x", 1)
	body_label.add_theme_constant_override("shadow_offset_y", 2)
	body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(body_label)
	return box


func _make_detail_button(parent: VBoxContainer, text: String, callback: Callable, color: Color = Color(0.08, 0.68, 0.78)) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(540.0, 48.0)
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.focus_mode = Control.FOCUS_NONE
	button.clip_text = true
	button.add_theme_font_size_override("font_size", 17)
	_apply_ui_font(button)
	button.add_theme_stylebox_override("normal", _game_over_button_style(color, color.darkened(0.25)))
	button.add_theme_stylebox_override("hover", _game_over_button_style(color.lightened(0.08), color.darkened(0.12)))
	button.add_theme_stylebox_override("pressed", _game_over_button_style(color.darkened(0.14), color.darkened(0.32)))
	button.add_theme_color_override("font_color", Color(0.02, 0.1, 0.13))
	button.add_theme_color_override("font_hover_color", Color(0.0, 0.08, 0.1))
	button.add_theme_color_override("font_pressed_color", Color(0.0, 0.08, 0.1))
	button.pressed.connect(callback)
	parent.add_child(button)
	return button


func _populate_weapon_codex() -> void:
	lobby_detail_title_label.text = "무기 도감"
	_make_detail_label("기본 무기는 바로 사용할 수 있고, 잠금 무기는 코어 파편으로 구매하면 다음 정화 런부터 레벨업 선택지에 등장합니다.", 16)
	for weapon in _weapon_codex_data():
		var accent: Color = weapon["accent"]
		var weapon_id := str(weapon.get("id", ""))
		var unlockable := WEAPON_UNLOCK_COSTS.has(weapon_id)
		var owned := _is_weapon_unlocked(weapon_id)
		var state := str(weapon["state"])
		if unlockable:
			state = "보유 중" if owned else "구매 가능"
		var body := "%s\n밸런스: %s" % [weapon["desc"], weapon["balance"]]
		if unlockable:
			if owned:
				if weapon_id == "drone":
					body += "\n상태: 보유 중 - 다음 정화 런 시작 시 Lv.1 동행"
				else:
					body += "\n상태: 보유 중 - 레벨업 선택지에 등장"
			else:
				body += "\n가격: 정화 코어 파편 %d개" % _weapon_unlock_cost(weapon_id)
				if weapon_id == "drone":
					body += "\n구매 효과: 다음 정화 런 시작 시 Lv.1 드론 동행"
		elif _is_weapon_upgrade(weapon_id):
			body += "\n상태: 기본 지급"
		else:
			body += "\n상태: 다음 콘텐츠 업데이트 예정"
		var card := _make_detail_card("%s  %s" % [weapon["name"], state], body, accent, _upgrade_icon_texture(weapon_id))
		if unlockable:
			if owned:
				var owned_button := _make_detail_button(card, "보유 중", Callable(self, "_noop_detail_action"), accent)
				owned_button.disabled = true
			else:
				_make_detail_button(card, "파편 %d개로 구매" % _weapon_unlock_cost(weapon_id), _buy_weapon_unlock.bind(weapon_id), accent)
		elif not _is_weapon_upgrade(weapon_id):
			var pending_button := _make_detail_button(card, "준비 중", Callable(self, "_noop_detail_action"), Color(0.28, 0.34, 0.4))
			pending_button.disabled = true
	_make_detail_label("진화 조합은 도감에서 먼저 안내합니다. 실제 진화 전환은 다음 전투 밸런스 패스에서 연결합니다.", 15, Color(0.72, 0.84, 0.9))
	for evolution in _evolution_codex_data():
		var evolution_id := str(evolution.get("id", ""))
		_make_detail_card("%s" % evolution["name"], "%s\n조건: %s" % [evolution["desc"], evolution["recipe"]], Color(1.0, 0.74, 0.28), _evolution_icon_texture(evolution_id))


func _populate_drone_screen() -> void:
	lobby_detail_title_label.text = "드론"
	var pack_text := "보유" if special_drone_unlocked or _is_product_owned(BillingServiceScript.PRODUCT_SPECIAL_DRONE_PACK) else "미보유"
	_make_detail_label("현재 장착 상태: 정화 드론 Lv.%d / 특수 드론 패키지: %s" % [maxi(drone_level, 0), pack_text], 17, Color(0.9, 1.0, 0.82))
	for drone in _drone_codex_data():
		var drone_id := str(drone.get("id", ""))
		var body := "%s\n역할: %s\n상태: %s" % [drone["desc"], drone["role"], drone["state"]]
		_make_detail_card(drone["name"], body, drone["accent"], _drone_icon_texture(drone_id))
	var ad_card := _make_detail_card("드론 체험권", "광고 보상으로 다음 런에 정화 드론 1기를 임시 동행시킵니다. 특수 드론 팩을 구매하면 매 런 기본 드론이 활성화됩니다.", Color(0.48, 0.92, 1.0))
	_make_detail_button(ad_card, "광고 보고 드론 체험 준비", Callable(self, "_request_temp_drone_ad"), Color(0.08, 0.78, 0.92))
	_make_detail_button(ad_card, "특수 드론 팩 보기", Callable(self, "_open_shop_from_detail"), Color(0.96, 0.64, 0.18))


func _populate_shop_screen() -> void:
	lobby_detail_title_label.text = "상점"
	_make_detail_label("구매 상품은 진행 강제가 아니라 시간 절약, 외형, 빌드 다양성 중심입니다. 결제는 Google Play 결제 화면으로 진행됩니다.", 15)
	for product in _shop_product_data():
		var product_id := str(product["id"])
		var price := _product_price(product)
		var owned := _is_product_owned(product_id)
		var body := "%s\n유형: %s  /  가격: %s\n상태: %s" % [
			product["desc"],
			product["type"],
			price,
			"보유 중" if owned else "구매 가능"
		]
		var card := _make_detail_card(str(product["name"]), body, product["accent"], _product_icon_texture(product_id))
		var button_text := "보유 중" if owned else "구매하기"
		var buy_button := _make_detail_button(card, button_text, _request_purchase.bind(product_id), product["accent"])
		buy_button.disabled = owned and product_id != BillingServiceScript.PRODUCT_GROWTH_SHARD_PACK
	var restore_card := _make_detail_card("구매 복원", "기기 변경 또는 재설치 후 Google Play 구매 내역을 다시 불러옵니다.", Color(0.52, 0.82, 1.0))
	_make_detail_button(restore_card, "구매 복원", Callable(self, "_restore_purchases"), Color(0.42, 0.72, 0.96))


func _populate_settings_screen() -> void:
	lobby_detail_title_label.text = "설정"
	_make_detail_card("언어", "기본 언어: 한국어\n현재 빌드는 개발툴 오프닝 없이 한국어 UI를 기본으로 표시합니다.", Color(0.46, 0.92, 1.0))
	var sound_card := _make_detail_card("사운드", "현재 상태: %s\n오디오 리소스 연결 전까지는 설정값만 저장합니다." % ("켜짐" if sound_enabled else "꺼짐"), Color(0.24, 0.88, 0.72), _settings_icon_texture("sound"))
	_make_detail_button(sound_card, "사운드 %s" % ("끄기" if sound_enabled else "켜기"), Callable(self, "_toggle_sound_setting"), Color(0.16, 0.78, 0.66))
	var vibration_card := _make_detail_card("진동", "현재 상태: %s\nAndroid 햅틱 연결 후 전투 피격/보스 등장에 사용합니다." % ("켜짐" if vibration_enabled else "꺼짐"), Color(0.92, 0.74, 0.28), _settings_icon_texture("haptic"))
	_make_detail_button(vibration_card, "진동 %s" % ("끄기" if vibration_enabled else "켜기"), Callable(self, "_toggle_vibration_setting"), Color(0.9, 0.66, 0.18))
	_make_detail_card("데이터", "저장 위치: user://core_survivor_save.json\n저장 항목: 코어 선택, 재화, 영구 강화, 보상 수령, 구매 효과, 설정값.", Color(0.66, 0.72, 1.0))
	var restore_card := _make_detail_card("구매 복원", "광고 제거, 스킨, 드론 팩, 월간 패스 같은 비소모성 상품을 Google Play에서 다시 확인합니다.", Color(0.52, 0.82, 1.0))
	_make_detail_button(restore_card, "구매 복원", Callable(self, "_restore_purchases"), Color(0.42, 0.72, 0.96))


func _weapon_codex_data() -> Array:
	return [
		{"id": "bolt", "name": "정화 볼트", "state": "보유 중", "desc": "가장 가까운 적을 자동 조준하는 기본 탄환.", "balance": "빠른 발사, 낮은 단일 피해, Lv.4부터 관통", "accent": Color(0.36, 0.94, 1.0)},
		{"id": "missile", "name": "코멧 미사일", "state": "보유 중", "desc": "느리지만 강한 추적 미사일. 폭발과 파편으로 무리를 정리.", "balance": "초반 기본 지급, 강력하지만 쿨타임이 길어 볼트/펄스와 병행 필요", "accent": Color(1.0, 0.62, 0.18)},
		{"id": "pulse", "name": "펄스 웨이브", "state": "구매 가능", "desc": "주기적으로 주변 오염체를 밀어내며 피해.", "balance": "생존 보조형 광역기, 보스 딜은 낮음", "accent": Color(0.46, 0.62, 1.0)},
		{"id": "drone", "name": "정화 드론", "state": "구매 가능", "desc": "궤도 드론이 가까운 적을 보조 사격.", "balance": "안정적인 추가 DPS, 특수 드론 팩과 광고 체험으로도 접근", "accent": Color(1.0, 0.78, 0.24)},
		{"id": "plasma", "name": "플라즈마 링", "state": "준비 중", "desc": "플레이어 주변을 회전하는 근접 방어 무기.", "balance": "근접 안정성, 추후 진화용", "accent": Color(1.0, 0.42, 0.2)},
		{"id": "chain", "name": "스파크 체인", "state": "준비 중", "desc": "적 사이를 연쇄하는 전기 공격.", "balance": "무리 정리 특화, 단일 보스 딜 제한", "accent": Color(1.0, 0.9, 0.22)},
		{"id": "laser", "name": "레이저 랜스", "state": "준비 중", "desc": "긴 직선 관통 빔으로 보스를 겨냥.", "balance": "보스 딜 특화, 난전 안정성 낮음", "accent": Color(0.52, 1.0, 0.86)},
		{"id": "bomb", "name": "퍼지 밤", "state": "준비 중", "desc": "지연 폭발로 넓은 정화 지대를 만드는 무기.", "balance": "예측형 광역기, 느린 발동", "accent": Color(0.72, 0.48, 1.0)}
	]


func _evolution_codex_data() -> Array:
	return [
		{"id": "photon_storm", "name": "포톤 스톰", "recipe": "정화 볼트 Lv.5 + 타겟팅 드론 Lv.2", "desc": "전방 다중 관통탄으로 라인과 보스를 동시에 압박."},
		{"id": "comet_battery", "name": "코멧 배터리", "recipe": "코멧 미사일 Lv.5 + 마그넷 드론 Lv.2", "desc": "플레이어 주변 우선 낙하와 자동 흡수 보조."},
		{"id": "solar_halo", "name": "솔라 헤일로", "recipe": "플라즈마 링 Lv.5 + 실드 드론 Lv.2", "desc": "방어막 보유 중 회전 링 피해 증가."},
		{"id": "thunder_web", "name": "썬더 웹", "recipe": "스파크 체인 Lv.5 + 캐패시터 드론 Lv.2", "desc": "연쇄 번개 마지막 타격이 폭발."},
		{"id": "rail_prism", "name": "레일 프리즘", "recipe": "레이저 랜스 Lv.5 + 앰프 드론 Lv.2", "desc": "보스 우선 장거리 관통 레이저."},
		{"id": "cleanser_nova", "name": "클렌저 노바", "recipe": "퍼지 밤 Lv.5 + 리페어 드론 Lv.2", "desc": "대형 폭발 후 정화 지대를 남김."}
	]


func _drone_codex_data() -> Array:
	return [
		{"id": "purify", "name": "정화 드론", "desc": "가까운 적을 자동 사격하는 기본 궤도 드론.", "role": "초반 보조 화력", "state": "전투 구현", "accent": Color(0.36, 0.94, 1.0)},
		{"id": "targeting", "name": "타겟팅 드론", "desc": "치명타와 보스 우선 조준을 제공하는 공격형 드론.", "role": "보스/단일딜", "state": "도감/상품 후보", "accent": Color(1.0, 0.78, 0.24)},
		{"id": "capacitor", "name": "캐패시터 드론", "desc": "공격 속도와 감전 피해를 보조하는 드론.", "role": "연타 빌드", "state": "도감", "accent": Color(1.0, 0.9, 0.22)},
		{"id": "shield", "name": "실드 드론", "desc": "피해 흡수 보호막을 충전하는 방어 드론.", "role": "생존", "state": "도감", "accent": Color(0.42, 0.72, 1.0)},
		{"id": "magnet", "name": "마그넷 드론", "desc": "오염 에너지 흡수 범위를 넓히는 성장 드론.", "role": "레벨업 가속", "state": "도감", "accent": Color(0.72, 0.48, 1.0)},
		{"id": "repair", "name": "리페어 드론", "desc": "천천히 HP를 회복하고 위기 상황을 완화.", "role": "안정성", "state": "도감", "accent": Color(0.36, 1.0, 0.56)}
	]


func _shop_product_data() -> Array:
	return [
		{"id": BillingServiceScript.PRODUCT_REMOVE_ADS, "name": "광고 제거 팩", "type": "영구", "price": "₩5,900", "desc": "정화 런 종료 후 나오는 전면 광고를 제거합니다. 선택형 보상 광고는 원할 때만 볼 수 있습니다.", "accent": Color(0.08, 0.78, 0.92)},
		{"id": BillingServiceScript.PRODUCT_STARTER_CORE_PACK, "name": "스타터 코어 팩", "type": "1회 구매", "price": "₩3,300", "desc": "정화 코어 파편 1,800개와 초반 영구 강화 1단계를 지급합니다.", "accent": Color(0.22, 0.86, 0.62)},
		{"id": BillingServiceScript.PRODUCT_PREMIUM_CORE_SKIN_PACK, "name": "프리미엄 코어 스킨 팩", "type": "영구", "price": "₩6,600", "desc": "프리미엄 코어 오라를 해금합니다. 전투력보다 외형 만족 중심 상품입니다.", "accent": Color(0.92, 0.74, 0.28)},
		{"id": BillingServiceScript.PRODUCT_SPECIAL_DRONE_PACK, "name": "특수 드론 패키지", "type": "영구", "price": "₩4,400", "desc": "매 런 시작 시 정화 드론 1기를 기본 동행시킵니다. 드론 빌드 접근성을 높입니다.", "accent": Color(0.52, 0.82, 1.0)},
		{"id": BillingServiceScript.PRODUCT_GROWTH_SHARD_PACK, "name": "성장 파편 패키지", "type": "소모성", "price": "₩1,100", "desc": "정화 코어 파편 2,200개를 즉시 지급합니다.", "accent": Color(0.78, 0.52, 1.0)},
		{"id": BillingServiceScript.PRODUCT_MONTHLY_SUPPLY_PASS, "name": "월간 보급 패스", "type": "월간 구독", "price": "₩5,500/월", "desc": "즉시 파편 900개, 일일 보급 추가 +40, 광고 보상 보너스 +30을 제공합니다.", "accent": Color(1.0, 0.62, 0.18)}
	]


func _open_shop_from_detail() -> void:
	active_lobby_detail = "shop"
	_refresh_lobby_detail()


func _toggle_sound_setting() -> void:
	sound_enabled = not sound_enabled
	_save_game()
	_refresh_lobby_detail()
	_show_lobby_notice("사운드 설정이 %s으로 변경되었습니다." % ("켜짐" if sound_enabled else "꺼짐"))


func _toggle_vibration_setting() -> void:
	vibration_enabled = not vibration_enabled
	_save_game()
	_refresh_lobby_detail()
	_show_lobby_notice("진동 설정이 %s으로 변경되었습니다." % ("켜짐" if vibration_enabled else "꺼짐"))


func _restore_purchases() -> void:
	if billing_service == null or not billing_service.is_available():
		_show_lobby_notice("현재 실행 환경에서는 Google Play 구매 복원을 사용할 수 없습니다.")
		return
	billing_service.restore_purchases()
	_show_lobby_notice("구매 복원을 요청했습니다.")


func _request_purchase(product_id: String) -> void:
	if _is_product_owned(product_id) and product_id != BillingServiceScript.PRODUCT_GROWTH_SHARD_PACK:
		_show_lobby_notice("이미 보유 중인 상품입니다.")
		return
	if billing_service == null or not billing_service.is_available():
		_show_lobby_notice("현재 실행 환경에서는 Google Play 결제를 사용할 수 없습니다.")
		return
	if billing_service.purchase(product_id):
		_show_lobby_notice("구매 화면을 여는 중입니다.")


func _buy_weapon_unlock(weapon_id: String) -> void:
	if not WEAPON_UNLOCK_COSTS.has(weapon_id):
		_show_lobby_notice("아직 구매할 수 없는 무기입니다.")
		return
	if _is_weapon_unlocked(weapon_id):
		_show_lobby_notice("이미 보유 중인 무기입니다.")
		return
	var cost := _weapon_unlock_cost(weapon_id)
	if meta_currency < cost:
		_show_lobby_notice("정화 코어 파편이 부족합니다. 필요한 파편: %d개" % cost)
		return
	meta_currency -= cost
	weapon_unlocks[weapon_id] = true
	_save_game()
	_update_lobby_ui()
	_refresh_lobby_detail()
	if weapon_id == "drone":
		_show_lobby_notice("정화 드론이 해금되었습니다. 다음 정화 런을 시작하면 Lv.1 드론이 바로 동행합니다.")
	else:
		_show_lobby_notice("%s 무기가 해금되었습니다. 다음 정화 런의 레벨업 선택지에 등장합니다." % _weapon_display_name(weapon_id))


func _weapon_unlock_cost(weapon_id: String) -> int:
	return int(WEAPON_UNLOCK_COSTS.get(weapon_id, 0))


func _is_weapon_upgrade(weapon_id: String) -> bool:
	return WEAPON_UPGRADE_IDS.has(weapon_id)


func _is_weapon_unlocked(weapon_id: String) -> bool:
	if not _is_weapon_upgrade(weapon_id):
		return false
	if weapon_id == "drone" and (special_drone_unlocked or _is_product_owned(BillingServiceScript.PRODUCT_SPECIAL_DRONE_PACK)):
		return true
	return bool(weapon_unlocks.get(weapon_id, false))


func _weapon_display_name(weapon_id: String) -> String:
	for weapon in _weapon_codex_data():
		if str(weapon.get("id", "")) == weapon_id:
			return str(weapon["name"])
	return weapon_id


func _noop_detail_action() -> void:
	pass


func _product_price(product: Dictionary) -> String:
	var product_id := str(product["id"])
	if billing_service != null:
		var loaded_price: String = billing_service.get_product_price(product_id)
		if not loaded_price.is_empty():
			return loaded_price
	return str(product["price"])


func _is_product_owned(product_id: String) -> bool:
	if product_id == BillingServiceScript.PRODUCT_GROWTH_SHARD_PACK:
		return false
	if product_id == BillingServiceScript.PRODUCT_MONTHLY_SUPPLY_PASS:
		if billing_service != null and billing_service.is_owned(product_id):
			return true
		return monthly_pass_active
	if billing_service != null and billing_service.is_owned(product_id):
		return true
	return bool(purchase_reward_claimed.get(product_id, false))


func _product_display_name(product_id: String) -> String:
	for product in _shop_product_data():
		if str(product["id"]) == product_id:
			return str(product["name"])
	return product_id


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


func _make_panel(parent: Control, pos: Vector2, panel_size: Vector2, bg: Color, border: Color, use_texture_skin: bool = true) -> Panel:
	var panel := Panel.new()
	panel.position = pos
	panel.size = panel_size
	panel.clip_contents = true
	panel.add_theme_stylebox_override("panel", _panel_style(bg, border, false))
	parent.add_child(panel)
	if use_texture_skin and ui_panel_skin != null:
		_add_texture_skin(panel, Vector2.ZERO, panel_size, ui_panel_skin, PANEL_SKIN_SOURCE_RECT, LOBBY_PANEL_SKIN_ALPHA, Vector4.ZERO, PANEL_SKIN_SLICE_MARGINS)
	return panel


func _make_menu_button(parent: Control, pos: Vector2, button_size: Vector2, text: String, color: Color, use_texture: bool = true) -> Button:
	var use_texture_skin := use_texture and ui_button_skin != null and button_size.y >= 40.0
	if use_texture_skin:
		var skin_alpha := LOBBY_PRIMARY_BUTTON_SKIN_ALPHA if button_size.y >= 86.0 else LOBBY_BUTTON_SKIN_ALPHA
		_add_texture_skin(parent, pos, button_size, ui_button_skin, BUTTON_SKIN_SOURCE_RECT, skin_alpha, BUTTON_SKIN_VISUAL_PADDING, BUTTON_SKIN_SLICE_MARGINS)

	var button := Button.new()
	button.position = pos
	button.size = button_size
	button.text = text
	button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 20)
	_apply_ui_font(button)
	var normal_color := color
	var hover_color := color.lightened(0.12)
	var pressed_color := color.darkened(0.18)
	if use_texture_skin:
		button.add_theme_stylebox_override("normal", _transparent_button_style(Color(0.0, 0.0, 0.0, 0.0)))
		button.add_theme_stylebox_override("hover", _transparent_button_style(Color(1.0, 1.0, 1.0, 0.05)))
		button.add_theme_stylebox_override("pressed", _transparent_button_style(Color(0.0, 0.25, 0.32, 0.10)))
	else:
		button.add_theme_stylebox_override("normal", _button_style(normal_color, true))
		button.add_theme_stylebox_override("hover", _button_style(hover_color, true))
		button.add_theme_stylebox_override("pressed", _button_style(pressed_color, true))
	if use_texture_skin:
		button.add_theme_color_override("font_color", Color(0.02, 0.16, 0.22))
		button.add_theme_color_override("font_hover_color", Color(0.0, 0.1, 0.16))
		button.add_theme_color_override("font_pressed_color", Color(0.0, 0.08, 0.13))
		button.add_theme_color_override("font_shadow_color", Color(1.0, 1.0, 1.0, 0.44))
		button.add_theme_constant_override("shadow_offset_x", 0)
		button.add_theme_constant_override("shadow_offset_y", 1)
	else:
		button.add_theme_color_override("font_color", Color(0.92, 1.0, 0.98))
		button.add_theme_color_override("font_hover_color", Color.WHITE)
		button.add_theme_color_override("font_pressed_color", Color(0.82, 0.98, 0.94))
		button.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.7))
		button.add_theme_constant_override("shadow_offset_x", 1)
		button.add_theme_constant_override("shadow_offset_y", 2)
	button.clip_text = true
	parent.add_child(button)
	return button


func _add_texture_skin(parent: Control, pos: Vector2, rect_size: Vector2, texture: Texture2D, source_rect: Rect2, alpha: float, padding: Vector4 = Vector4.ZERO, slice_margins: Vector4 = Vector4.ZERO) -> Control:
	var skin := UiTextureSkinScript.new()
	skin.position = pos - Vector2(padding.x, padding.y)
	skin.size = rect_size + Vector2(padding.x + padding.z, padding.y + padding.w)
	skin.texture = texture
	skin.source_rect = source_rect
	skin.tint = Color(1.0, 1.0, 1.0, alpha)
	skin.slice_margins = slice_margins
	skin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(skin)
	return skin


func _make_core_selected_badge(pos: Vector2) -> Panel:
	var badge := Panel.new()
	badge.position = pos
	badge.size = Vector2(104.0, 26.0)
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.add_theme_stylebox_override(
		"panel",
		_panel_style(Color(1.0, 0.84, 0.24, 0.84), Color(1.0, 1.0, 0.78, 0.58), false)
	)
	lobby_screen.add_child(badge)

	var label := _make_label(badge, Vector2.ZERO, 12, Color(0.04, 0.12, 0.14))
	label.text = "선택됨"
	label.size = badge.size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_shadow_color", Color(1.0, 1.0, 1.0, 0.35))
	label.add_theme_constant_override("shadow_offset_x", 0)
	label.add_theme_constant_override("shadow_offset_y", 1)
	badge.visible = false
	return badge


func _create_core_card(core_id: String, title: String, desc: String, pos: Vector2, accent: Color) -> void:
	var card := _make_panel(lobby_screen, pos, Vector2(198.0, 166.0), Color(0.018, 0.04, 0.055, 0.82), Color(accent.r, accent.g, accent.b, 0.32))
	core_card_panels[core_id] = card

	var preview_texture := _core_preview_texture(core_id)
	if preview_texture != null:
		var preview := UiTextureSkinScript.new()
		preview.texture = preview_texture
		preview.source_rect = CORE_CARD_PREVIEW_SOURCE_RECT
		preview.position = Vector2(48.0, -4.0)
		preview.size = Vector2(102.0, 92.0)
		preview.tint = Color(1.0, 1.0, 1.0, 1.0)
		preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(preview)
		core_card_preview_nodes[core_id] = preview

	var title_label := _make_label(card, Vector2(16.0, 74.0), 17, Color(accent.r, accent.g, accent.b, 1.0))
	title_label.text = title
	title_label.size = Vector2(166.0, 28.0)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	core_card_title_labels[core_id] = title_label

	var desc_label := _make_label(card, Vector2(14.0, 98.0), 12, Color(0.78, 0.9, 0.94))
	desc_label.text = desc
	desc_label.size = Vector2(170.0, 30.0)
	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	core_card_desc_labels[core_id] = desc_label

	var button := _make_menu_button(lobby_screen, pos, Vector2(198.0, 166.0), "", accent.darkened(0.35), false)
	button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.add_theme_font_size_override("font_size", 16)
	button.add_theme_stylebox_override("normal", _transparent_button_style(Color(0.0, 0.0, 0.0, 0.0)))
	button.add_theme_stylebox_override("hover", _transparent_button_style(Color(accent.r, accent.g, accent.b, 0.08)))
	button.add_theme_stylebox_override("pressed", _transparent_button_style(Color(accent.r, accent.g, accent.b, 0.14)))
	button.set_meta("accent", accent)
	button.set_meta("title", title)
	button.set_meta("desc", desc)
	button.pressed.connect(_select_core.bind(core_id))
	core_card_buttons[core_id] = button
	core_badge_panels[core_id] = _make_core_selected_badge(pos + Vector2(47.0, 136.0))


func _select_core(core_id: String) -> void:
	selected_core_id = core_id
	_save_game()
	_update_lobby_ui()
	_show_lobby_notice("%s 코어가 선택되었습니다. 선택한 코어 효과는 다음 정화 런에 바로 적용됩니다." % _core_title(core_id))


func _core_title(core_id: String) -> String:
	if core_card_buttons.has(core_id):
		var button: Button = core_card_buttons[core_id]
		return str(button.get_meta("title"))
	match core_id:
		"attack":
			return "공격형"
		"absorb":
			return "흡수형"
		_:
			return "정화형"


func _claim_daily_reward() -> void:
	if daily_reward_claimed:
		_show_lobby_notice("오늘의 보급은 이미 받았습니다. 내일 다시 받을 수 있습니다.")
		return
	daily_reward_claimed = true
	daily_reward_date = _current_date_key()
	var reward := DAILY_REWARD_BASE
	if _has_monthly_pass():
		reward += MONTHLY_DAILY_REWARD_BONUS
	meta_currency += reward
	_save_game()
	_update_lobby_ui()
	_show_lobby_notice("정화 코어 파편 %d개를 받았습니다." % reward)


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
		var message := "광고가 아직 준비되지 않았습니다. 잠시 후 다시 시도하세요."
		if screen_state == ScreenState.RUN:
			_show_banner(message)
		else:
			_show_lobby_notice(message)


func _buy_permanent_upgrade(upgrade_id: String) -> void:
	var current := int(permanent_upgrades.get(upgrade_id, 0))
	var cost := 110 + current * 85
	if meta_currency < cost:
		_show_lobby_notice("정화 코어 파편이 부족합니다. 런 보상이나 일일 보급으로 모을 수 있습니다.")
		return
	meta_currency -= cost
	permanent_upgrades[upgrade_id] = current + 1
	_save_game()
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
	if lobby_core_summary_label != null:
		var core_summary := "현재 선택: %s 코어" % _core_title(selected_core_id)
		if selected_core_id == "attack":
			core_summary += "  /  볼트 피해 강화, 빠른 처치 중심"
		elif selected_core_id == "absorb":
			core_summary += "  /  흡수 반경 증가, 레벨업 가속"
		else:
			core_summary += "  /  체력 보너스, 안정적인 생존"
		lobby_core_summary_label.text = core_summary
	for core_id in core_card_buttons.keys():
		var button: Button = core_card_buttons[core_id]
		var accent: Color = button.get_meta("accent")
		var title := str(button.get_meta("title"))
		var desc := str(button.get_meta("desc"))
		button.text = ""
		if core_card_title_labels.has(core_id):
			var title_label: Label = core_card_title_labels[core_id]
			title_label.text = title
			title_label.add_theme_color_override("font_color", Color(accent.r, accent.g, accent.b, 1.0))
		if core_card_desc_labels.has(core_id):
			var desc_label: Label = core_card_desc_labels[core_id]
			desc_label.text = desc
			desc_label.add_theme_color_override("font_color", Color(0.78, 0.9, 0.94))
		if core_card_preview_nodes.has(core_id):
			var preview: Control = core_card_preview_nodes[core_id]
			preview.modulate = Color(1.0, 1.0, 1.0, 1.0) if core_id == selected_core_id else Color(0.82, 0.9, 0.94, 0.82)
		if core_card_panels.has(core_id):
			var card_panel: Panel = core_card_panels[core_id]
			if core_id == selected_core_id:
				card_panel.add_theme_stylebox_override("panel", _panel_style(Color(accent.r * 0.16, accent.g * 0.18, accent.b * 0.18, 0.9), Color(accent.r, accent.g, accent.b, 0.68), false))
				if core_card_desc_labels.has(core_id):
					var selected_desc_label: Label = core_card_desc_labels[core_id]
					selected_desc_label.add_theme_color_override("font_color", Color(0.92, 1.0, 0.98))
			else:
				card_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.018, 0.04, 0.055, 0.82), Color(accent.r, accent.g, accent.b, 0.28), false))
		if core_badge_panels.has(core_id):
			var badge: Panel = core_badge_panels[core_id]
			badge.visible = core_id == selected_core_id
		if core_id == selected_core_id:
			button.add_theme_stylebox_override("normal", _transparent_button_style(Color(1.0, 1.0, 1.0, 0.02)))
			button.add_theme_stylebox_override("hover", _transparent_button_style(Color(accent.r, accent.g, accent.b, 0.1)))
			button.add_theme_color_override("font_color", Color(0.95, 1.0, 0.96))
			button.add_theme_color_override("font_hover_color", Color.WHITE)
		else:
			button.add_theme_stylebox_override("normal", _transparent_button_style(Color(0.0, 0.0, 0.0, 0.0)))
			button.add_theme_stylebox_override("hover", _transparent_button_style(Color(accent.r, accent.g, accent.b, 0.08)))
			button.add_theme_color_override("font_color", Color(0.78, 0.9, 0.94))
			button.add_theme_color_override("font_hover_color", Color(0.9, 1.0, 1.0))
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


func _on_interstitial_loaded(placement: String) -> void:
	if placement != AD_RUN_END_5TH or not pending_run_end_interstitial:
		return
	if _has_remove_ads() or screen_state != ScreenState.RUN or not run_finished:
		pending_run_end_interstitial = false
		return
	if ad_service != null and ad_service.show_interstitial(placement):
		pending_run_end_interstitial = false


func _on_interstitial_failed(placement: String, message: String) -> void:
	if placement == AD_RUN_END_5TH and message != "전면 광고를 불러오는 중입니다.":
		pending_run_end_interstitial = false


func _on_interstitial_closed(placement: String) -> void:
	if placement == AD_RUN_END_5TH:
		pending_run_end_interstitial = false
		if ad_service != null:
			ad_service.preload_interstitial(AD_RUN_END_5TH)


func _on_billing_ready() -> void:
	monthly_pass_active = false
	_save_game()
	if billing_service != null:
		billing_service.query_products()


func _on_billing_error(_message: String) -> void:
	_show_lobby_notice("결제 서비스를 초기화하지 못했습니다. 잠시 후 다시 시도하세요.")


func _on_billing_product_loaded(_product_id: String, _product_type: String, _title: String, _price: String) -> void:
	if active_lobby_detail == "shop":
		_refresh_lobby_detail()


func _on_billing_product_unavailable(_product_id: String, _reason: String) -> void:
	if active_lobby_detail == "shop":
		_refresh_lobby_detail()


func _on_billing_purchase_completed(product_id: String, _purchase_token: String) -> void:
	_apply_purchase_reward(product_id)


func _on_billing_purchase_pending(product_id: String) -> void:
	_show_lobby_notice("구매 승인이 대기 중입니다: %s" % product_id)


func _on_billing_purchase_cancelled(_product_id: String) -> void:
	_show_lobby_notice("구매가 취소되었습니다.")


func _on_billing_purchase_failed(product_id: String, _message: String) -> void:
	_show_lobby_notice("구매에 실패했습니다: %s" % product_id)


func _on_billing_purchase_restored(product_id: String, _purchase_token: String) -> void:
	_apply_purchase_reward(product_id)


func _apply_purchase_reward(product_id: String) -> void:
	var already_claimed := bool(purchase_reward_claimed.get(product_id, false))
	match product_id:
		BillingServiceScript.PRODUCT_STARTER_CORE_PACK:
			if already_claimed:
				_show_lobby_notice("스타터 코어 팩은 이미 적용되어 있습니다.")
				return
			meta_currency += 1800
			permanent_upgrades["core_power"] = maxi(int(permanent_upgrades["core_power"]), 1)
			permanent_upgrades["xp_magnet"] = maxi(int(permanent_upgrades["xp_magnet"]), 1)
			purchase_reward_claimed[product_id] = true
		BillingServiceScript.PRODUCT_GROWTH_SHARD_PACK:
			meta_currency += 2200
		BillingServiceScript.PRODUCT_REMOVE_ADS:
			purchase_reward_claimed[product_id] = true
		BillingServiceScript.PRODUCT_PREMIUM_CORE_SKIN_PACK:
			premium_core_skin_unlocked = true
			purchase_reward_claimed[product_id] = true
		BillingServiceScript.PRODUCT_SPECIAL_DRONE_PACK:
			special_drone_unlocked = true
			purchase_reward_claimed[product_id] = true
		BillingServiceScript.PRODUCT_MONTHLY_SUPPLY_PASS:
			monthly_pass_active = true
			if not already_claimed:
				meta_currency += 900
				purchase_reward_claimed[product_id] = true
	_save_game()
	_update_lobby_ui()
	if active_lobby_detail == "shop":
		_refresh_lobby_detail()
	_show_lobby_notice("구매 상품이 적용되었습니다: %s" % _product_display_name(product_id))


func _grant_daily_ad_bonus() -> void:
	if daily_ad_bonus_claimed:
		return
	daily_ad_bonus_claimed = true
	daily_ad_bonus_date = _current_date_key()
	var reward := DAILY_AD_REWARD_BASE
	if _has_monthly_pass():
		reward += MONTHLY_AD_REWARD_BONUS
	meta_currency += reward
	_save_game()
	_update_lobby_ui()
	_show_lobby_notice("광고 추가 보너스로 정화 코어 파편 %d개를 받았습니다." % reward)


func _grant_free_chest() -> void:
	if free_chest_claimed:
		return
	free_chest_claimed = true
	free_chest_date = _current_date_key()
	var reward := rng.randi_range(FREE_CHEST_REWARD_MIN, FREE_CHEST_REWARD_MAX)
	if _has_monthly_pass():
		reward += MONTHLY_AD_REWARD_BONUS
	meta_currency += reward
	_save_game()
	_update_lobby_ui()
	_show_lobby_notice("무료 상자에서 정화 코어 파편 %d개를 얻었습니다." % reward)


func _grant_temp_drone() -> void:
	if temp_drone_ready:
		return
	temp_drone_ready = true
	_save_game()
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
	upgrade_panel.position = Vector2(42.0, 286.0)
	upgrade_panel.size = Vector2(636.0, 642.0)
	upgrade_panel.visible = false
	upgrade_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.025, 0.05, 0.08, 0.96), Color(0.34, 0.92, 1.0, 0.82)))
	run_hud.add_child(upgrade_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 22)
	margin.add_theme_constant_override("margin_bottom", 22)
	upgrade_panel.add_child(margin)

	upgrade_list = VBoxContainer.new()
	upgrade_list.add_theme_constant_override("separation", 12)
	margin.add_child(upgrade_list)


func _create_game_over_panel() -> void:
	game_over_backdrop = ColorRect.new()
	game_over_backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	game_over_backdrop.color = Color(0.0, 0.0, 0.0, 0.58)
	game_over_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	game_over_backdrop.visible = false
	run_hud.add_child(game_over_backdrop)

	game_over_panel = PanelContainer.new()
	game_over_panel.position = Vector2(54.0, 310.0)
	game_over_panel.size = Vector2(612.0, 602.0)
	game_over_panel.visible = false
	game_over_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.025, 0.045, 0.06, 0.98), Color(0.42, 0.96, 1.0, 0.9), false))
	run_hud.add_child(game_over_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_top", 26)
	margin.add_theme_constant_override("margin_bottom", 26)
	game_over_panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 13)
	margin.add_child(box)

	game_over_label = Label.new()
	game_over_label.add_theme_font_size_override("font_size", 23)
	_apply_ui_font(game_over_label)
	game_over_label.add_theme_color_override("font_color", Color(0.92, 0.98, 1.0))
	game_over_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.88))
	game_over_label.add_theme_constant_override("shadow_offset_x", 2)
	game_over_label.add_theme_constant_override("shadow_offset_y", 2)
	game_over_label.add_theme_constant_override("line_spacing", 8)
	game_over_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	game_over_label.custom_minimum_size = Vector2(548.0, 226.0)
	box.add_child(game_over_label)

	revive_ad_button = Button.new()
	revive_ad_button.text = "광고 보고 1회 부활"
	_style_game_over_button(revive_ad_button, Color(0.06, 0.78, 0.92), Color(0.04, 0.48, 0.70), Color(0.01, 0.08, 0.12))
	revive_ad_button.pressed.connect(_request_revive_ad)
	box.add_child(revive_ad_button)

	double_reward_ad_button = Button.new()
	double_reward_ad_button.text = "광고 보고 보상 2배"
	_style_game_over_button(double_reward_ad_button, Color(0.96, 0.68, 0.18), Color(0.56, 0.34, 0.06), Color(0.09, 0.06, 0.02))
	double_reward_ad_button.pressed.connect(_request_run_reward_2x_ad)
	box.add_child(double_reward_ad_button)

	var retry := Button.new()
	retry.text = "바로 재도전"
	_style_game_over_button(retry, Color(0.08, 0.84, 0.64), Color(0.04, 0.46, 0.40), Color(0.01, 0.08, 0.08), 22)
	retry.pressed.connect(_start_run)
	box.add_child(retry)

	var lobby_button := Button.new()
	lobby_button.text = "로비로 이동"
	_style_game_over_button(lobby_button, Color(0.16, 0.25, 0.34), Color(0.07, 0.12, 0.18), Color(0.92, 0.98, 1.0), 22)
	lobby_button.pressed.connect(_return_to_lobby)
	box.add_child(lobby_button)


func _panel_style(bg: Color, border: Color, use_texture: bool = true) -> StyleBox:
	if use_texture and ui_panel_skin != null:
		var texture_style := StyleBoxTexture.new()
		texture_style.texture = ui_panel_skin
		texture_style.region_rect = PANEL_SKIN_SOURCE_RECT
		texture_style.modulate_color = Color(1.0, 1.0, 1.0, LOBBY_PANEL_SKIN_ALPHA)
		texture_style.draw_center = true
		texture_style.set_texture_margin(SIDE_LEFT, PANEL_SKIN_SLICE_MARGINS.x)
		texture_style.set_texture_margin(SIDE_TOP, PANEL_SKIN_SLICE_MARGINS.y)
		texture_style.set_texture_margin(SIDE_RIGHT, PANEL_SKIN_SLICE_MARGINS.z)
		texture_style.set_texture_margin(SIDE_BOTTOM, PANEL_SKIN_SLICE_MARGINS.w)
		texture_style.content_margin_left = 16
		texture_style.content_margin_right = 16
		texture_style.content_margin_top = 12
		texture_style.content_margin_bottom = 12
		return texture_style

	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = Color(border.r, border.g, border.b, minf(border.a, UI_PANEL_BORDER_ALPHA))
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.24)
	style.shadow_size = 5
	style.shadow_offset = Vector2(0.0, 3.0)
	return style


func _core_orb_style(accent: Color, glint: bool = false) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	if glint:
		style.bg_color = accent
		style.border_color = Color(1.0, 1.0, 1.0, 0.0)
		style.set_border_width_all(0)
		style.shadow_color = Color(1.0, 1.0, 1.0, 0.12)
		style.shadow_size = 2
	else:
		style.bg_color = Color(accent.r * 0.38, accent.g * 0.42, accent.b * 0.48, 0.8)
		style.border_color = Color(accent.r, accent.g, accent.b, 0.82)
		style.set_border_width_all(2)
		style.shadow_color = Color(accent.r, accent.g, accent.b, 0.34)
		style.shadow_size = 9
	style.set_corner_radius_all(30)
	return style


func _button_style(bg: Color, force_flat: bool = false) -> StyleBox:
	if ui_button_skin != null and not force_flat:
		var texture_style := StyleBoxTexture.new()
		texture_style.texture = ui_button_skin
		texture_style.region_rect = BUTTON_SKIN_SOURCE_RECT
		texture_style.modulate_color = Color(1.0, 1.0, 1.0, LOBBY_BUTTON_SKIN_ALPHA)
		texture_style.draw_center = true
		texture_style.set_texture_margin(SIDE_LEFT, 120.0)
		texture_style.set_texture_margin(SIDE_TOP, 70.0)
		texture_style.set_texture_margin(SIDE_RIGHT, 120.0)
		texture_style.set_texture_margin(SIDE_BOTTOM, 70.0)
		texture_style.content_margin_left = 18
		texture_style.content_margin_right = 18
		texture_style.content_margin_top = 10
		texture_style.content_margin_bottom = 10
		return texture_style

	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = Color(0.46, 0.92, 1.0, UI_FLAT_BUTTON_BORDER_ALPHA)
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.24)
	style.shadow_size = 5
	style.shadow_offset = Vector2(0.0, 3.0)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	return style


func _game_over_button_style(bg: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(bg.r, bg.g, bg.b, 0.96)
	style.border_color = Color(border.r, border.g, border.b, UI_PROMINENT_BUTTON_BORDER_ALPHA)
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.32)
	style.shadow_size = 5
	style.shadow_offset = Vector2(0.0, 3.0)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style


func _style_game_over_button(button: Button, bg: Color, border: Color, font_color: Color, font_size: int = 21) -> void:
	button.custom_minimum_size = Vector2(548.0, 56.0)
	button.focus_mode = Control.FOCUS_NONE
	button.clip_text = true
	button.add_theme_font_size_override("font_size", font_size)
	button.add_theme_color_override("font_color", font_color)
	button.add_theme_color_override("font_hover_color", font_color)
	button.add_theme_color_override("font_pressed_color", font_color.darkened(0.08))
	button.add_theme_color_override("font_shadow_color", Color(1.0, 1.0, 1.0, 0.28) if font_color.v < 0.5 else Color(0.0, 0.0, 0.0, 0.65))
	button.add_theme_constant_override("shadow_offset_x", 1)
	button.add_theme_constant_override("shadow_offset_y", 1)
	_apply_ui_font(button)
	button.add_theme_stylebox_override("normal", _game_over_button_style(bg, border))
	button.add_theme_stylebox_override("hover", _game_over_button_style(bg.lightened(0.08), border.lightened(0.12)))
	button.add_theme_stylebox_override("pressed", _game_over_button_style(bg.darkened(0.16), border.darkened(0.08)))


func _transparent_button_style(tint: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = tint
	style.border_color = Color(1.0, 1.0, 1.0, 0.0)
	style.set_border_width_all(0)
	style.set_corner_radius_all(8)
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style


func _upgrade_choice_style(upgrade_id: String, state: String = "normal") -> StyleBox:
	var accent := _upgrade_accent(upgrade_id)
	var bg := Color(0.045, 0.095, 0.13, 0.94)
	if state == "hover":
		bg = Color(0.07, 0.16, 0.2, 0.98)
	elif state == "pressed":
		bg = Color(0.03, 0.07, 0.1, 0.98)
	var style := _panel_style(bg, Color(accent.r, accent.g, accent.b, UI_CHOICE_BUTTON_BORDER_ALPHA), false)
	style.set_corner_radius_all(10)
	style.shadow_color = Color(accent.r, accent.g, accent.b, 0.10)
	style.shadow_size = 7
	style.shadow_offset = Vector2(0.0, 3.0)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	return style


func _level_reroll_style(state: String = "normal") -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.24, 0.42, 0.92)
	if state == "hover":
		style.bg_color = Color(0.16, 0.34, 0.58, 0.96)
	elif state == "pressed":
		style.bg_color = Color(0.08, 0.16, 0.3, 0.98)
	style.border_color = Color(0.42, 0.9, 1.0, UI_CHOICE_BUTTON_BORDER_ALPHA)
	style.set_border_width_all(1)
	style.set_corner_radius_all(10)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.34)
	style.shadow_size = 8
	style.shadow_offset = Vector2(0.0, 3.0)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style


func _upgrade_accent(upgrade_id: String) -> Color:
	match upgrade_id:
		"bolt":
			return Color(0.34, 0.92, 1.0)
		"missile":
			return Color(1.0, 0.64, 0.18)
		"pulse":
			return Color(0.46, 0.62, 1.0)
		"drone":
			return Color(1.0, 0.78, 0.24)
		"plasma", "solar_halo":
			return Color(1.0, 0.48, 0.18)
		"chain", "thunder_web", "capacitor_drone":
			return Color(1.0, 0.9, 0.22)
		"laser", "rail_prism", "targeting_drone", "photon_storm":
			return Color(0.56, 1.0, 0.9)
		"bomb", "cleanser_nova", "repair_drone":
			return Color(0.72, 0.52, 1.0)
		"shield_drone":
			return Color(0.42, 0.72, 1.0)
		"magnet_drone", "comet_battery":
			return Color(0.72, 0.48, 1.0)
		"magnet":
			return Color(0.68, 0.48, 1.0)
		"speed":
			return Color(0.28, 0.98, 0.72)
		"core":
			return Color(0.98, 0.46, 0.42)
		_:
			return Color(0.44, 0.92, 1.0)


func _upgrade_icon_texture(upgrade_id: String) -> Texture2D:
	match upgrade_id:
		"targeting_drone":
			return _drone_icon_texture("targeting")
		"capacitor_drone":
			return _drone_icon_texture("capacitor")
		"shield_drone":
			return _drone_icon_texture("shield")
		"magnet_drone":
			return _drone_icon_texture("magnet")
		"repair_drone":
			return _drone_icon_texture("repair")
		"photon_storm":
			return _evolution_icon_texture("photon_storm")
		"comet_battery":
			return _evolution_icon_texture("comet_battery")
		"solar_halo":
			return _evolution_icon_texture("solar_halo")
		"thunder_web":
			return _evolution_icon_texture("thunder_web")
		"rail_prism":
			return _evolution_icon_texture("rail_prism")
		"cleanser_nova":
			return _evolution_icon_texture("cleanser_nova")
	return upgrade_icon_textures.get(upgrade_id, null)


func _product_icon_texture(product_id: String) -> Texture2D:
	return product_icon_textures.get(product_id, null)


func _drone_icon_texture(drone_id: String) -> Texture2D:
	return drone_icon_textures.get(drone_id, null)


func _evolution_icon_texture(evolution_id: String) -> Texture2D:
	return evolution_icon_textures.get(evolution_id, null)


func _settings_icon_texture(setting_id: String) -> Texture2D:
	return settings_icon_textures.get(setting_id, null)


func _request_revive_ad() -> void:
	if not run_finished or revive_used:
		return
	_request_ad_reward(AD_REVIVE)


func _request_run_reward_2x_ad() -> void:
	if not run_finished or run_reward_doubled or last_run_reward <= 0:
		return
	_request_ad_reward(AD_RUN_REWARD_2X)


func _movement_vector() -> Vector2:
	if touch_vector.length_squared() > 0.02:
		return touch_vector.normalized()
	return Vector2.ZERO


func _update_touch_view() -> void:
	var active := touch_index != -1 or mouse_stick_active
	touch_stick.set_stick(active, touch_anchor, touch_current, TOUCH_MAX_DISTANCE)


func _touch_stick_base() -> Vector2:
	var view_size := get_viewport_rect().size
	return Vector2(TOUCH_STICK_BASE_X, view_size.y - TOUCH_STICK_BOTTOM_MARGIN)


func _is_touch_stick_position(screen_position: Vector2) -> bool:
	return screen_position.distance_to(_touch_stick_base()) <= TOUCH_STICK_START_RADIUS


func _arena_rect() -> Rect2:
	return Rect2(Vector2(-ARENA_HALF_WIDTH, -ARENA_HALF_HEIGHT), Vector2(ARENA_HALF_WIDTH * 2.0, ARENA_HALF_HEIGHT * 2.0))


func _clamp_to_arena(world_position: Vector2, margin: float = 0.0) -> Vector2:
	return Vector2(
		clampf(world_position.x, -ARENA_HALF_WIDTH + margin, ARENA_HALF_WIDTH - margin),
		clampf(world_position.y, -ARENA_HALF_HEIGHT + margin, ARENA_HALF_HEIGHT - margin)
	)


func _is_inside_arena(world_position: Vector2, margin: float = 0.0) -> bool:
	return (
		world_position.x >= -ARENA_HALF_WIDTH + margin
		and world_position.x <= ARENA_HALF_WIDTH - margin
		and world_position.y >= -ARENA_HALF_HEIGHT + margin
		and world_position.y <= ARENA_HALF_HEIGHT - margin
	)


func _clamp_player_to_arena() -> void:
	if player == null:
		return
	player.position = _clamp_to_arena(player.position, player.radius + ARENA_EDGE_PADDING)


func _camera_focus_position() -> Vector2:
	if player == null:
		return Vector2.ZERO
	var half_view := get_viewport_rect().size * 0.5
	var min_x := -ARENA_HALF_WIDTH + half_view.x
	var max_x := ARENA_HALF_WIDTH - half_view.x
	var min_y := -ARENA_HALF_HEIGHT + half_view.y
	var max_y := ARENA_HALF_HEIGHT - half_view.y
	if min_x > max_x:
		min_x = 0.0
		max_x = 0.0
	if min_y > max_y:
		min_y = 0.0
		max_y = 0.0
	return Vector2(
		clampf(player.global_position.x, min_x, max_x),
		clampf(player.global_position.y, min_y, max_y)
	)


func _update_camera_position() -> void:
	if camera != null:
		camera.global_position = _camera_focus_position()


func _update_spawns(delta: float) -> void:
	if elapsed_time >= 165.0 and not stage2_started:
		stage2_started = true
		current_stage = 2
		elite_timer = minf(elite_timer, 16.0)
		_show_banner("스테이지 2  솔라 벨트 진입")

	spawn_timer -= delta
	var interval := maxf(0.18, 0.82 - elapsed_time * 0.0021)
	if current_stage >= 2:
		interval = maxf(0.15, interval * 0.82)
	if spawn_timer <= 0.0 and enemies.size() < MAX_ENEMIES:
		spawn_timer = interval
		var batch := 1 + int(elapsed_time / 78.0)
		if current_stage >= 2:
			batch += 1
		for i in range(batch):
			_spawn_enemy(_pick_enemy_id())

	elite_timer -= delta
	if elite_timer <= 0.0:
		elite_timer = 42.0 if current_stage >= 2 else 48.0
		_spawn_enemy("stage2_elite_guard" if current_stage >= 2 else "elite_guard")
		_show_banner("엘리트 오염체 출현")

	if elapsed_time >= 150.0 and not boss_spawned:
		boss_spawned = true
		_spawn_enemy("boss_warden")
		_show_banner("보스 출현")
	if elapsed_time >= 250.0 and not stage2_boss_spawned:
		stage2_boss_spawned = true
		current_stage = 2
		_spawn_enemy("stage2_boss_solar_devourer")
		_show_banner("솔라 디바우러 출현")


func _pick_enemy_id() -> String:
	var roll := rng.randf()
	if current_stage >= 2:
		if roll < 0.26:
			return "stage2_solar_imp"
		if roll < 0.52:
			return "stage2_flare_chaser"
		if roll < 0.74:
			return "stage2_splitter"
		return "stage2_ember_tank"
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
	var spawn_position: Vector2 = _enemy_spawn_position()
	var enemy = EnemyScript.new()
	enemy.setup(enemy_defs[enemy_id], spawn_position)
	enemy.died.connect(_on_enemy_died)
	enemies.append(enemy)
	add_child(enemy)


func _enemy_spawn_position() -> Vector2:
	var best_position: Vector2 = _clamp_to_arena(player.position, ARENA_SPAWN_PADDING)
	var best_distance := -1.0
	for attempt in range(24):
		var angle := rng.randf_range(0.0, TAU)
		var distance := rng.randf_range(760.0, 920.0)
		var candidate: Vector2 = player.position + Vector2(cos(angle), sin(angle)) * distance
		if _is_inside_arena(candidate, ARENA_SPAWN_PADDING):
			return candidate
		var clamped: Vector2 = _clamp_to_arena(candidate, ARENA_SPAWN_PADDING)
		var distance_to_player: float = clamped.distance_squared_to(player.position)
		if distance_to_player > best_distance:
			best_distance = distance_to_player
			best_position = clamped
	return best_position


func _update_enemies(delta: float) -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.update_ai(player.position, delta)
			enemy.position = _clamp_to_arena(enemy.position, enemy.radius)


func _update_weapons(delta: float) -> void:
	bolt_timer -= delta
	if bolt_timer <= 0.0:
		var target = _nearest_enemy(player.position, 880.0)
		if target != null:
			bolt_timer = bolt_cooldown
			var direction: Vector2 = player.position.direction_to(target.position)
			_fire_projectile(player.position + direction * 58.0, direction, bolt_damage, 760.0, bolt_pierce, Color(0.36, 0.96, 1.0))

	if missile_level > 0:
		missile_timer -= delta
		if missile_timer <= 0.0:
			var missile_target = _nearest_enemy(player.position, 960.0)
			if missile_target != null:
				missile_timer = missile_cooldown
				_fire_missile(missile_target)

	if pulse_level > 0:
		pulse_timer -= delta
		if pulse_timer <= 0.0:
			pulse_timer = pulse_cooldown
			_fire_pulse()

	if plasma_level > 0:
		plasma_timer -= delta
		if plasma_timer <= 0.0:
			plasma_timer = plasma_cooldown
			_fire_plasma_ring()

	if chain_level > 0:
		chain_timer -= delta
		if chain_timer <= 0.0:
			var chain_target = _nearest_enemy(player.position, 780.0)
			if chain_target != null:
				chain_timer = chain_cooldown
				_fire_spark_chain(chain_target, chain_damage, chain_jumps, false)

	if laser_level > 0:
		laser_timer -= delta
		if laser_timer <= 0.0:
			var laser_target = _nearest_priority_enemy(player.position, 1120.0)
			if laser_target != null:
				laser_timer = laser_cooldown
				_fire_laser_lance(laser_target, laser_damage, 54.0, WEAPON_LASER_LANCE_SHEET, Color(0.55, 1.0, 0.86))

	if bomb_level > 0:
		bomb_timer -= delta
		if bomb_timer <= 0.0:
			var bomb_target = _nearest_enemy(player.position, 920.0)
			if bomb_target != null:
				bomb_timer = bomb_cooldown
				_fire_purge_bomb(bomb_target)

	if drone_level > 0:
		drone_timer -= delta
		if drone_timer <= 0.0:
			drone_timer = drone_cooldown
			for drone in drones:
				if is_instance_valid(drone) and bool(drone.can_attack):
					var target = _nearest_enemy(drone.position, 760.0)
					if target != null:
						var direction: Vector2 = drone.position.direction_to(target.position)
						_fire_projectile(drone.position + direction * 34.0, direction, drone_damage, 680.0, 0, Color(1.0, 0.82, 0.25))

	_update_evolution_weapons(delta)
	_update_support_effects(delta)


func _fire_projectile(spawn_position: Vector2, direction: Vector2, damage: float, speed: float, pierce: int, color: Color, sprite_path: String = PROJECTILE_BOLT_SHEET, projectile_kind: String = "bolt", hit_radius: float = 8.0, lifetime: float = 1.45, blast_radius: float = 0.0) -> void:
	if direction.length_squared() <= 0.001:
		return
	var projectile = ProjectileScript.new()
	projectile.z_index = 8
	projectile.setup(spawn_position, direction, damage, speed, pierce, color, sprite_path, projectile_kind, hit_radius, lifetime, blast_radius)
	projectile.expired.connect(_on_projectile_expired)
	projectiles.append(projectile)
	add_child(projectile)


func _on_projectile_expired(projectile) -> void:
	if projectile == null or not is_instance_valid(projectile):
		return
	if projectile.projectile_kind == "bomb" and projectile.explosion_radius > 0.0:
		_explode_projectile(projectile)


func _fire_missile(target) -> void:
	if target == null or not is_instance_valid(target):
		return
	var direction: Vector2 = player.position.direction_to(target.position)
	var spawn_offset := direction * 92.0
	var color := Color(0.25, 0.95, 1.0)
	_fire_projectile(player.position + spawn_offset, direction, missile_damage, 440.0, 0, color, PROJECTILE_COMET_MISSILE_SHEET, "missile", 22.0, 2.85, missile_blast_radius)


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


func _fire_plasma_ring() -> void:
	var radius := plasma_radius
	var damage := plasma_damage
	if solar_halo_level > 0:
		radius += 42.0
		damage *= 1.34
	var effect = SpriteSheetEffectScript.new()
	effect.setup(player.position, EVOLUTION_SOLAR_HALO_SHEET if solar_halo_level > 0 else WEAPON_PLASMA_RING_SHEET, 6, 4, Vector2(radius * 2.15, radius * 2.15), 0.42)
	add_child(effect)
	_damage_enemies_in_radius(player.position, radius, damage, player.position, Color(1.0, 0.56, 0.18))


func _fire_spark_chain(first_target, damage: float, jumps: int, thunder: bool) -> void:
	if first_target == null or not is_instance_valid(first_target):
		return
	var hit_ids := {}
	var current_position: Vector2 = player.position
	var target = first_target
	var max_jumps := jumps + (2 if thunder else 0)
	for i in range(max_jumps + 1):
		if target == null or not is_instance_valid(target):
			break
		var damage_scale := pow(0.86, float(i))
		var direction: Vector2 = current_position.direction_to(target.position)
		target.apply_damage(damage * damage_scale, direction)
		_spawn_beam_effect(current_position, target.position, EVOLUTION_THUNDER_WEB_SHEET if thunder else WEAPON_SPARK_CHAIN_SHEET, 0.22, Color(1.0, 0.96, 0.28))
		hit_ids[target.get_instance_id()] = true
		current_position = target.position
		if thunder and i == max_jumps:
			_spawn_sheet_effect(target.position, EVOLUTION_THUNDER_WEB_SHEET, Vector2(190.0, 190.0), 0.32)
			_damage_enemies_in_radius(target.position, 112.0 + float(capacitor_drone_level) * 18.0, damage * 0.82, target.position, Color(1.0, 0.9, 0.22))
		target = _nearest_enemy_excluding(current_position, 360.0 + float(chain_level) * 16.0, hit_ids)


func _fire_laser_lance(target, damage: float, width: float, sheet_path: String, color: Color) -> void:
	if target == null or not is_instance_valid(target):
		return
	var start: Vector2 = player.position
	var direction: Vector2 = start.direction_to(target.position)
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	var length := 1120.0 + float(laser_level + rail_prism_level) * 58.0
	var end: Vector2 = start + direction.normalized() * length
	_spawn_beam_effect(start + direction * 80.0, end, sheet_path, 0.34, color, 160.0)
	_damage_enemies_along_line(start, end, width, damage, direction)


func _fire_purge_bomb(target) -> void:
	if target == null or not is_instance_valid(target):
		return
	var direction: Vector2 = player.position.direction_to(target.position)
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	_fire_projectile(player.position + direction * 64.0, direction, bomb_damage, 360.0, 0, Color(0.72, 0.48, 1.0), WEAPON_PURGE_BOMB_SHEET, "bomb", 18.0, 2.2, bomb_radius)


func _update_evolution_weapons(delta: float) -> void:
	if photon_storm_level > 0:
		photon_storm_timer -= delta
		if photon_storm_timer <= 0.0:
			photon_storm_timer = 1.05
			_fire_photon_storm()
	if comet_battery_level > 0:
		comet_battery_timer -= delta
		if comet_battery_timer <= 0.0:
			comet_battery_timer = 2.45
			_fire_comet_battery()
	if solar_halo_level > 0:
		solar_halo_timer -= delta
		if solar_halo_timer <= 0.0:
			solar_halo_timer = maxf(0.38, plasma_cooldown * 0.72)
			_fire_plasma_ring()
	if thunder_web_level > 0:
		thunder_web_timer -= delta
		if thunder_web_timer <= 0.0:
			var target = _nearest_enemy(player.position, 820.0)
			if target != null:
				thunder_web_timer = 1.18
				_fire_spark_chain(target, maxf(chain_damage * 1.16, 42.0), maxi(chain_jumps, 5), true)
	if rail_prism_level > 0:
		rail_prism_timer -= delta
		if rail_prism_timer <= 0.0:
			var target = _nearest_priority_enemy(player.position, 1320.0)
			if target != null:
				rail_prism_timer = 2.05
				_fire_laser_lance(target, maxf(laser_damage * 1.55, 92.0), 72.0, EVOLUTION_RAIL_PRISM_SHEET, Color(0.68, 1.0, 0.96))
	if cleanser_nova_level > 0:
		cleanser_nova_timer -= delta
		if cleanser_nova_timer <= 0.0:
			cleanser_nova_timer = 7.8
			_fire_cleanser_nova()


func _update_support_effects(delta: float) -> void:
	if shield_drone_level > 0:
		shield_recharge_timer = maxf(0.0, shield_recharge_timer - delta)
		if shield_recharge_timer <= 0.0 and shield_hp < shield_max_hp:
			shield_hp = minf(shield_max_hp, shield_hp + (7.5 + shield_drone_level * 2.5) * delta)
	if repair_drone_level > 0 and player != null and player.hp < player.max_hp:
		repair_timer -= delta
		if repair_timer <= 0.0:
			repair_timer = maxf(1.6, 3.2 - repair_drone_level * 0.55)
			player.heal(5.0 + repair_drone_level * 4.0)
			_spawn_sheet_effect(player.position, DRONE_REPAIR_SHEET, Vector2(110.0, 110.0), 0.36, Color(0.72, 1.0, 0.76))


func _fire_photon_storm() -> void:
	var target = _nearest_priority_enemy(player.position, 1040.0)
	if target == null:
		return
	var base_direction: Vector2 = player.position.direction_to(target.position)
	var shots := 3 + targeting_drone_level
	for i in range(shots):
		var offset := 0.0 if shots == 1 else lerpf(-0.22, 0.22, float(i) / float(shots - 1))
		var direction := base_direction.rotated(offset)
		_fire_projectile(player.position + direction * 58.0, direction, bolt_damage * 0.92 + 16.0, 840.0, 3 + targeting_drone_level, Color(0.7, 1.0, 1.0), EVOLUTION_PHOTON_STORM_SHEET, "photon", 9.0, 1.0, 0.0)


func _fire_comet_battery() -> void:
	var drops := 4 + magnet_drone_level
	for i in range(drops):
		var target = _nearest_enemy(player.position, 680.0 + float(i) * 90.0)
		var position: Vector2 = player.position + Vector2.RIGHT.rotated(TAU * float(i) / float(drops)) * rng.randf_range(120.0, 360.0)
		if target != null and is_instance_valid(target):
			position = target.position + Vector2(rng.randf_range(-42.0, 42.0), rng.randf_range(-42.0, 42.0))
		_spawn_sheet_effect(position, EVOLUTION_COMET_BATTERY_SHEET, Vector2(210.0, 210.0), 0.42, Color(1.0, 0.8, 0.38))
		_damage_enemies_in_radius(position, 108.0, missile_damage * 0.72, position, Color(1.0, 0.72, 0.26))


func _fire_cleanser_nova() -> void:
	var radius := 230.0 + float(cleanser_nova_level) * 42.0 + float(repair_drone_level) * 24.0
	_spawn_sheet_effect(player.position, EVOLUTION_CLEANSER_NOVA_SHEET, Vector2(radius * 2.1, radius * 2.1), 0.64, Color(0.72, 1.0, 1.0))
	_damage_enemies_in_radius(player.position, radius, maxf(bomb_damage * 0.9, 88.0), player.position, Color(0.72, 1.0, 1.0))
	player.heal(10.0 + repair_drone_level * 6.0)


func _nearest_enemy_excluding(origin: Vector2, max_distance: float, hit_ids: Dictionary):
	var best = null
	var best_distance := max_distance * max_distance
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		if hit_ids.has(enemy.get_instance_id()):
			continue
		var distance := origin.distance_squared_to(enemy.position)
		if distance < best_distance:
			best = enemy
			best_distance = distance
	return best


func _spawn_sheet_effect(effect_position: Vector2, sheet_path: String, draw_size: Vector2, duration: float, tint: Color = Color.WHITE) -> void:
	var effect = SpriteSheetEffectScript.new()
	effect.setup(effect_position, sheet_path, 6, 4, draw_size, duration, tint)
	add_child(effect)


func _spawn_beam_effect(start: Vector2, end: Vector2, sheet_path: String, duration: float, tint: Color, thickness: float = 118.0) -> void:
	var segment := end - start
	if segment.length_squared() <= 0.001:
		return
	var effect = SpriteSheetEffectScript.new()
	effect.setup(start + segment * 0.5, sheet_path, 6, 4, Vector2(segment.length(), thickness), duration, tint)
	effect.rotation = segment.angle()
	add_child(effect)


func _damage_enemies_in_radius(origin: Vector2, radius: float, damage: float, knockback_origin: Vector2, color: Color) -> void:
	var ring = EffectRingScript.new()
	ring.lifetime = 0.32
	ring.setup(origin, radius, color)
	add_child(ring)
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		var distance: float = origin.distance_to(enemy.position)
		if distance <= radius + enemy.radius:
			var falloff := clampf(1.0 - distance / maxf(1.0, radius), 0.42, 1.0)
			var direction: Vector2 = knockback_origin.direction_to(enemy.position)
			enemy.apply_damage(damage * falloff, direction)


func _damage_enemies_along_line(start: Vector2, end: Vector2, width: float, damage: float, direction: Vector2) -> void:
	var segment := end - start
	var segment_len_sq := maxf(1.0, segment.length_squared())
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		var t := clampf((enemy.position - start).dot(segment) / segment_len_sq, 0.0, 1.0)
		var closest := start + segment * t
		if enemy.position.distance_to(closest) <= width + enemy.radius:
			enemy.apply_damage(damage, direction)


func _update_projectiles() -> void:
	for projectile in projectiles:
		if not is_instance_valid(projectile):
			continue
		if not _is_inside_arena(projectile.position, -320.0):
			projectile.queue_free()
			continue
		for enemy in enemies:
			if not is_instance_valid(enemy):
				continue
			if not projectile.can_hit(enemy):
				continue
			var hit_radius: float = projectile.radius + enemy.radius
			if projectile.position.distance_squared_to(enemy.position) <= hit_radius * hit_radius:
				if projectile.explosion_radius > 0.0:
					_explode_projectile(projectile)
				else:
					enemy.apply_damage(projectile.damage, projectile.velocity)
				projectile.register_hit(enemy)
				if projectile.is_queued_for_deletion():
					break


func _explode_projectile(projectile) -> void:
	if projectile == null or not is_instance_valid(projectile):
		return
	var blast_radius: float = projectile.explosion_radius
	var blast_color := Color(0.22, 0.92, 1.0)
	var effect = EffectRingScript.new()
	effect.lifetime = 0.46
	effect.setup(projectile.position, blast_radius, blast_color)
	add_child(effect)
	if projectile.projectile_kind == "missile":
		var sprite_effect = SpriteSheetEffectScript.new()
		var explosion_size := Vector2(blast_radius * 2.7, blast_radius * 1.55)
		sprite_effect.setup(projectile.position, FX_COMET_EXPLOSION_SHEET, 7, 2, explosion_size, 0.48)
		add_child(sprite_effect)
	elif projectile.projectile_kind == "bomb":
		_spawn_sheet_effect(projectile.position, FX_PURGE_BOMB_EXPLOSION_SHEET, Vector2(blast_radius * 2.15, blast_radius * 2.15), 0.56, Color(0.82, 0.62, 1.0))

	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		var distance: float = projectile.position.distance_to(enemy.position)
		if distance > blast_radius + enemy.radius:
			continue
		var falloff := clampf(1.0 - distance / maxf(1.0, blast_radius), 0.38, 1.0)
		var direction: Vector2 = projectile.position.direction_to(enemy.position)
		if direction.length_squared() <= 0.001:
			direction = projectile.velocity.normalized()
		enemy.apply_damage(projectile.damage * falloff, direction)

	if projectile.projectile_kind == "missile" and missile_fragments > 0:
		for i in range(missile_fragments):
			var angle := TAU * (float(i) / float(missile_fragments)) + rng.randf_range(-0.14, 0.14)
			var direction := Vector2.RIGHT.rotated(angle)
			_fire_projectile(projectile.position, direction, projectile.damage * 0.26, 660.0, 0, Color(1.0, 0.78, 0.24), PROJECTILE_COMET_FRAGMENT_SHEET, "fragment", 7.0, 0.72, 0.0)


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
			if _try_absorb_with_shield(enemy.damage):
				var push: Vector2 = enemy.position.direction_to(player.position)
				player.position += push * 18.0
				enemy.position -= push * 12.0
				continue
			if player.take_damage(enemy.damage):
				var push: Vector2 = enemy.position.direction_to(player.position)
				player.position += push * 28.0
				enemy.position -= push * 18.0


func _try_absorb_with_shield(amount: float) -> bool:
	if shield_drone_level <= 0 or shield_hp <= 0.0:
		return false
	shield_hp = maxf(0.0, shield_hp - amount)
	shield_recharge_timer = 2.4
	var effect = EffectRingScript.new()
	effect.lifetime = 0.24
	effect.setup(player.position, player.radius + 38.0, Color(0.38, 0.74, 1.0))
	add_child(effect)
	return true


func _update_drones(delta: float) -> void:
	for drone in drones:
		if is_instance_valid(drone):
			drone.update_orbit(delta)
			drone.position = _clamp_to_arena(drone.position, 28.0)
	for drone in support_drones:
		if is_instance_valid(drone):
			drone.update_orbit(delta)
			drone.position = _clamp_to_arena(drone.position, 28.0)


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


func _nearest_priority_enemy(origin: Vector2, max_distance: float):
	var best_boss = null
	var best_boss_distance := max_distance * max_distance
	var best = null
	var best_distance := max_distance * max_distance
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		var distance := origin.distance_squared_to(enemy.position)
		if enemy.enemy_type == "boss" and distance < best_boss_distance:
			best_boss = enemy
			best_boss_distance = distance
		if distance < best_distance:
			best = enemy
			best_distance = distance
	return best_boss if best_boss != null else best


func _on_enemy_died(enemy) -> void:
	kills += 1
	_spawn_xp(enemy.position, enemy.xp_value)
	if enemy.enemy_type == "boss":
		_show_banner("보스 정화 완료")


func _spawn_xp(spawn_position: Vector2, value: int) -> void:
	if gems.size() >= MAX_GEMS:
		return
	var gem = ExperienceGemScript.new()
	var gem_position: Vector2 = _clamp_to_arena(spawn_position + Vector2(rng.randf_range(-16.0, 16.0), rng.randf_range(-16.0, 16.0)), 18.0)
	gem.setup(gem_position, value)
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
	title.text = "레벨 업"
	title.add_theme_font_size_override("font_size", 29)
	_apply_ui_font(title)
	title.add_theme_color_override("font_color", Color(1.0, 0.96, 0.62))
	title.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.75))
	title.add_theme_constant_override("shadow_offset_x", 2)
	title.add_theme_constant_override("shadow_offset_y", 2)
	upgrade_list.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "정화 방향을 선택하면 즉시 이번 런에 반영됩니다."
	subtitle.add_theme_font_size_override("font_size", 16)
	_apply_ui_font(subtitle)
	subtitle.add_theme_color_override("font_color", Color(0.68, 0.84, 0.92))
	subtitle.custom_minimum_size = Vector2(588.0, 30.0)
	upgrade_list.add_child(subtitle)

	var reroll_button := Button.new()
	reroll_button.text = "광고 보고 선택지 다시 뽑기"
	reroll_button.custom_minimum_size = Vector2(588.0, 54.0)
	reroll_button.add_theme_font_size_override("font_size", 19)
	_apply_ui_font(reroll_button)
	reroll_button.icon = reroll_icon
	reroll_button.expand_icon = true
	reroll_button.add_theme_constant_override("h_separation", 12)
	reroll_button.add_theme_stylebox_override("normal", _level_reroll_style("normal"))
	reroll_button.add_theme_stylebox_override("hover", _level_reroll_style("hover"))
	reroll_button.add_theme_stylebox_override("pressed", _level_reroll_style("pressed"))
	reroll_button.add_theme_color_override("font_color", Color(0.93, 0.98, 1.0))
	reroll_button.add_theme_color_override("font_hover_color", Color.WHITE)
	reroll_button.add_theme_color_override("font_pressed_color", Color(0.82, 0.95, 1.0))
	reroll_button.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.65))
	reroll_button.add_theme_constant_override("shadow_offset_x", 1)
	reroll_button.add_theme_constant_override("shadow_offset_y", 2)
	reroll_button.pressed.connect(_request_level_reroll_ad)
	upgrade_list.add_child(reroll_button)

	var choices := _roll_upgrade_choices()
	for choice in choices:
		var upgrade_id := str(choice["id"])
		var current_level := int(upgrade_levels.get(upgrade_id, 0))
		var button := Button.new()
		button.text = "%s  Lv.%d>%d\n%s" % [choice["title"], current_level, current_level + 1, choice["desc"]]
		button.custom_minimum_size = Vector2(588.0, 124.0)
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.icon = _upgrade_icon_texture(upgrade_id)
		button.expand_icon = true
		button.add_theme_constant_override("h_separation", 16)
		button.add_theme_font_size_override("font_size", 20)
		_apply_ui_font(button)
		button.add_theme_stylebox_override("normal", _upgrade_choice_style(upgrade_id))
		button.add_theme_stylebox_override("hover", _upgrade_choice_style(upgrade_id, "hover"))
		button.add_theme_stylebox_override("pressed", _upgrade_choice_style(upgrade_id, "pressed"))
		button.add_theme_color_override("font_color", Color(0.9, 0.98, 1.0))
		button.add_theme_color_override("font_hover_color", Color.WHITE)
		button.add_theme_color_override("font_pressed_color", Color(0.82, 0.98, 0.94))
		button.set_meta("upgrade_id", upgrade_id)
		button.pressed.connect(_on_upgrade_button_pressed.bind(button))
		upgrade_list.add_child(button)


func _roll_upgrade_choices() -> Array:
	var candidates: Array = []
	for upgrade in upgrade_defs:
		var upgrade_id := str(upgrade["id"])
		if not _can_offer_upgrade(upgrade_id):
			continue
		if int(upgrade_levels.get(upgrade_id, 0)) < int(upgrade["max"]):
			candidates.append(upgrade)

	var priority_choice := {}
	if int(upgrade_levels.get("missile", 0)) <= 1:
		for i in range(candidates.size()):
			if str(candidates[i]["id"]) == "missile":
				priority_choice = candidates[i]
				candidates.remove_at(i)
				break

	candidates.shuffle()
	var choices: Array = []
	if not priority_choice.is_empty():
		choices.append(priority_choice)
	for candidate in candidates:
		if choices.size() >= 3:
			break
		choices.append(candidate)
	return choices


func _can_offer_upgrade(upgrade_id: String) -> bool:
	if _is_weapon_upgrade(upgrade_id) and not _is_weapon_unlocked(upgrade_id):
		return false
	if _is_evolution_upgrade(upgrade_id):
		return _evolution_requirements_met(upgrade_id)
	return true


func _is_evolution_upgrade(upgrade_id: String) -> bool:
	return [
		"photon_storm",
		"comet_battery",
		"solar_halo",
		"thunder_web",
		"rail_prism",
		"cleanser_nova"
	].has(upgrade_id)


func _evolution_requirements_met(upgrade_id: String) -> bool:
	match upgrade_id:
		"photon_storm":
			return int(upgrade_levels.get("bolt", 0)) >= 5 and targeting_drone_level >= 2
		"comet_battery":
			return int(upgrade_levels.get("missile", 0)) >= 5 and magnet_drone_level >= 2
		"solar_halo":
			return int(upgrade_levels.get("plasma", 0)) >= 5 and shield_drone_level >= 2
		"thunder_web":
			return int(upgrade_levels.get("chain", 0)) >= 5 and capacitor_drone_level >= 2
		"rail_prism":
			return int(upgrade_levels.get("laser", 0)) >= 5 and targeting_drone_level >= 2
		"cleanser_nova":
			return int(upgrade_levels.get("bomb", 0)) >= 5 and repair_drone_level >= 2
	return false


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


func _set_missile_level(next_level: int) -> void:
	missile_level = next_level
	missile_damage = 72.0 * pow(1.32, float(missile_level - 1))
	missile_blast_radius = 96.0 + missile_level * 18.0
	missile_cooldown = maxf(1.45, 3.05 - missile_level * 0.24)
	missile_fragments = maxi(0, missile_level - 3) * 2


func _apply_upgrade(upgrade_id: String) -> void:
	var next_level := int(upgrade_levels.get(upgrade_id, 0)) + 1
	upgrade_levels[upgrade_id] = next_level

	match upgrade_id:
		"bolt":
			bolt_level = next_level
			bolt_damage = 22.0 * pow(1.33, float(bolt_level - 1))
			bolt_cooldown = maxf(0.18, 0.52 * pow(0.92, float(bolt_level - 1)))
			bolt_pierce = int((bolt_level - 1) / 3)
		"missile":
			_set_missile_level(next_level)
			missile_timer = minf(missile_timer, 0.28)
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
		"plasma":
			plasma_level = next_level
			plasma_damage = 12.0 + plasma_level * 7.0
			plasma_radius = 82.0 + plasma_level * 14.0
			plasma_cooldown = maxf(0.42, 0.82 - plasma_level * 0.045)
			plasma_timer = minf(plasma_timer, 0.12)
		"chain":
			chain_level = next_level
			chain_damage = 18.0 + chain_level * 8.0 + capacitor_drone_level * 5.0
			chain_jumps = 2 + int(chain_level / 2) + capacitor_drone_level
			chain_cooldown = maxf(0.62, 1.34 - chain_level * 0.075 - capacitor_drone_level * 0.08)
			chain_timer = minf(chain_timer, 0.18)
		"laser":
			laser_level = next_level
			laser_damage = 48.0 + laser_level * 18.0 + targeting_drone_level * 10.0
			laser_cooldown = maxf(0.95, 2.18 - laser_level * 0.14 - targeting_drone_level * 0.08)
			laser_timer = minf(laser_timer, 0.22)
		"bomb":
			bomb_level = next_level
			bomb_damage = 68.0 + bomb_level * 24.0
			bomb_radius = 112.0 + bomb_level * 18.0
			bomb_cooldown = maxf(1.65, 3.45 - bomb_level * 0.18)
			bomb_timer = minf(bomb_timer, 0.32)
		"targeting_drone":
			targeting_drone_level = next_level
			bolt_pierce += 1
			laser_damage += 10.0
			_sync_support_drones()
		"capacitor_drone":
			capacitor_drone_level = next_level
			bolt_cooldown = maxf(0.14, bolt_cooldown * 0.92)
			missile_cooldown = maxf(1.2, missile_cooldown * 0.94)
			chain_cooldown = maxf(0.58, chain_cooldown * 0.9)
			_sync_support_drones()
		"shield_drone":
			shield_drone_level = next_level
			shield_max_hp = 36.0 + shield_drone_level * 28.0
			shield_hp = shield_max_hp
			shield_recharge_timer = 0.0
			_sync_support_drones()
		"magnet_drone":
			magnet_drone_level = next_level
			magnet_radius += 68.0
			_sync_support_drones()
		"repair_drone":
			repair_drone_level = next_level
			repair_timer = 0.2
			_sync_support_drones()
		"photon_storm":
			photon_storm_level = next_level
			photon_storm_timer = 0.1
		"comet_battery":
			comet_battery_level = next_level
			comet_battery_timer = 0.25
			magnet_radius += 90.0
		"solar_halo":
			solar_halo_level = next_level
			solar_halo_timer = 0.1
			if plasma_level <= 0:
				plasma_level = 1
				plasma_damage = 22.0
				plasma_radius = 100.0
		"thunder_web":
			thunder_web_level = next_level
			thunder_web_timer = 0.2
		"rail_prism":
			rail_prism_level = next_level
			rail_prism_timer = 0.2
		"cleanser_nova":
			cleanser_nova_level = next_level
			cleanser_nova_timer = 0.2
		"magnet":
			magnet_radius = 145.0 + next_level * 56.0 + magnet_drone_level * 68.0 + comet_battery_level * 90.0
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


func _sync_support_drones() -> void:
	for drone in support_drones:
		if is_instance_valid(drone):
			drone.queue_free()
	support_drones.clear()
	var configs := []
	if targeting_drone_level > 0:
		configs.append({"kind": "targeting", "level": targeting_drone_level, "path": DRONE_TARGETING_SHEET})
	if capacitor_drone_level > 0:
		configs.append({"kind": "capacitor", "level": capacitor_drone_level, "path": DRONE_CAPACITOR_SHEET})
	if shield_drone_level > 0:
		configs.append({"kind": "shield", "level": shield_drone_level, "path": DRONE_SHIELD_SHEET})
	if magnet_drone_level > 0:
		configs.append({"kind": "magnet", "level": magnet_drone_level, "path": DRONE_MAGNET_SHEET})
	if repair_drone_level > 0:
		configs.append({"kind": "repair", "level": repair_drone_level, "path": DRONE_REPAIR_SHEET})
	for i in range(configs.size()):
		var config: Dictionary = configs[i]
		var drone = DroneScript.new()
		var angle := TAU * float(i) / maxf(1.0, float(configs.size())) + 0.36
		drone.setup(player, angle, int(config["level"]), str(config["path"]), str(config["kind"]), false)
		drone.orbit_radius = 102.0 + float(i % 2) * 12.0
		drone.orbit_speed = 1.55 + float(i) * 0.08
		support_drones.append(drone)
		add_child(drone)


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
	game_over_backdrop.visible = true
	game_over_panel.visible = true
	last_run_reward = int(kills * RUN_REWARD_PER_KILL) + level * RUN_REWARD_PER_LEVEL
	if cleared:
		last_run_reward += RUN_CLEAR_BONUS
	run_reward_awarded = last_run_reward
	meta_currency += run_reward_awarded
	_save_game()
	_update_lobby_ui()
	_update_game_over_panel()
	_maybe_show_run_end_interstitial()


func _maybe_show_run_end_interstitial() -> void:
	run_end_interstitial_counter += 1
	_save_game()
	if _has_remove_ads():
		return
	if ad_service == null:
		return
	pending_run_end_interstitial = true
	if ad_service.show_interstitial(AD_RUN_END_5TH):
		pending_run_end_interstitial = false


func _has_remove_ads() -> bool:
	return _is_product_owned(BillingServiceScript.PRODUCT_REMOVE_ADS)


func _has_monthly_pass() -> bool:
	return monthly_pass_active or _is_product_owned(BillingServiceScript.PRODUCT_MONTHLY_SUPPLY_PASS)


func _update_game_over_panel() -> void:
	var result := "정화 완료" if last_run_cleared else "코어 붕괴"
	var minutes := int(elapsed_time) / 60
	var seconds := int(elapsed_time) % 60
	var bonus_text := ""
	if run_reward_doubled:
		bonus_text = "\n광고 2배 보상 적용 완료"
	game_over_label.text = "%s\n생존 %02d:%02d  정화 %d\n도달 레벨 %d  획득 파편 %d%s\n\n로비에서 강화 후 다시 도전하세요." % [result, minutes, seconds, kills, level, run_reward_awarded, bonus_text]
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
	_save_game()
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
	game_over_backdrop.visible = false
	game_over_panel.visible = false
	player.hp = player.max_hp * 0.6
	_clear_enemies_near_player(320.0)
	_save_game()
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
	for i in range(support_drones.size() - 1, -1, -1):
		if not is_instance_valid(support_drones[i]) or support_drones[i].is_queued_for_deletion():
			support_drones.remove_at(i)
