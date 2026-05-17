extends Node

signal billing_ready
signal billing_error(message: String)
signal product_loaded(product_id: String, product_type: String, title: String, price: String)
signal product_unavailable(product_id: String, reason: String)
signal purchase_completed(product_id: String, purchase_token: String)
signal purchase_pending(product_id: String)
signal purchase_cancelled(product_id: String)
signal purchase_failed(product_id: String, message: String)
signal purchase_restored(product_id: String, purchase_token: String)

const PRODUCT_REMOVE_ADS := "remove_ads"
const PRODUCT_STARTER_CORE_PACK := "starter_core_pack"
const PRODUCT_PREMIUM_CORE_SKIN_PACK := "premium_core_skin_pack"
const PRODUCT_SPECIAL_DRONE_PACK := "special_drone_pack"
const PRODUCT_GROWTH_SHARD_PACK := "growth_shard_pack"
const PRODUCT_MONTHLY_SUPPLY_PASS := "monthly_supply_pass"

const PLUGIN_NAME := "CoreSurvivorBilling"

var _plugin
var _initialized := false
var products := {}
var owned_products := {}


func initialize() -> void:
	if _initialized:
		return
	_initialized = true
	if Engine.has_singleton(PLUGIN_NAME):
		_plugin = Engine.get_singleton(PLUGIN_NAME)
		_connect_plugin_signal("billing_ready", _on_billing_ready)
		_connect_plugin_signal("billing_error", _on_billing_error)
		_connect_plugin_signal("product_details", _on_product_details)
		_connect_plugin_signal("product_unavailable", _on_product_unavailable)
		_connect_plugin_signal("purchase_completed", _on_purchase_completed)
		_connect_plugin_signal("purchase_pending", _on_purchase_pending)
		_connect_plugin_signal("purchase_cancelled", _on_purchase_cancelled)
		_connect_plugin_signal("purchase_failed", _on_purchase_failed)
		_connect_plugin_signal("purchase_restored", _on_purchase_restored)
		_plugin.initializeBilling()


func is_available() -> bool:
	return _plugin != null


func is_ready() -> bool:
	return _plugin != null and bool(_plugin.isReady())


func query_products() -> void:
	if _plugin != null:
		_plugin.queryProducts()


func restore_purchases() -> void:
	if _plugin != null:
		owned_products.erase(PRODUCT_MONTHLY_SUPPLY_PASS)
		_plugin.restorePurchases()


func purchase(product_id: String) -> bool:
	if _plugin == null:
		purchase_failed.emit(product_id, "Google Play Billing plugin is not available in this build.")
		return false
	_plugin.purchase(product_id)
	return true


func get_product_price(product_id: String) -> String:
	if products.has(product_id):
		return str(products[product_id].get("price", ""))
	if _plugin != null:
		return str(_plugin.getProductPrice(product_id))
	return ""


func is_owned(product_id: String) -> bool:
	return bool(owned_products.get(product_id, false))


func _connect_plugin_signal(signal_name: String, callable: Callable) -> void:
	if _plugin.has_signal(signal_name) and not _plugin.is_connected(signal_name, callable):
		_plugin.connect(signal_name, callable)


func _on_billing_ready() -> void:
	billing_ready.emit()


func _on_billing_error(message: String) -> void:
	billing_error.emit(message)


func _on_product_details(product_id: String, product_type: String, title: String, price: String) -> void:
	products[product_id] = {
		"type": product_type,
		"title": title,
		"price": price
	}
	product_loaded.emit(product_id, product_type, title, price)


func _on_product_unavailable(product_id: String, reason: String) -> void:
	product_unavailable.emit(product_id, reason)


func _on_purchase_completed(product_id: String, purchase_token: String) -> void:
	if product_id != PRODUCT_GROWTH_SHARD_PACK:
		owned_products[product_id] = true
	purchase_completed.emit(product_id, purchase_token)


func _on_purchase_pending(product_id: String) -> void:
	purchase_pending.emit(product_id)


func _on_purchase_cancelled(product_id: String) -> void:
	purchase_cancelled.emit(product_id)


func _on_purchase_failed(product_id: String, message: String) -> void:
	purchase_failed.emit(product_id, message)


func _on_purchase_restored(product_id: String, purchase_token: String) -> void:
	if product_id != PRODUCT_GROWTH_SHARD_PACK:
		owned_products[product_id] = true
	purchase_restored.emit(product_id, purchase_token)
