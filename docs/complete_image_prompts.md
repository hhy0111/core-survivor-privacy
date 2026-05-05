# Core Survivor: Cosmic Purge 전체 이미지 프롬프트 카탈로그

목표: 게임 개발부터 Google Play 출시까지 필요한 모든 이미지 제작 프롬프트를 한 문서에 모은다. 모든 인게임 이미지는 **2D 만화풍 / SD 캐주얼 / 모바일 가독성 / 자르기 쉬운 투명 배경**을 기준으로 한다.

이 문서의 수량 기준은 **이미지 생성 1회 = 이미지 파일 1장 또는 스프라이트시트 1장**이다. 전체 권장 제작 수량은 **174장**이다.

## 공통 사용 규칙

### 공통 스프라이트 스타일

아래 문구를 캐릭터, 적, 드론, 아이템, UI 아이콘 프롬프트 뒤에 붙인다.

```text
2D cartoon mobile game asset, cute SD proportions, polished commercial casual game quality, bold clean outline, bright saturated colors, strong readable silhouette for small phone screens, top-down 3/4 view, no text, no letters, no watermark, no logo, transparent background, isolated object, centered, full object visible, 18% empty padding around the asset, clean alpha edge, no cropped parts, no overlapping parts, game-ready sprite
```

### 공통 애니메이션 시트 규칙

```text
sprite sheet, animation frames arranged left to right, equal frame size, same scale and anchor position in every frame, 64px spacing between frames, transparent background, no grid lines, no labels, easy to cut into individual frames
```

### 공통 이펙트 규칙

```text
2D cartoon mobile game VFX sprite sheet, bright readable effect, transparent background, additive glow style, clean alpha, no character, no text, no watermark, frames arranged left to right, equal frame size, 64px spacing, no cropped glow, easy to cut
```

### 공통 배경 규칙

```text
high quality 2D cartoon top-down mobile game background, portrait 1080x1920, no characters, no UI, no text, dark readable central play area, decorative details pushed toward edges, clear contrast for cyan player bullets, pink orange enemies, blue XP gems, polished commercial casual game quality
```

### 네거티브 프롬프트

```text
3D render, realistic, photorealistic, pixel art, anime cutscene, dark unreadable silhouette, muddy colors, noisy texture, text, letters, watermark, logo, cropped object, cut off edges, white background, black background for sprites, overlapping frames, inconsistent frame size, inconsistent character scale, motion blur outside frame, UI text baked into image
```

## 1. 실행/출시/스토어 이미지 9장

| 파일명 | 프롬프트 |
|---|---|
| `marketing/title_key_art_1080x1920.png` | `premium 2D cartoon mobile game title screen key art, cute glowing cosmic core hero in the center, corrupted space monsters surrounding from the edges, huge cyan purification energy burst, dynamic diagonal action composition, bright but readable, leave clean empty space at top 25 percent for game title UI, leave bottom 20 percent for start button UI, portrait 1080x1920, no text, no logo, no watermark, polished commercial casual game splash art` |
| `marketing/loading_background_1080x1920.png` | `2D cartoon cosmic loading background, clean dark navy space, subtle teal nebula, small floating corrupted particles around edges, center kept simple and readable, no logo, no text, no progress bar, portrait 1080x1920, polished mobile game quality` |
| `marketing/google_play_feature_1024x500.png` | `Google Play feature graphic for a high quality 2D cartoon survivor-like mobile game, cute cosmic core hero blasting purification energy, enemies flying outward, bright teal cyan and pink orange contrast, horizontal 1024x500 composition, leave safe empty area on left 30 percent for store text added later, no baked text, no logo, no watermark` |
| `marketing/app_icon_512.png` | `2D cartoon mobile game app icon, cute glowing teal cosmic core face, dark navy rounded square background, cyan aura, small yellow purification sparks, simple readable at tiny size, centered, no text, no logo, 512x512, polished commercial app icon` |
| `marketing/adaptive_icon_foreground_432.png` | `transparent foreground asset for Android adaptive icon, cute teal cosmic core mascot face with cyan aura and yellow sparks, centered, full object visible, no background, no text, no logo, 432x432, clean alpha edge` |
| `marketing/adaptive_icon_background_432.png` | `Android adaptive icon background, dark navy cosmic gradient, subtle teal nebula ring, no character, no text, no logo, 432x432, clean polished mobile game icon background` |
| `marketing/store_screenshot_frame_1080x1920.png` | `2D cartoon mobile game promotional screenshot frame, dark cosmic border, cyan energy corner ornaments, empty transparent center for gameplay screenshot, no text, no logo, portrait 1080x1920, clean alpha edge, polished store presentation frame` |
| `marketing/social_square_1080.png` | `square promotional key art for 2D cartoon survivor mobile game, cute cosmic core hero, wave of corrupted enemies, cyan purification explosion, high energy composition, 1080x1080, no text, no logo, leave center-right readable for optional title overlay` |
| `marketing/reward_ad_end_card_1080x1920.png` | `reward ad end card background, 2D cartoon cosmic style, cute core hero holding glowing reward chest, dark clean background, empty top area for CTA text added in engine, no baked text, portrait 1080x1920, polished mobile ad quality` |

## 2. 플레이어 코어 18장

각 프롬프트 뒤에 `공통 스프라이트 스타일`과 `공통 애니메이션 시트 규칙`을 붙인다. 각 시트는 **4행 구성**으로 만든다: 1행 idle 6프레임, 2행 move 6프레임, 3행 hit 4프레임, 4행 evolve glow 6프레임.

| 파일명 | 프롬프트 |
|---|---|
| `core/purify_stage_0_sheet.png` | `purification core stage 0, small round teal living energy sphere mascot, happy face, soft cyan aura, beginner form, 4-row animation sprite sheet` |
| `core/purify_stage_1_sheet.png` | `purification core stage 1, teal living core mascot with tiny white halo fragments, brighter clean aura, 4-row animation sprite sheet` |
| `core/purify_stage_2_sheet.png` | `purification core stage 2, cyan white purification core with small wing-like energy fins, confident cute face, 4-row animation sprite sheet` |
| `core/purify_stage_3_sheet.png` | `purification core stage 3, glowing holy cyan core with clean circular halo, white spark particles, 4-row animation sprite sheet` |
| `core/purify_stage_4_sheet.png` | `purification core stage 4, advanced purification core, radiant teal white aura, elegant wing fins, stronger silhouette, 4-row animation sprite sheet` |
| `core/purify_stage_5_sheet.png` | `purification core final stage, premium angelic cosmic purification core, large cyan halo ring, bright white teal energy, heroic cute face, 4-row animation sprite sheet` |
| `core/attack_stage_0_sheet.png` | `attack core stage 0, small round orange red plasma core mascot, determined face, tiny flame sparks, 4-row animation sprite sheet` |
| `core/attack_stage_1_sheet.png` | `attack core stage 1, red orange plasma core with small energy crown, sharper outline, 4-row animation sprite sheet` |
| `core/attack_stage_2_sheet.png` | `attack core stage 2, fiery combat core with flame fins and yellow hot center, confident expression, 4-row animation sprite sheet` |
| `core/attack_stage_3_sheet.png` | `attack core stage 3, explosive red orange combat core, comet aura, sharp flame crown, 4-row animation sprite sheet` |
| `core/attack_stage_4_sheet.png` | `attack core stage 4, advanced solar attack core, strong flame ring and intense yellow highlights, 4-row animation sprite sheet` |
| `core/attack_stage_5_sheet.png` | `attack core final stage, premium solar nova core mascot, powerful red orange aura, heroic battle expression, 4-row animation sprite sheet` |
| `core/absorb_stage_0_sheet.png` | `absorption core stage 0, small round violet blue gravity core mascot, calm face, tiny orbiting dot, 4-row animation sprite sheet` |
| `core/absorb_stage_1_sheet.png` | `absorption core stage 1, purple blue magnetic core with small orbit ring, calm cute expression, 4-row animation sprite sheet` |
| `core/absorb_stage_2_sheet.png` | `absorption core stage 2, gravity core with two orbiting blue crystals, soft violet aura, 4-row animation sprite sheet` |
| `core/absorb_stage_3_sheet.png` | `absorption core stage 3, advanced magnetic core, dark violet ring, bright blue crystal satellites, 4-row animation sprite sheet` |
| `core/absorb_stage_4_sheet.png` | `absorption core stage 4, powerful gravity core, multiple orbiting shards, clean readable silhouette, 4-row animation sprite sheet` |
| `core/absorb_stage_5_sheet.png` | `absorption core final stage, premium cosmic singularity core mascot, purple blue gravity rings and crystal orbit, 4-row animation sprite sheet` |

## 3. 드론 6장

각 시트는 **3행 구성**: idle hover 6프레임, attack 6프레임, damaged flicker 4프레임.

| 파일명 | 프롬프트 |
|---|---|
| `drone/purify_laser_drone_sheet.png` | `cyan purification laser drone, cute compact floating mechanical orb, glowing lens, clean beam emitter, 3-row animation sprite sheet, ` |
| `drone/missile_pod_drone_sheet.png` | `orange missile pod drone, chunky cute floating support unit, mini rocket tubes, energetic combat look, 3-row animation sprite sheet, ` |
| `drone/magnet_collector_drone_sheet.png` | `purple magnet collector drone, gravity ring antenna, tiny crystal sensor, support unit for collecting energy gems, 3-row animation sprite sheet, ` |
| `drone/shield_drone_sheet.png` | `blue shield drone, small barrier panels, defensive floating orb, soft shield aura, 3-row animation sprite sheet, ` |
| `drone/spark_drone_sheet.png` | `yellow spark drone, electric coil body, fast zap emitter, playful but dangerous, 3-row animation sprite sheet, ` |
| `drone/healing_drone_sheet.png` | `green healing drone, soft medical light, plus-shaped energy motif without text, gentle floating support unit, 3-row animation sprite sheet, ` |

## 4. 일반 적 6장

각 시트는 **4행 구성**: idle 6프레임, chase 6프레임, hit 4프레임, death dissolve 6프레임.

| 파일명 | 프롬프트 |
|---|---|
| `enemy/normal_pink_slime_sheet.png` | `small pink corrupted pollution slime enemy, round body, angry eyes, cute but hostile, 4-row animation sprite sheet, ` |
| `enemy/normal_orange_comet_bug_sheet.png` | `fast orange corrupted comet bug enemy, small horns, speed fin silhouette, chase-focused enemy, 4-row animation sprite sheet, ` |
| `enemy/normal_purple_bulwark_sheet.png` | `purple armored corrupted blob enemy, heavy body, cracked shell, slow tank silhouette, 4-row animation sprite sheet, ` |
| `enemy/normal_cyan_splitter_sheet.png` | `cyan unstable splitter parasite enemy, double-core body, jittery corrupted energy, 4-row animation sprite sheet, ` |
| `enemy/normal_green_spore_sheet.png` | `green toxic spore corrupted enemy, floating gas sacs, poisonous cute monster, 4-row animation sprite sheet, ` |
| `enemy/normal_dark_crystal_crawler_sheet.png` | `dark blue crystal crawler corrupted enemy, jagged mineral legs, sharp but cartoon readable, 4-row animation sprite sheet, ` |

## 5. 엘리트 3장

각 시트는 **5행 구성**: idle 6프레임, move 6프레임, attack windup 6프레임, hit 4프레임, death 8프레임.

| 파일명 | 프롬프트 |
|---|---|
| `enemy/elite_guard_sheet.png` | `elite corrupted guard monster, bulky shield arms, yellow warning accents, larger than normal enemy, strong silhouette, 5-row animation sprite sheet, ` |
| `enemy/elite_charger_sheet.png` | `elite corrupted charger monster, orange rocket horns, heavy impact body, aggressive forward shape, 5-row animation sprite sheet, ` |
| `enemy/elite_summoner_sheet.png` | `elite corrupted summoner monster, floating purple mask body, orbiting dark spores, magical enemy silhouette, 5-row animation sprite sheet, ` |

## 6. 보스 12장

보스 캐릭터 시트는 **4행 구성**: idle 8프레임, move 8프레임, hit 4프레임, death 10프레임. 보스 공격 이펙트는 `공통 이펙트 규칙`을 붙인다.

| 파일명 | 프롬프트 |
|---|---|
| `boss/stage1_pollution_warden_sheet.png` | `Stage 1 boss Pollution Warden, giant round black pink corrupted planet monster, tentacle energy arms, cute but intimidating, 4-row boss animation sprite sheet, transparent background, 24% padding, no cropped tentacles` |
| `boss/stage1_attack_tentacle_slam_sheet.png` | `Stage 1 boss attack VFX, pink black tentacle slam telegraph and impact, 10 frames, clear red warning before hit, ` |
| `boss/stage1_attack_pollution_orbs_sheet.png` | `Stage 1 boss projectile VFX, pink pollution orb barrage, 8 frames, readable enemy bullet color, ` |
| `boss/stage1_attack_ring_pulse_sheet.png` | `Stage 1 boss expanding danger ring pulse, pink red circular shockwave, 10 frames, clear telegraph, ` |
| `boss/stage2_solar_devourer_sheet.png` | `Stage 2 boss Solar Devourer, giant corrupted orange star beast, flame crown, dark solar shell, cute but powerful, 4-row boss animation sprite sheet, transparent background, 24% padding` |
| `boss/stage2_attack_flame_wave_sheet.png` | `Stage 2 boss attack VFX, orange flame wave sweep, 10 frames, hot yellow center, red edge warning, ` |
| `boss/stage2_attack_meteor_drop_sheet.png` | `Stage 2 boss meteor impact VFX, falling marker and explosion, 10 frames, clear target circle, ` |
| `boss/stage2_attack_solar_laser_sheet.png` | `Stage 2 boss solar laser beam VFX, orange yellow beam charge and release, 12 frames, ` |
| `boss/stage3_void_queen_sheet.png` | `Stage 3 boss Void Queen Core, giant purple cosmic queen orb with crystal wings, elegant corrupted final boss, cute but intimidating, 4-row boss animation sprite sheet, transparent background, 24% padding` |
| `boss/stage3_attack_gravity_cross_sheet.png` | `Stage 3 boss attack VFX, purple gravity cross beams, 12 frames, clean telegraph lines, ` |
| `boss/stage3_attack_crystal_rain_sheet.png` | `Stage 3 boss crystal rain projectile VFX, violet shards falling markers and impacts, 10 frames, ` |
| `boss/stage3_attack_void_nova_sheet.png` | `Stage 3 boss ultimate void nova explosion, purple black expanding circular blast, 14 frames, bright edge, ` |

## 7. 무기/공격 이펙트 30장

각 프롬프트 뒤에 `공통 이펙트 규칙`을 붙인다.

| 파일명 | 프롬프트 |
|---|---|
| `vfx/weapon_purify_bolt_projectile_sheet.png` | `cyan purification bolt projectile, small fast energy bullet, 8 frames, bright white core, ` |
| `vfx/weapon_purify_bolt_impact_sheet.png` | `cyan purification bolt hit impact burst, 8 frames, small readable pop, ` |
| `vfx/weapon_pulse_wave_sheet.png` | `blue white pulse wave expanding circular shockwave, 10 frames, clean ring, ` |
| `vfx/weapon_pulse_impact_sheet.png` | `blue white knockback impact spark, 8 frames, ` |
| `vfx/weapon_plasma_slash_sheet.png` | `orange plasma slash arc projectile, 8 frames, curved blade-shaped energy, ` |
| `vfx/weapon_plasma_slash_impact_sheet.png` | `orange plasma slash hit sparks, 8 frames, ` |
| `vfx/weapon_chain_lightning_sheet.png` | `yellow chain lightning zap between targets, 8 frames, jagged readable cartoon electricity, ` |
| `vfx/weapon_chain_lightning_impact_sheet.png` | `yellow electric stun impact, 8 frames, ` |
| `vfx/weapon_gravity_mine_sheet.png` | `purple gravity mine activation, small circular mine pulsing then detonating, 10 frames, ` |
| `vfx/weapon_gravity_mine_impact_sheet.png` | `purple gravity implosion burst, 10 frames, inward spiral energy, ` |
| `vfx/weapon_cleansing_beam_sheet.png` | `green cyan cleansing spiral beam projectile, 10 frames, healing-clean energy style, ` |
| `vfx/weapon_cleansing_beam_impact_sheet.png` | `green cyan cleansing beam hit glow, 8 frames, ` |
| `vfx/weapon_meteor_orb_sheet.png` | `red orange meteor orb projectile, 8 frames, small comet trail, ` |
| `vfx/weapon_meteor_impact_sheet.png` | `red orange meteor impact explosion, 12 frames, ` |
| `vfx/weapon_arc_mine_sheet.png` | `blue yellow arc mine electrical trap, 10 frames, ` |
| `vfx/weapon_arc_mine_impact_sheet.png` | `blue yellow arc mine electric burst, 10 frames, ` |
| `vfx/evolved_nova_core_sheet.png` | `ultimate white cyan purification nova explosion, 14 frames, premium evolved weapon VFX, ` |
| `vfx/evolved_solar_lance_sheet.png` | `evolved orange solar lance piercing beam, 12 frames, premium weapon VFX, ` |
| `vfx/evolved_void_saw_sheet.png` | `evolved purple gravity saw spinning projectile, 12 frames, premium weapon VFX, ` |
| `vfx/evolved_chain_storm_sheet.png` | `evolved yellow electric chain storm, 12 frames, premium weapon VFX, ` |
| `vfx/evolved_drone_barrage_sheet.png` | `evolved multi drone barrage projectile trail, cyan yellow small missiles, 12 frames, ` |
| `vfx/evolved_healing_bloom_sheet.png` | `evolved green healing purification bloom aura, 12 frames, ` |
| `vfx/player_level_up_burst_sheet.png` | `player level up celebration burst, cyan gold circular particles, 10 frames, ` |
| `vfx/player_evolution_flash_sheet.png` | `player evolution transformation flash, teal white expanding aura, 14 frames, ` |
| `vfx/enemy_death_dust_sheet.png` | `corrupted enemy death dissolve dust, pink purple particles, 8 frames, ` |
| `vfx/boss_warning_aura_sheet.png` | `boss warning aura pulse, red black circular danger energy, 10 frames, ` |
| `vfx/shield_hit_sheet.png` | `blue shield hit ripple, 8 frames, ` |
| `vfx/heal_sparkle_sheet.png` | `green healing sparkle burst, 8 frames, ` |
| `vfx/magnet_pickup_trail_sheet.png` | `blue gem magnet pickup trail, small streak particles, 8 frames, ` |
| `vfx/revive_beam_sheet.png` | `gold cyan revive beam from above, 12 frames, ` |

## 8. 아이템/보상 12장

각 시트는 idle sparkle 6프레임이다. 공통 스프라이트 스타일과 공통 애니메이션 시트 규칙을 붙인다.

| 파일명 | 프롬프트 |
|---|---|
| `item/xp_blue_gem_sheet.png` | `blue diamond experience gem collectible, tiny sparkle, 6-frame idle animation, ` |
| `item/xp_large_gem_sheet.png` | `large blue cyan experience gem collectible, brighter shine, 6-frame idle animation, ` |
| `item/heal_orb_sheet.png` | `green healing orb collectible, soft heart-like glow without text, 6-frame idle animation, ` |
| `item/core_fragment_sheet.png` | `gold cyan core fragment currency, shiny broken crystal coin, 6-frame idle animation, ` |
| `item/rare_upgrade_crystal_sheet.png` | `purple rare upgrade crystal, premium sparkle, 6-frame idle animation, ` |
| `item/reward_chest_sheet.png` | `gold cosmic reward chest capsule, closed and idle sparkle, 6-frame idle animation, ` |
| `item/magnet_boost_sheet.png` | `purple magnet boost pickup, gravity ring icon object, 6-frame idle animation, ` |
| `item/shield_boost_sheet.png` | `blue shield boost pickup, small barrier emblem without text, 6-frame idle animation, ` |
| `item/bomb_pickup_sheet.png` | `red orange screen clear bomb pickup, cute energy bomb, 6-frame idle animation, ` |
| `item/revive_token_sheet.png` | `gold cyan revive token, small wing motif without text, 6-frame idle animation, ` |
| `item/reroll_token_sheet.png` | `teal reroll token, circular arrow motif without text, 6-frame idle animation, ` |
| `item/drone_battery_sheet.png` | `yellow drone battery pickup, compact energy cell, 6-frame idle animation, ` |

## 9. 스테이지/배경/레이어 18장

배경은 투명 배경을 쓰지 않는다. 파라ラック스/장식 레이어만 투명 배경을 사용한다.

| 파일명 | 프롬프트 |
|---|---|
| `background/stage1_clean_orbit_arena.png` | `Stage 1 Clean Orbit arena, dark blue space field, teal nebula dust, small clean star debris, subtle tileless top-down arena, ` |
| `background/stage1_far_stars_layer.png` | `transparent parallax layer, sparse far stars and tiny teal dust particles, 2D cartoon cosmic style, no background, no text, wide spacing` |
| `background/stage1_asteroid_layer.png` | `transparent parallax layer, small blue gray floating asteroids around edges, 2D cartoon style, no text, wide spacing, easy to layer` |
| `background/stage1_energy_ring_layer.png` | `transparent parallax layer, faint cyan energy rings and orbit lines, sparse, no text, clean alpha` |
| `background/stage1_boss_overlay.png` | `Stage 1 boss arena overlay, subtle pink corruption mist creeping from edges, transparent center, no text, 2D cartoon VFX layer` |
| `background/stage2_solar_belt_arena.png` | `Stage 2 Corrupted Solar Belt arena, dark warm space, orange asteroid field, lava-like cosmic cracks near edges, central play area clean, ` |
| `background/stage2_far_heat_layer.png` | `transparent parallax layer, faint orange heat particles and tiny sparks, sparse, clean alpha` |
| `background/stage2_asteroid_layer.png` | `transparent parallax layer, warm brown orange asteroid chunks around edges, no text, wide spacing` |
| `background/stage2_solar_crack_layer.png` | `transparent parallax layer, orange solar crack decals and ember streaks, edge-heavy, clean alpha` |
| `background/stage2_boss_overlay.png` | `Stage 2 boss arena overlay, orange solar flare danger haze around edges, transparent center, no text, 2D cartoon VFX layer` |
| `background/stage3_void_garden_arena.png` | `Stage 3 Void Garden arena, deep purple black cosmic space, crystal islands around edges, gravity rings, central play area readable, ` |
| `background/stage3_far_void_layer.png` | `transparent parallax layer, faint violet stars and distant black hole dust, sparse, clean alpha` |
| `background/stage3_crystal_layer.png` | `transparent parallax layer, purple blue crystal shards floating around edges, no text, wide spacing` |
| `background/stage3_gravity_ring_layer.png` | `transparent parallax layer, violet gravity rings and curved space lines, sparse, clean alpha` |
| `background/stage3_boss_overlay.png` | `Stage 3 boss arena overlay, purple void mist and crystal glow around edges, transparent center, no text, 2D cartoon VFX layer` |
| `background/menu_animated_layer_1.png` | `transparent animated menu background layer, slow floating teal stars and small particles, 6-frame sprite sheet, wide spacing, no text` |
| `background/menu_animated_layer_2.png` | `transparent animated menu background layer, corrupted pink clouds drifting at edges, 6-frame sprite sheet, wide spacing, no text` |
| `background/run_result_background.png` | `2D cartoon result screen background, dark cosmic cleanup scene, faint purified stars, center left readable for result UI, portrait 1080x1920, no text` |

## 10. UI 패널/버튼 18장

텍스트는 이미지에 넣지 않고 Godot UI 폰트로 올린다.

| 파일명 | 프롬프트 |
|---|---|
| `ui/title_start_button_9slice.png` | `2D cartoon mobile game UI button, cyan rounded rectangle, dark navy glass fill, bright teal border, transparent background, no text, 9-slice friendly, 40px padding` |
| `ui/title_secondary_button_9slice.png` | `2D cartoon mobile game secondary button, purple blue glass fill, soft border, transparent background, no text, 9-slice friendly, 40px padding` |
| `ui/levelup_card_9slice.png` | `level up selection card UI, dark navy glass panel, cyan outline, subtle cosmic corners, transparent background, no text, 9-slice friendly, 40px padding` |
| `ui/pause_panel_9slice.png` | `pause menu panel UI, dark navy rounded panel, cyan thin border, subtle stars, transparent background, no text, 9-slice friendly` |
| `ui/result_panel_9slice.png` | `run result panel UI, premium dark cosmic panel, gold cyan border, transparent background, no text, 9-slice friendly` |
| `ui/shop_panel_9slice.png` | `upgrade shop panel UI, dark glass sci-fi casual panel, teal border, transparent background, no text, 9-slice friendly` |
| `ui/reward_popup_9slice.png` | `reward chest popup frame, dark navy panel, gold cyan trim, transparent background, no text, 9-slice friendly` |
| `ui/boss_warning_banner_9slice.png` | `boss warning banner frame, red black danger frame, sharp but cartoon style, transparent background, no text, 9-slice friendly` |
| `ui/hp_bar_frame.png` | `health bar frame UI, rounded dark frame with green accent, transparent background, no text, 9-slice friendly` |
| `ui/xp_bar_frame.png` | `experience bar frame UI, rounded dark frame with blue accent, transparent background, no text, 9-slice friendly` |
| `ui/joystick_base.png` | `mobile virtual joystick base, transparent circular cyan outline, dark navy glass center, no text, transparent background` |
| `ui/joystick_knob.png` | `mobile virtual joystick knob, teal circular button, glossy cartoon style, no text, transparent background` |
| `ui/dialog_close_icon.png` | `small close button icon, cyan X symbol inside dark circular button, transparent background, no text except symbol shape` |
| `ui/reroll_button_icon.png` | `reroll button icon, teal circular arrow symbol inside dark round button, transparent background, no text` |
| `ui/revive_button_icon.png` | `revive button icon, gold cyan wing and core symbol inside dark round button, transparent background, no text` |
| `ui/ad_reward_badge.png` | `rewarded ad badge icon, small cyan video play triangle and gold reward spark, transparent background, no text` |
| `ui/locked_slot_overlay.png` | `locked slot overlay UI, dark translucent rounded square with simple lock symbol, transparent background, no text` |
| `ui/new_badge.png` | `new item badge shape, small orange gold burst badge, transparent background, no text, empty center for engine text` |

## 11. 아이콘 세트 33장

모든 아이콘 프롬프트 뒤에 아래 공통 문구를 붙인다.

```text
2D cartoon mobile game icon, 256x256, transparent background, centered, strong readable silhouette, bold clean outline, bright colors, no text, no letters, no watermark, no cropped parts, 18% padding
```

| 파일명 | 프롬프트 |
|---|---|
| `icon/core_purify.png` | `purification core class icon, teal white core with halo` |
| `icon/core_attack.png` | `attack core class icon, orange red plasma core with flame crown` |
| `icon/core_absorb.png` | `absorption core class icon, purple blue gravity core with orbit ring` |
| `icon/weapon_purify_bolt.png` | `weapon icon, cyan purification bolt` |
| `icon/weapon_pulse_wave.png` | `weapon icon, blue white pulse wave ring` |
| `icon/weapon_plasma_slash.png` | `weapon icon, orange plasma slash arc` |
| `icon/weapon_chain_lightning.png` | `weapon icon, yellow chain lightning` |
| `icon/weapon_gravity_mine.png` | `weapon icon, purple gravity mine` |
| `icon/weapon_cleansing_beam.png` | `weapon icon, green cyan cleansing beam` |
| `icon/weapon_meteor_orb.png` | `weapon icon, red orange meteor orb` |
| `icon/weapon_arc_mine.png` | `weapon icon, blue yellow arc mine` |
| `icon/evolution_nova_core.png` | `evolution icon, white cyan nova core explosion` |
| `icon/evolution_solar_lance.png` | `evolution icon, orange solar lance` |
| `icon/evolution_void_saw.png` | `evolution icon, purple gravity saw` |
| `icon/evolution_chain_storm.png` | `evolution icon, yellow electric storm` |
| `icon/evolution_drone_barrage.png` | `evolution icon, cyan yellow drone barrage` |
| `icon/evolution_healing_bloom.png` | `evolution icon, green healing bloom` |
| `icon/drone_purify_laser.png` | `drone icon, cyan purification laser drone` |
| `icon/drone_missile_pod.png` | `drone icon, orange missile pod drone` |
| `icon/drone_magnet_collector.png` | `drone icon, purple magnet collector drone` |
| `icon/drone_shield.png` | `drone icon, blue shield drone` |
| `icon/drone_spark.png` | `drone icon, yellow spark drone` |
| `icon/drone_healing.png` | `drone icon, green healing drone` |
| `icon/upgrade_damage.png` | `permanent upgrade icon, red orange damage arrow and spark` |
| `icon/upgrade_fire_rate.png` | `permanent upgrade icon, cyan rapid shot lines` |
| `icon/upgrade_move_speed.png` | `permanent upgrade icon, teal speed boot symbol without text` |
| `icon/upgrade_max_hp.png` | `permanent upgrade icon, green heart core symbol without text` |
| `icon/upgrade_magnet.png` | `permanent upgrade icon, purple magnet ring` |
| `icon/upgrade_xp_gain.png` | `permanent upgrade icon, blue gem multiplier symbol without numbers` |
| `icon/upgrade_armor.png` | `permanent upgrade icon, blue shield plate` |
| `icon/upgrade_drone_power.png` | `permanent upgrade icon, yellow drone spark` |
| `icon/upgrade_luck.png` | `permanent upgrade icon, gold star sparkle` |
| `icon/upgrade_starting_gold.png` | `permanent upgrade icon, gold core fragment pile` |

## 12. 상점/IAP/광고 이미지 9장

| 파일명 | 프롬프트 |
|---|---|
| `shop/remove_ads_pack.png` | `2D cartoon shop product art, clean premium ticket with crossed-out video play symbol, gold cyan trim, transparent background, no text, no letters, 20% padding` |
| `shop/starter_core_pack.png` | `2D cartoon shop product art, starter pack bundle, cute core fragment pile, small teal core skin border, gold chest, transparent background, no text, 20% padding` |
| `shop/small_fragment_pack.png` | `2D cartoon shop product art, small pile of gold cyan core fragments, transparent background, no text, 20% padding` |
| `shop/large_fragment_pack.png` | `2D cartoon shop product art, large overflowing pile of gold cyan core fragments, premium glow, transparent background, no text, 20% padding` |
| `shop/supporter_skin_pack.png` | `2D cartoon shop product art, premium skin pack, three colorful core skins and drone skins displayed as cards, transparent background, no text, 20% padding` |
| `shop/monthly_supply_pass.png` | `2D cartoon shop product art, monthly cosmic supply pass card, gold cyan premium card, reward chest and crystals, transparent background, no text, no letters, 20% padding` |
| `ad/revive_reward_visual.png` | `2D cartoon rewarded ad visual, cute core being revived by gold cyan beam, transparent background, no text, no letters, 20% padding` |
| `ad/double_reward_visual.png` | `2D cartoon rewarded ad visual, reward chest duplicating with sparkles, transparent background, no text, no numbers, 20% padding` |
| `ad/reroll_reward_visual.png` | `2D cartoon rewarded ad visual, three upgrade cards spinning with teal circular arrows, transparent background, no text, no letters, 20% padding` |

## 13. 실제 제작 체크리스트

- 모든 스프라이트는 **투명 배경**으로 생성한다.
- 모든 배경은 **1080x1920 세로형**으로 생성한다.
- UI 텍스트, 타이틀 텍스트, 가격 텍스트는 이미지에 넣지 않는다. Godot UI에서 한글 폰트로 올린다.
- 캐릭터/적/아이템은 화면 축소 50%에서도 실루엣이 구분되어야 한다.
- 플레이어 계열은 청록/흰색, 적은 분홍/주황/보라, XP는 파랑 계열을 유지한다.
- 적 탄과 XP 보석은 색과 모양을 절대 겹치게 만들지 않는다.
- 애니메이션 시트는 프레임 간격을 넓게 두고, 배경 없이 개별 프레임 자르기가 가능해야 한다.
- 보스/대형 이펙트는 전체 발광이 이미지 바깥으로 잘리지 않도록 24% 이상 여백을 둔다.
- 생성 후 Godot에 넣기 전 파일명을 이 문서의 파일명과 맞춘다.
