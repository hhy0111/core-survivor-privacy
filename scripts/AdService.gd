extends Node

signal reward_granted(placement: String)
signal ad_loaded(placement: String)
signal ad_failed(placement: String, message: String)
signal ad_closed(placement: String)

const PLACEMENT_DAILY_BONUS := "daily_bonus"
const PLACEMENT_FREE_CHEST := "free_chest"
const PLACEMENT_LEVEL_REROLL := "level_reroll"
const PLACEMENT_REVIVE := "revive"
const PLACEMENT_RUN_REWARD_2X := "run_reward_2x"
const PLACEMENT_TEMP_DRONE := "temp_drone"

const PLUGIN_NAME := "CoreSurvivorAdMob"

var _plugin
var _initialized := false


func initialize() -> void:
	if _initialized:
		return
	_initialized = true
	if Engine.has_singleton(PLUGIN_NAME):
		_plugin = Engine.get_singleton(PLUGIN_NAME)
		_connect_plugin_signal("ad_loaded", _on_plugin_ad_loaded)
		_connect_plugin_signal("ad_failed_to_load", _on_plugin_ad_failed_to_load)
		_connect_plugin_signal("ad_rewarded", _on_plugin_ad_rewarded)
		_connect_plugin_signal("ad_closed", _on_plugin_ad_closed)
		_connect_plugin_signal("ad_failed_to_show", _on_plugin_ad_failed_to_show)
		_plugin.preloadAllRewarded()


func is_available() -> bool:
	return _plugin != null


func is_ready(placement: String) -> bool:
	if _plugin == null:
		return false
	return bool(_plugin.isRewardedReady(placement))


func request_reward(placement: String) -> bool:
	if _plugin == null:
		ad_failed.emit(placement, "AdMob Android 플러그인이 현재 실행 환경에 없습니다.")
		return false
	if not bool(_plugin.isRewardedReady(placement)):
		_plugin.loadRewarded(placement)
		ad_failed.emit(placement, "광고를 불러오는 중입니다. 잠시 후 다시 시도하세요.")
		return false
	_plugin.showRewarded(placement)
	return true


func preload_placement(placement: String) -> void:
	if _plugin != null:
		_plugin.loadRewarded(placement)


func _connect_plugin_signal(signal_name: String, callable: Callable) -> void:
	if _plugin.has_signal(signal_name) and not _plugin.is_connected(signal_name, callable):
		_plugin.connect(signal_name, callable)


func _on_plugin_ad_loaded(placement: String) -> void:
	ad_loaded.emit(placement)


func _on_plugin_ad_failed_to_load(placement: String, message: String) -> void:
	ad_failed.emit(placement, message)


func _on_plugin_ad_rewarded(placement: String) -> void:
	reward_granted.emit(placement)


func _on_plugin_ad_closed(placement: String) -> void:
	ad_closed.emit(placement)


func _on_plugin_ad_failed_to_show(placement: String, message: String) -> void:
	ad_failed.emit(placement, message)
