# 추가 이미지 프롬프트

아래 프롬프트는 현재 적용 중 발견된 문제를 보정하기 위한 재생성 요청입니다. 모든 이미지는 2D 만화풍, 카툰 SD 스타일, 밝고 선명한 색감 기준입니다.

## 1. 투명 스프라이트 시트 공통 보정 프롬프트

```text
Create a clean 2D cartoon SD mobile game sprite sheet for Core Survivor: Cosmic Purge.
Transparent background only, true alpha channel, no checkerboard pattern, no white backdrop, no shadow box, no text.
Keep every frame centered in an equal-size grid cell with generous 24 px padding from the cell edges.
Use crisp dark outlines, bright cosmic colors, readable silhouette for small Android screens.
Export as PNG with transparent alpha.
Exact canvas: 1536x1024.
Grid: 6 columns x 4 rows, every cell exactly 256x256.
All frames must keep the same character size and pivot position.
```

## 2. 탄환/젬 시트 exact size 프롬프트

```text
Create a 2D cartoon cosmic projectile sprite sheet, transparent background only, true alpha channel, no checkerboard.
Exact canvas: 2048x512.
Grid: 8 columns x 2 rows, every cell exactly 256x256.
Each frame shows a glowing cyan purification bolt with clear direction, centered in the cell, 32 px safe padding.
No text, no UI, no background.
```

```text
Create a 2D cartoon blue XP gem pickup sprite sheet, transparent background only, true alpha channel, no checkerboard.
Exact canvas: 1536x256.
Grid: 6 columns x 1 row, every cell exactly 256x256.
Each frame shows the same small diamond gem with a soft cyan sparkle animation, centered, 48 px safe padding.
No text, no UI, no background.
```

## 3. Google Play 스토어 그래픽 재생성

```text
Create a Google Play feature graphic for Core Survivor: Cosmic Purge.
2D cartoon SD cosmic survivor-like action game key art, bright cyan purification energy, cute core hero, polluted space enemies, premium mobile game quality.
No text, no logo, no UI, no borders.
Exact canvas: 1024x500.
Keep important characters inside the center safe area, leave clean margins for future title overlay.
```

```text
Create a Google Play app icon for Core Survivor: Cosmic Purge.
2D cartoon SD cute cosmic core hero face, bright cyan gem, dark space-blue circular background, strong silhouette, premium mobile game icon quality.
No text, no logo letters, no transparency.
Exact canvas: 512x512 PNG.
```

## 4. UI 9-slice 재생성

```text
Create a 2D cartoon sci-fi mobile game UI panel skin for Core Survivor: Cosmic Purge.
Transparent outside corners, true alpha channel, no checkerboard, no text.
Dark navy glass panel with cyan rim light, subtle cosmic particles, readable on small Android screens.
Exact canvas: 512x256.
Make the border and corners suitable for 9-slice scaling, keep center clean and low detail.
```

```text
Create a 2D cartoon primary button skin for Core Survivor: Cosmic Purge.
Transparent outside corners, true alpha channel, no checkerboard, no text.
Bright teal/cyan rounded rectangle, bold rim highlight, pressed-state friendly, clean center for Korean text overlay.
Exact canvas: 384x128.
Keep 24 px safe edge padding for 9-slice scaling.
```

## 5. 보상/상점 이미지 누락 보정

```text
Create a 2D cartoon shop product icon for "Remove Ads Pack" in Core Survivor: Cosmic Purge.
Show a cute cosmic core holding a clean shield that blocks small ad cards, premium but non-pay-to-win feeling.
Transparent background only, true alpha channel, no checkerboard, no text.
Exact canvas: 512x512.
```

```text
Create a 2D cartoon shop product icon for "Monthly Supply Pass" in Core Survivor: Cosmic Purge.
Show a glowing monthly supply capsule with core fragments, drone batteries, and cyan reward energy.
Transparent background only, true alpha channel, no checkerboard, no text.
Exact canvas: 512x512.
```

```text
Create a 2D cartoon interstitial run-end visual for Core Survivor: Cosmic Purge.
Show a completed purification run result scene with cute core hero, collected shards, and a clean cosmic gate.
No forced ad wording, no text, no logo.
Exact canvas: 1080x1920.
Leave center and lower area clean enough for UI buttons.
```

## 6. 모바일 UI 버튼/레벨업 카드 재생성

```text
Create a premium 2D cartoon mobile game button icon set for Core Survivor: Cosmic Purge.
Style: bright SD cartoon sci-fi, cyan purification energy, readable at 48 px on Android.
Icons needed: reroll arrows, ad reward badge, free chest, temporary drone, weapon codex, drone menu, shop, settings.
Transparent background only, true alpha channel, no checkerboard, no white backdrop, no text, no logo.
Exact canvas: 2048x1024.
Grid: 8 columns x 4 rows, every cell exactly 256x256.
Each icon must be centered with 40 px safe padding and consistent visual weight.
```

```text
Create a 2D cartoon level-up choice card UI skin for Core Survivor: Cosmic Purge.
Dark navy glass panel, cyan/gold rim light, subtle cosmic sparkle, premium mobile game quality.
Transparent outside corners, true alpha channel, no checkerboard, no text.
Exact canvas: 768x256.
Design must be suitable for 9-slice scaling: corners and border detailed, center clean for Korean text and upgrade icon.
Make hover/selected state visually possible by keeping a strong colored rim.
```

## 7. 스테이지 1 패럴랙스 배경 레이어 재생성

```text
Create three separate 2D cartoon parallax overlay PNGs for a top-down cosmic arena in Core Survivor: Cosmic Purge.
Style: bright SD cartoon, clean mobile readability, not realistic, no UI, no text.
Canvas for each layer: 1080x1920.
Transparent background only, true alpha channel, no checkerboard, no baked gray/white transparency pattern.
Layer A: far tiny cyan stars and faint dust, sparse, low visual noise.
Layer B: medium distant asteroids and small debris, edges soft, does not block enemies or XP gems.
Layer C: large faint cyan energy orbit rings and nebula wisps near edges only, center kept clear for gameplay.
Keep every layer tile-friendly enough for slow scrolling; avoid hard seams on edges.
```

## 8. 애니메이션 시트 중앙 정렬 재생성

```text
Create corrected 2D cartoon SD sprite sheets for Core Survivor: Cosmic Purge runtime characters.
Transparent background only, true alpha channel, no checkerboard, no white backdrop, no shadows outside the character silhouette.
Every frame must be centered in its cell with the same pivot point and same visual scale.
No neighboring frame may enter the cell; keep at least 32 px empty transparent padding on all sides.
Player core sheets: exact canvas 1536x1024, grid 6 columns x 4 rows, cell 256x256.
Enemy sheets: exact canvas 2048x1024, grid 8 columns x 4 rows, cell 256x256.
Drone sheet: exact canvas 1536x768, grid 6 columns x 3 rows, cell 256x256.
Projectile sheet: exact canvas 2048x256, grid 8 columns x 1 row, cell 256x256.
XP gem sheet: exact canvas 1536x256, grid 6 columns x 1 row, cell 256x256.
Use consistent outline thickness and strong silhouette for small Android screens.
```

## 9. 로비 전체 UI 리디자인 이미지 세트

아래 세트는 현재 로비의 단순 사각형 버튼/패널을 이미지 기반 UI로 교체하기 위한 추가 제작 요청입니다. 생성 후 `assets/images/ui/` 또는 `assets/images`로 적용할 예정입니다.

```text
Create a complete premium 2D cartoon sci-fi mobile lobby UI skin set for Core Survivor: Cosmic Purge.
Art direction: bright SD cartoon, cute cosmic purification theme, high-quality mobile game UI, vivid cyan/gold/purple accents, glossy but readable.
Do not create plain flat rectangles. Use illustrated rim lights, bevels, small star particles, subtle energy lines, and clean dark navy glass interiors.
All assets must be PNG with true transparent alpha, no checkerboard, no white background, no text, no logo.
Design for Android portrait 720x1280 UI, readable at small phone size.

Required separate assets:
1. lobby_header_panel_9slice.png - top resource/status panel, 720x144, transparent outside, 9-slice safe border.
2. stage_mission_panel_9slice.png - stage info panel, 720x160, cyan rim, clean center for Korean text.
3. core_select_card_9slice.png - selected core card, 512x384, glowing cyan border, 9-slice safe.
4. core_unselected_card_9slice.png - unselected core card, 512x384, subtle navy border, 9-slice safe.
5. daily_reward_panel_9slice.png - daily reward panel, 512x384, blue/cyan reward highlights.
6. permanent_upgrade_panel_9slice.png - permanent upgrade panel, 512x448, gold rim and upgrade sockets.
7. ad_reward_panel_9slice.png - optional ad reward panel, 720x256, purple/cyan reward styling, not intrusive.
8. primary_start_button_9slice.png - big start run button, 640x160, bright teal energy, strong premium highlight.
9. small_nav_button_9slice.png - menu button skin for weapon/drone/shop/settings, 384x128, dark glass with icon slot.
10. reward_button_9slice.png - small reward button skin, 384x128, blue/purple/gold variants in one sheet.
11. upgrade_plus_button_9slice.png - compact permanent upgrade button, 384x96, gold/green energy.
12. lobby_core_display_ring.png - decorative animated ring behind the selected core, 512x512, transparent center-friendly.

For 9-slice assets: keep corners detailed, keep the center low-detail and clean, leave at least 32 px stretch-safe middle area.
No baked text. No UI labels. No screenshot mockup. Output each asset separately if possible.
```

```text
Create a 2D cartoon mobile lobby icon sheet for Core Survivor: Cosmic Purge.
Style: premium SD cosmic UI icons, strong silhouette, readable at 36-64 px.
Transparent background only, true alpha channel, no checkerboard, no text.
Exact canvas: 2048x1024.
Grid: 8 columns x 4 rows, 256x256 per cell.
Icons required: purify core, attack core, absorb core, weapon codex, drone menu, shop, settings gear, daily reward crate, permanent upgrade crystal, core shard currency, ad bonus badge, free chest, temporary drone ticket, start run energy arrow, locked slot, new badge.
Every icon centered with 40 px safe padding, consistent outline and lighting.
```

```text
Create a 2D cartoon animated lobby background overlay set for Core Survivor: Cosmic Purge.
Purpose: make the lobby feel alive without reducing text readability.
Transparent background only, true alpha channel, no checkerboard, no UI, no text.
Canvas: 1080x1920 for each layer.
Layer 1: slow drifting cyan star dust and tiny core fragments, sparse.
Layer 2: faint rotating purification rings around the lower selected-core area, center-lower composition, does not cover UI panels.
Layer 3: soft purple pollution wisps near screen edges only, low opacity, no noisy center.
Keep all layers clean, tile-friendly for slow looping, and readable on Android portrait screens.
```

## 10. 코멧 미사일 무기 추가 이미지 세트

아래 이미지는 새 레벨업 무기 `코멧 미사일`의 전용 투사체, 폭발, 파편, 아이콘을 교체하기 위한 제작 요청입니다. 현재 빌드는 코드 드로잉으로 먼저 구현되어 있으며, 생성 후 `assets/images/normalized` 또는 `assets/images`에 연결하면 됩니다.

```text
Create a 2D cartoon SD sprite sheet for the "Comet Missile" weapon in Core Survivor: Cosmic Purge.
Style: bright comic sci-fi, cute but powerful, cyan purification energy with orange rocket flame, premium mobile game quality.
Transparent background only, true alpha channel, no checkerboard, no white/gray backdrop, no text, no logo.
Exact canvas: 2048x256.
Grid: 8 columns x 1 row, every cell exactly 256x256.
Each frame must show one missile centered on the same pivot point, pointing to the right, with consistent size and at least 48 px transparent padding on all sides.
Animation should feel like a heavy homing missile: glowing nose, small fins, strong flame trail, slight energy pulse across frames.
No neighboring frame may enter another cell.
```

```text
Create a 2D cartoon SD explosion sprite sheet for the "Comet Missile" impact in Core Survivor: Cosmic Purge.
Style: cyan purification blast mixed with orange comet sparks, strong hit impact, readable on small Android screens.
Transparent background only, true alpha channel, no checkerboard, no smoke background, no text, no logo.
Exact canvas: 2048x512.
Grid: 8 columns x 2 rows, every cell exactly 256x256.
Every explosion frame must be centered, same pivot, no frame-to-frame position drift.
Keep the outer glow soft and transparent; center should have a bright starburst and circular shockwave.
Do not fill the entire cell; leave at least 24 px transparent margin.
```

```text
Create a 2D cartoon SD fragment projectile sprite sheet for the "Comet Missile" shrapnel in Core Survivor: Cosmic Purge.
Style: small cyan-gold energy shards, fast and sharp, readable at 32 px.
Transparent background only, true alpha channel, no checkerboard, no background, no text.
Exact canvas: 1536x256.
Grid: 6 columns x 1 row, every cell exactly 256x256.
Each fragment points to the right and is centered with consistent scale.
Include a short transparent glow trail, but keep the shard silhouette clear.
```

```text
Create a 2D cartoon mobile game upgrade icon for "Comet Missile" in Core Survivor: Cosmic Purge.
Show a cute powerful cyan comet missile with orange flame and a small circular shockwave behind it.
Transparent background only, true alpha channel, no checkerboard, no text, no logo.
Exact canvas: 512x512.
Centered icon with 56 px safe padding, strong silhouette, readable at 48 px on Android.
Use the same premium SD cartoon sci-fi style as the existing lobby UI.
```

```text
Create a 2D cartoon level-up card illustration for the "Comet Missile" weapon in Core Survivor: Cosmic Purge.
Use as an optional decorative image inside a level-up card.
Show a comet missile piercing polluted space enemies and triggering a cyan-orange purification explosion.
Transparent background only, true alpha channel, no checkerboard, no text, no logo.
Exact canvas: 768x384.
Keep the center-left area visually strong and leave the right side cleaner for Korean text overlay.
```
