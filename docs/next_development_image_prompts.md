# Core Survivor: Cosmic Purge - Next Development Image Prompts

Purpose: standalone prompt list for images that are still needed for later gameplay content. Existing applied assets are intentionally excluded.

## Global Art Rules

Use these rules with every prompt below unless a prompt says otherwise.

```text
Core Survivor: Cosmic Purge, premium 2D cartoon sci-fi mobile game art, top-down readable silhouette, cute but dangerous SD proportions, polished commercial mobile game quality, dark cosmic palette with cyan purification light and selective orange/purple/yellow accents, clean sharp alpha edge, centered subject, no text, no letters, no numbers, no watermark, no logo, no UI labels, no checkerboard background, no cropped body parts, no duplicated malformed objects, readable on a small Android screen.
```

Sprite sheet layout rules:

```text
Transparent PNG sprite sheet. Each frame must be the same size, evenly spaced on a strict grid, no gaps between cells, no frame labels. Keep the animated object centered in each cell with at least 20 percent safe padding. The object must not touch the cell edge. Keep scale and pivot consistent across all frames.
```

Icon layout rules:

```text
512x512 transparent PNG icon, single object centered, 18 percent safe padding, no text, no numbers, no border, readable at 64x64, strong silhouette, polished highlight and shadow.
```

Background layout rules:

```text
1080x1920 vertical mobile background, no text, no UI, clean central gameplay readability, visual interest stronger near the edges, safe center area for player and enemies.
```

## Priority 1 - Unimplemented Weapons

### `assets/images/weapon_plasma_ring_sheet.png`

```text
Create a transparent PNG sprite sheet for a rotating Plasma Ring weapon.
Size 2048x512, grid 8 columns x 2 rows, 16 frames total, each cell 256x256.
Show a circular orange plasma ring orbit effect, cyan purification sparks on the rim, warm orange core energy, rotating clockwise over frames. The ring must look like a close-range defensive aura around the player but without the player character. Keep the ring centered and fully visible in every frame.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/upgrade_plasma_icon.png`

```text
Create a 512x512 transparent PNG upgrade icon for Plasma Ring.
Show a bright orange circular plasma ring with cyan purification sparks, defensive close-range aura feeling, no character, no text.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/weapon_spark_chain_sheet.png`

```text
Create a transparent PNG sprite sheet for a Spark Chain weapon.
Size 2048x512, grid 8 columns x 2 rows, 16 frames total, each cell 256x256.
Show yellow electric chain lightning arcing from left to right, with 2 to 4 branch points and cyan purification particles. Animation should build from small spark, stretch into a chain zap, then fade into small electric fragments. Keep the beam readable and not too thin.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/upgrade_chain_icon.png`

```text
Create a 512x512 transparent PNG upgrade icon for Spark Chain.
Show a yellow electric chain bolt connecting three small cyan energy nodes, high contrast, no text.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/weapon_laser_lance_sheet.png`

```text
Create a transparent PNG sprite sheet for a Laser Lance weapon.
Size 2048x512, grid 8 columns x 2 rows, 16 frames total, each cell 256x256.
Show a piercing cyan-green laser lance beam effect, narrow bright core, soft teal outer glow, small charging flare at the left side and sharp spear-like energy tip to the right. Animation should charge, fire, sustain, and fade. Keep the beam inside the frame and not cropped.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/upgrade_laser_icon.png`

```text
Create a 512x512 transparent PNG upgrade icon for Laser Lance.
Show a cyan-green spear-shaped laser beam crossing diagonally, bright piercing core, small lens flare, no text.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/weapon_purge_bomb_sheet.png`

```text
Create a transparent PNG sprite sheet for a Purge Bomb projectile.
Size 2048x256, grid 8 columns x 1 row, 8 frames total, each cell 256x256.
Show a purple purification bomb capsule with cyan glowing seams, tiny warning sparks, and a short floating pulse. Animation should show idle spin and energy buildup. Keep the bomb centered and fully visible in every frame.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/weapon_purge_bomb_explosion_sheet.png`

```text
Create a transparent PNG sprite sheet for a Purge Bomb explosion.
Size 2048x512, grid 8 columns x 2 rows, 16 frames total, each cell 256x256.
Show a wide purple-cyan purification blast expanding into a circular cleansing field, bright center flash, soft outer shockwave, tiny cosmic debris dissolving. Animation should start with a compact flash, expand, then leave a fading circular field. Keep the full blast inside each cell.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/upgrade_bomb_icon.png`

```text
Create a 512x512 transparent PNG upgrade icon for Purge Bomb.
Show a purple sci-fi bomb capsule with cyan seams and a small circular purification blast behind it, no text.
Apply Global Art Rules and Icon Layout Rules.
```

## Priority 2 - Evolution Weapons

### `assets/images/evolution_photon_storm_sheet.png`

```text
Create a transparent PNG sprite sheet for Photon Storm evolved weapon.
Size 2048x512, grid 8 columns x 2 rows, 16 frames total, each cell 256x256.
Show three to five cyan-white piercing photon bolts spreading forward in a fan pattern, clean bright cores, small blue particles, premium evolved weapon intensity. Animation should pulse from charge to repeated piercing volleys.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/evolution_photon_storm_icon.png`

```text
Create a 512x512 transparent PNG evolution icon for Photon Storm.
Show a fan of cyan-white piercing photon bolts, premium evolved glow, no text.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/evolution_comet_battery_sheet.png`

```text
Create a transparent PNG sprite sheet for Comet Battery evolved weapon.
Size 2048x512, grid 8 columns x 2 rows, 16 frames total, each cell 256x256.
Show several small cyan-orange comet missiles orbiting a faint circular battery field, with tiny downward strike markers and magnetic pickup sparkles. Animation should rotate and pulse like an automated orbital battery.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/evolution_comet_battery_icon.png`

```text
Create a 512x512 transparent PNG evolution icon for Comet Battery.
Show three small comet missiles circling a cyan magnetic battery ring, orange exhaust sparks, no text.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/evolution_solar_halo_sheet.png`

```text
Create a transparent PNG sprite sheet for Solar Halo evolved weapon.
Size 2048x512, grid 8 columns x 2 rows, 16 frames total, each cell 256x256.
Show a double orange solar ring rotating around an empty center, cyan shield glints on the outer rim, warm golden flame highlights. Animation should feel protective but powerful, with two rings counter-rotating.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/evolution_solar_halo_icon.png`

```text
Create a 512x512 transparent PNG evolution icon for Solar Halo.
Show two bright orange solar rings with small cyan shield facets, no character, no text.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/evolution_thunder_web_sheet.png`

```text
Create a transparent PNG sprite sheet for Thunder Web evolved weapon.
Size 2048x512, grid 8 columns x 2 rows, 16 frames total, each cell 256x256.
Show a yellow electric web connecting multiple cyan nodes, with final-hit explosion sparks at one node. Animation should branch, connect, overload, then burst. Keep the web readable and not overly dense.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/evolution_thunder_web_icon.png`

```text
Create a 512x512 transparent PNG evolution icon for Thunder Web.
Show yellow lightning web between five cyan nodes, one node exploding with small sparks, no text.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/evolution_rail_prism_sheet.png`

```text
Create a transparent PNG sprite sheet for Rail Prism evolved weapon.
Size 2048x512, grid 8 columns x 2 rows, 16 frames total, each cell 256x256.
Show a long cyan rail laser refracted through a small prism crystal, with narrow white core, teal afterimage lines, and a boss-killer precision feeling. Animation should charge through the prism, fire a piercing line, then fade.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/evolution_rail_prism_icon.png`

```text
Create a 512x512 transparent PNG evolution icon for Rail Prism.
Show a cyan rail laser passing through a small crystal prism, sharp precision glow, no text.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/evolution_cleanser_nova_sheet.png`

```text
Create a transparent PNG sprite sheet for Cleanser Nova evolved weapon.
Size 2048x512, grid 8 columns x 2 rows, 16 frames total, each cell 256x256.
Show a large cyan-purple nova blast expanding outward, then leaving a clean circular purification zone with white sparkles and dissolving dark fragments. Animation should feel like emergency area control.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/evolution_cleanser_nova_icon.png`

```text
Create a 512x512 transparent PNG evolution icon for Cleanser Nova.
Show a cyan-purple nova explosion with a clean circular purification field, no text.
Apply Global Art Rules and Icon Layout Rules.
```

## Priority 3 - Advanced Drones

Drone sheet layout for all drone prompts:

```text
Size 1536x768, grid 6 columns x 3 rows, 18 frames total, each cell 256x256.
Row 1: idle hover loop. Row 2: active support or attack loop. Row 3: hit or overcharge reaction loop.
Transparent PNG, same drone scale and pivot in every frame.
```

### `assets/images/drone_targeting_sheet.png`

```text
Create a transparent PNG sprite sheet for a Targeting Drone.
Small cyan scout drone with a single glass lens, tiny antenna fins, thin target reticle glow, designed to help aimed shots. Row 1 idle hover, row 2 lens scanning beam, row 3 quick overcharge flicker. No text.
Apply Global Art Rules and Drone Sheet Layout.
```

### `assets/images/drone_targeting_icon.png`

```text
Create a 512x512 transparent PNG drone icon for Targeting Drone.
Show a cyan scout drone lens with a small target reticle glow, no text.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/drone_capacitor_sheet.png`

```text
Create a transparent PNG sprite sheet for a Capacitor Drone.
Small yellow electric support drone with twin coil wings and cyan battery core, designed for attack speed and chain lightning builds. Row 1 idle hover, row 2 electric charge pulses, row 3 overload flicker. No text.
Apply Global Art Rules and Drone Sheet Layout.
```

### `assets/images/drone_capacitor_icon.png`

```text
Create a 512x512 transparent PNG drone icon for Capacitor Drone.
Show a yellow coil drone with a cyan battery core and electric sparks, no text.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/drone_shield_sheet.png`

```text
Create a transparent PNG sprite sheet for a Shield Drone.
Small blue defensive drone with three curved barrier panels and a soft cyan shield aura, designed to support Solar Halo. Row 1 idle hover, row 2 shield projection pulse, row 3 cracked shield recovery. No text.
Apply Global Art Rules and Drone Sheet Layout.
```

### `assets/images/drone_shield_icon.png`

```text
Create a 512x512 transparent PNG drone icon for Shield Drone.
Show a blue drone projecting three curved cyan shield panels, no text.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/drone_magnet_sheet.png`

```text
Create a transparent PNG sprite sheet for a Magnet Drone.
Small purple magnetic collector drone with a crescent gravity ring and tiny blue gem sensor, designed to attract experience gems. Row 1 idle hover, row 2 magnetic pull ripple, row 3 gravity surge reaction. No text.
Apply Global Art Rules and Drone Sheet Layout.
```

### `assets/images/drone_magnet_icon.png`

```text
Create a 512x512 transparent PNG drone icon for Magnet Drone.
Show a purple collector drone with a crescent gravity ring pulling a tiny blue gem, no text.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/drone_repair_sheet.png`

```text
Create a transparent PNG sprite sheet for a Repair Drone.
Small green-cyan medical repair drone with soft cross-shaped light motif but no literal text symbol, tiny repair arm, gentle healing particles. Row 1 idle hover, row 2 healing beam pulse, row 3 repair spark recovery. No text.
Apply Global Art Rules and Drone Sheet Layout.
```

### `assets/images/drone_repair_icon.png`

```text
Create a 512x512 transparent PNG drone icon for Repair Drone.
Show a green-cyan repair drone with a small healing light and repair arm, no text.
Apply Global Art Rules and Icon Layout Rules.
```

## Priority 4 - Stage 2 Content Pack

### `assets/images/stage2_background.png`

```text
Create a 1080x1920 vertical mobile game background for Stage 2, Corrupted Solar Belt.
Dark space arena with warm orange asteroid belt, distant solar flare cracks near the edges, cyan purification traces, clean central gameplay area, no text, no UI. The mood should contrast Stage 1 by feeling warmer and more dangerous while still matching the existing cosmic style.
Apply Global Art Rules and Background Layout Rules.
```

### `assets/images/stage2_far_heat_layer.png`

```text
Create a transparent 1080x1920 parallax layer for Stage 2.
Sparse orange heat particles, tiny ember sparks, faint distant solar dust, mostly transparent center, no text.
Apply Global Art Rules.
```

### `assets/images/stage2_asteroid_layer.png`

```text
Create a transparent 1080x1920 parallax layer for Stage 2.
Warm brown-orange asteroid chunks around the edges, varied sizes, no large objects in the center, clean alpha, no text.
Apply Global Art Rules.
```

### `assets/images/stage2_solar_crack_layer.png`

```text
Create a transparent 1080x1920 parallax overlay for Stage 2.
Orange solar crack decals, ember streaks, corrupted light veins near edges, center mostly clear for gameplay, no text.
Apply Global Art Rules.
```

### `assets/images/enemy_stage2_solar_imp_sheet.png`

```text
Create a transparent PNG sprite sheet for Stage 2 Solar Imp enemy.
Size 1536x1024, grid 6 columns x 4 rows, 24 frames total, each cell 256x256.
Small corrupted orange solar creature, cute aggressive face, tiny flame horns, dark shell spots. Rows: idle drift, chase, hit reaction, dissolve death. Keep full body centered with 24 percent padding.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/enemy_stage2_flare_chaser_sheet.png`

```text
Create a transparent PNG sprite sheet for Stage 2 Flare Chaser enemy.
Size 1536x1024, grid 6 columns x 4 rows, 24 frames total, each cell 256x256.
Fast orange-red comet-like monster with small fins, bright flame tail, mischievous face, clear forward direction. Rows: idle, dash chase, hit reaction, dissolve death. Keep full body centered.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/enemy_stage2_ember_tank_sheet.png`

```text
Create a transparent PNG sprite sheet for Stage 2 Ember Tank enemy.
Size 1536x1024, grid 6 columns x 4 rows, 24 frames total, each cell 256x256.
Bulky corrupted ember monster, dark cracked armor, glowing orange core belly, heavy silhouette, slow durable enemy. Rows: idle, heavy walk, hit reaction, dissolve death. Keep all armor and limbs inside frame.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/enemy_stage2_splitter_sheet.png`

```text
Create a transparent PNG sprite sheet for Stage 2 Splitter enemy.
Size 1536x1024, grid 6 columns x 4 rows, 24 frames total, each cell 256x256.
Medium orange solar blob monster with visible crack lines suggesting it can split, two smaller inner sparks, cute corrupted face. Rows: idle wobble, chase, split reaction, dissolve death. Full body centered.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/enemy_stage2_elite_guard_sheet.png`

```text
Create a transparent PNG sprite sheet for Stage 2 Elite Guard enemy.
Size 1536x1024, grid 6 columns x 4 rows, 24 frames total, each cell 256x256.
Larger elite corrupted solar guard, shield-like lava arms, yellow warning accents, dark armor shell, stronger than normal enemies. Rows: idle, shielded advance, hit reaction, dissolve death. Keep 24 percent padding.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/enemy_stage2_boss_solar_devourer_sheet.png`

```text
Create a transparent PNG boss sprite sheet for Stage 2 Solar Devourer.
Size 2048x1024, grid 8 columns x 4 rows, 32 frames total, each cell 256x256.
Giant corrupted orange star beast, dark solar shell, flame crown, cute but threatening boss expression, thick readable silhouette. Rows: idle breathing, charge attack, hit reaction, defeated dissolve. Keep boss centered with 18 percent padding and never cropped on any side.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/boss_stage2_flame_wave_sheet.png`

```text
Create a transparent PNG sprite sheet for Stage 2 boss flame wave attack.
Size 2048x512, grid 8 columns x 2 rows, 16 frames total, each cell 256x256.
Orange-yellow flame wave sweep, dark red corrupted edges, clear danger shape, readable on mobile. Animation should charge, sweep, and dissipate.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/boss_stage2_meteor_impact_sheet.png`

```text
Create a transparent PNG sprite sheet for Stage 2 boss meteor impact.
Size 2048x512, grid 8 columns x 2 rows, 16 frames total, each cell 256x256.
Falling orange meteor marker, impact flash, circular fire burst, dark debris dissolving into cyan purification sparks. Keep the full impact inside frame.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

### `assets/images/boss_stage2_solar_laser_sheet.png`

```text
Create a transparent PNG sprite sheet for Stage 2 boss solar laser.
Size 2048x512, grid 8 columns x 2 rows, 16 frames total, each cell 256x256.
Orange solar laser beam with bright yellow core and red warning edge, charge flare at the left, piercing beam to the right, no cropping.
Apply Global Art Rules and Sprite Sheet Layout Rules.
```

## Priority 5 - Shop And Settings Icons

### `assets/images/shop_remove_ads_icon.png`

```text
Create a 512x512 transparent PNG shop product icon for Remove Ads Pack.
Show a cute cyan cosmic core behind a clean shield blocking small abstract ad cards. Premium quality, non-pay-to-win feeling, no text, no money symbols.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/shop_monthly_pass_icon.png`

```text
Create a 512x512 transparent PNG shop product icon for Monthly Supply Pass.
Show a glowing supply capsule with daily reward gems and small cyan calendar-like light blocks, no numbers, no text, premium but clean.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/settings_sound_icon.png`

```text
Create a 512x512 transparent PNG settings icon for sound.
Show a simple cyan sci-fi speaker glyph with small wave arcs, polished mobile game style, no text.
Apply Global Art Rules and Icon Layout Rules.
```

### `assets/images/settings_haptic_icon.png`

```text
Create a 512x512 transparent PNG settings icon for haptic vibration.
Show a small cyan smartphone controller shape with subtle vibration arcs and cosmic sparks, no text.
Apply Global Art Rules and Icon Layout Rules.
```

## Recommended Generation Order

1. Generate Priority 1 weapon sheets and icons first.
2. Generate Priority 3 drone sheets and icons next because evolution recipes depend on drone identity.
3. Generate Priority 2 evolution sheets and icons after the base weapon and drone visuals are approved.
4. Generate Priority 4 Stage 2 pack when Stage 2 gameplay implementation starts.
5. Generate Priority 5 shop/settings icons only when the related UI screens need final polish.
