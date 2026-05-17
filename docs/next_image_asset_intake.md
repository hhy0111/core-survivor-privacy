# Next Image Asset Intake

This checklist is for applying images generated from `docs/next_development_image_prompts.md`.

## 1. Save Files

Save generated PNG files directly under `assets/images/` using the exact filenames from the prompt document.

Keep source files out of the Android build if they are not final runtime assets. Only final PNGs that the game should load belong in `assets/images/`.

## 2. Basic Asset Rules

Before connecting any image in code, reject or regenerate files with these issues:

- visible checkerboard background instead of real alpha
- text, letters, numbers, watermark, or UI labels baked into gameplay sprites
- object cropped by the cell edge
- inconsistent frame scale or pivot across animation frames
- sprite sheet grid that does not match the requested columns and rows
- icons that are unreadable at small size

## 3. Normalize Runtime Sprite Sheets

After final sprite sheets are placed in `assets/images/`, run:

```powershell
.\tools\normalize_sprite_sheets.ps1 -IncludeNextContent
```

This keeps existing normalization behavior and adds the future weapon, evolution, drone, and stage 2 sheets only when this option is used.

Use normalized runtime paths in gameplay code when available:

```text
res://assets/images/normalized/<file_name>.png
```

Use direct paths for backgrounds, UI skins, and icons:

```text
res://assets/images/<file_name>.png
```

## 4. First Code Connection Order

Connect assets in this order:

1. Priority 1 weapon icons to level-up and weapon codex UI.
2. Priority 1 weapon sheets to runtime attacks.
3. Advanced drone icons and sheets to codex, shop, and drone runtime variants.
4. Evolution icons and sheets after base weapon/drone behavior is connected.
5. Stage 2 background layers, then stage 2 enemies, then stage 2 boss attacks.

## 5. Asset Mapping Summary

Runtime sheets that should normally use `assets/images/normalized/`:

```text
weapon_plasma_ring_sheet.png
weapon_spark_chain_sheet.png
weapon_laser_lance_sheet.png
weapon_purge_bomb_sheet.png
weapon_purge_bomb_explosion_sheet.png
evolution_photon_storm_sheet.png
evolution_comet_battery_sheet.png
evolution_solar_halo_sheet.png
evolution_thunder_web_sheet.png
evolution_rail_prism_sheet.png
evolution_cleanser_nova_sheet.png
drone_targeting_sheet.png
drone_capacitor_sheet.png
drone_shield_sheet.png
drone_magnet_sheet.png
drone_repair_sheet.png
enemy_stage2_solar_imp_sheet.png
enemy_stage2_flare_chaser_sheet.png
enemy_stage2_ember_tank_sheet.png
enemy_stage2_splitter_sheet.png
enemy_stage2_elite_guard_sheet.png
enemy_stage2_boss_solar_devourer_sheet.png
boss_stage2_flame_wave_sheet.png
boss_stage2_meteor_impact_sheet.png
boss_stage2_solar_laser_sheet.png
```

Direct-load images:

```text
upgrade_plasma_icon.png
upgrade_chain_icon.png
upgrade_laser_icon.png
upgrade_bomb_icon.png
evolution_photon_storm_icon.png
evolution_comet_battery_icon.png
evolution_solar_halo_icon.png
evolution_thunder_web_icon.png
evolution_rail_prism_icon.png
evolution_cleanser_nova_icon.png
drone_targeting_icon.png
drone_capacitor_icon.png
drone_shield_icon.png
drone_magnet_icon.png
drone_repair_icon.png
stage2_background.png
stage2_far_heat_layer.png
stage2_asteroid_layer.png
stage2_solar_crack_layer.png
shop_remove_ads_icon.png
shop_monthly_pass_icon.png
settings_sound_icon.png
settings_haptic_icon.png
```
