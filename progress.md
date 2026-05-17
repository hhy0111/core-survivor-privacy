Original prompt: AGENTS.md 기준으로 Core Survivor: Cosmic Purge를 Google Android 전용 2D 모바일 survivor-like 게임으로 개발하고, 이후 로비/브라우저 화면/이미지 프롬프트/AdMob 광고 연결 작업을 진행.

## 2026-05-05

- AdMob 보상형 광고 6개를 Android 네이티브 플러그인과 GDScript 래퍼로 연결.
- Debug APK는 Google 테스트 보상형 광고 단위를 자동 사용하고, Release 빌드에서는 실제 AdMob 광고 단위 ID를 사용하도록 구성.
- 로비 광고 보상 3개, 레벨업 리롤, 사망 부활, 런 종료 보상 2배 진입점을 구현.
- Android Gradle 빌드 템플릿 설치 및 Google Mobile Ads SDK 의존성 추가.
- APK 빌드 및 서명 검증 완료. 다음 확인은 Web 미리보기 UI와 실제 Android 기기 광고 로드 테스트.
- Web 빌드 재생성 후 `admob-opening-check.png`, `admob-lobby-check.png`, `admob-web-fallback-check.png`로 광고 버튼 배치와 Web fallback 안내를 확인.
- 남은 일: 실제 Android 기기에 Debug APK 설치 후 테스트 광고 노출/보상 콜백이 동작하는지 확인.

## 2026-05-06

- Applied 22 runtime images under `assets/images` and 3 Android launcher icon images under `assets/icons`.
- Connected opening, lobby, run background, 3 core sheets/icons, 6 enemies, drone, projectile, XP gems, and mobile joystick images.
- Removed baked white/gray checkerboard backgrounds from runtime sprite copies with `tools/clean_checker_alpha.ps1`.
- Set Web export `html/canvas_resize_policy=2` so browser verification uses the mobile portrait canvas correctly.
- Verified portrait screenshots with Playwright: `builds/web/image-verify-phone-clean/01-opening-phone.png` through `04-run-enemy-phone.png`.
- Wrote image report: `docs/image_application_report.md`.
- Wrote missing/repair prompts: `docs/additional_image_prompts.md`.
- Built signed Android AAB with image assets: `builds/android/core-survivor-images-v4.aab` (versionCode 4, versionName 0.1.3).

## 2026-05-06 late image/UI pass

- Fixed desktop browser preview to center a fixed 9:16 phone canvas using `tools/patch_web_export.ps1`; current server URL keeps the 720x1280 game inside a centered Android portrait frame.
- Added runtime sprite auto-crop helper `scripts/SpriteFrameHelper.gd` and applied it to player, enemy, drone, projectile, and XP gem drawing so frames render from alpha bounds and stay centered.
- Strengthened `tools/clean_checker_alpha.ps1` to clean checker/white backgrounds per sprite grid cell, then re-cleaned runtime character sheets, projectile, XP gems, joystick, core icons, parallax layers, and upgrade/ad icons.
- Added stage 1 parallax overlays: `stage1_far_stars_layer.png`, `stage1_asteroid_layer.png`, `stage1_energy_ring_layer.png`.
- Improved lobby/ad buttons and level-up card styling with stronger panel shadows, upgrade icons, reroll icon, and choice-specific accent borders.
- Verified with Playwright screenshots:
  - `builds/web/verify-latest/desktop-page-opening.png`
  - `builds/web/verify-latest/desktop-page-lobby.png`
  - `builds/web/verify-latest/desktop-page-run.png`
  - `builds/web/verify-latest/phone-levelup-or-run.png`
  - `builds/web/verify-latest/phone-after-upgrade-choice.png`
- Added regeneration prompts for better phone UI, parallax layers, and corrected sprite sheets to `docs/additional_image_prompts.md`.

## 2026-05-06 player sprite/lobby UI follow-up

- Fixed player core animation size jitter by drawing each frame with a row-level reference size instead of scaling every alpha crop independently.
- Updated `scripts/SpriteFrameHelper.gd` with `draw_frame_consistent_row()` and applied it in `scripts/Player.gd`; the player remains centered and no longer shows neighboring sheet frames during idle/run animation.
- Added a full premium lobby UI image prompt set to `docs/additional_image_prompts.md` section 9, covering 9-slice panels, start/nav/reward/upgrade buttons, lobby display ring, icons, and animated overlay layers.
- Re-exported Web and re-applied `tools/patch_web_export.ps1` so the browser preview stays as a centered 720x1280 Android portrait canvas.
- Verified screenshots:
  - `builds/web/verify-player-size-2/player-frame-0.png`
  - `builds/web/verify-player-size-2/player-frame-3.png`

TODO:

- Generate the new section 9 lobby UI assets, then replace the current code-drawn lobby cards/buttons with the new 9-slice/button images.
- If the player core feels too small after the stable-scale fix, increase `Player.sprite_size` from `Vector2(120, 120)` to about `Vector2(132, 132)` and rerun the Web screenshot pass.

## 2026-05-07 normalized sprite sheet pass

- Added `tools/normalize_sprite_sheets.ps1`, which creates corrected sprite sheets under `assets/images/normalized`.
- New normalization method finds the main connected opaque component inside each animation cell, moves that component anchor to the exact cell center, and preserves the source art inside a transparent cell.
- Regenerated normalized sheets for 3 core sheets, 6 enemy sheets, drone, projectile, and XP gems.
- Switched runtime sprite paths to `assets/images/normalized/...` for player, enemies, drone, projectile, and XP gems.
- Changed animated drawing calls to preserve the cell pivot, so the corrected image center stays fixed instead of re-centering every crop rectangle.
- Stopped treating white pixels as checkerboard inside `SpriteFrameHelper`; this prevents white core/body art from being cropped out.
- Verified Web build with Playwright:
  - `builds/web/verify-normalized-sprites-v2/shot-0.png`
  - `builds/web/verify-normalized-sprites-v2/gameplay-frame-0.png`
  - `builds/web/verify-normalized-sprites-v2/gameplay-frame-2.png`

TODO:

- If newly generated sprite art arrives, run `tools/normalize_sprite_sheets.ps1 -Root .` before exporting so all animation cells are centered consistently.

## 2026-05-07 player core frame inspection/fix

- Inspected `core_purify_sheet.png` frame-by-frame by exporting row 0 cells to `builds/sprite_inspect/core_purify_original_cells`.
- Root cause found: the source player idle row is not a valid centered idle animation. Frame 0 places the body on the far right, frame 5 places it left, and frame 1 contains stray pixels from the previous frame at the left edge.
- Improved `tools/normalize_sprite_sheets.ps1` for core sheets:
  - core sheets now use dark body/face pixels as the anchor instead of the full flame silhouette,
  - idle row now remaps to stable middle frames `1,2,3,4,3,2`, avoiding bad edge frames 0 and 5.
- Regenerated normalized core sheets. `core_purify_sheet.png` body center error is now within about 0.4 source pixels for all 6 idle frames.
- Verified corrected frame cells:
  - `builds/sprite_inspect/core_purify_stable_cells/frame_0.png`
  - `builds/sprite_inspect/core_purify_stable_cells/frame_3.png`
  - `builds/sprite_inspect/core_purify_stable_cells/frame_5.png`
- Re-exported Web and verified gameplay:
  - `builds/web/verify-core-stable-idle/shot-0.png`
  - `builds/web/verify-core-stable-idle/gameplay-frame-0.png`
  - `builds/web/verify-core-stable-idle/gameplay-frame-2.png`
  - `builds/web/verify-core-stable-idle/gameplay-frame-5.png`

## 2026-05-07 generated UI image application

- Added `tools/extract_generated_ui_assets.ps1` to extract usable transparent UI assets from the newly generated `image` folder.
- Applied new generated assets:
  - `assets/images/lobby_background_v2.png`
  - `assets/images/ui_button_teal.png`
  - `assets/images/ui_panel_cosmic.png`
  - `assets/images/ui_ad_reward_badge_v2.png`
  - `assets/images/ui_daily_reward_badge.png`
- Updated `scripts/Game.gd` to use the new lobby background, button skin, panel skin, ad reward icon, and daily reward icon.
- Fixed an initial `TextureRect` implementation problem where the button image rendered at source size; buttons/panels now use `StyleBoxTexture` so artwork stays inside the intended UI bounds.
- Re-exported Web and re-applied `tools/patch_web_export.ps1`.
- Verified canvas patch via browser DOM: `lang=ko`, canvas backing size `720x1280`, rendered rect `720x1280`.
- Verified screenshots:
  - `builds/web/verify-new-ui-assets-v2/opening-phone-patched.png`
  - `builds/web/verify-new-ui-assets-v2/lobby-phone-patched.png`
  - `builds/web/verify-new-ui-assets-v2/run-phone-patched.png`
  - `builds/web/verify-new-ui-assets-final-client/shot-0.png`
- Documented applied and deferred images in `docs/image_application_report.md`.

## 2026-05-08 comet missile weapon pass

- Added a stronger missile weapon line named `코멧 미사일`.
- Missile is now a default Lv.1 support weapon at run start, so the player sees heavier missile fire immediately instead of only after a random level-up.
- Added missile upgrade scaling:
  - higher direct damage,
  - wider explosion radius,
  - shorter cooldown,
  - Lv.4+ explosion fragments.
- Added code-drawn missile and fragment projectile visuals in `scripts/Projectile.gd`.
- Added area explosion handling in `scripts/Game.gd` using `EffectRing` shockwaves and falloff damage.
- Adjusted level-up selection so `코멧 미사일` upgrade is prioritized while it is still early level.
- Added dedicated missile image generation prompts to `docs/additional_image_prompts.md` section 10.
- Verified:
  - `godot --headless --path . --quit`
  - Web export regenerated and patched to Korean 720x1280 canvas.
  - Playwright smoke test screenshot: `builds/web/verify-missile-upgrade/shot-0.png`
  - Gameplay screenshots:
    - `builds/web/verify-missile-upgrade/missile-start-visible.png`
    - `builds/web/verify-missile-upgrade/missile-combat-visible.png`
    - `builds/web/verify-missile-upgrade/missile-visible-v2-a.png`
    - `builds/web/verify-missile-upgrade/missile-visible-v2-b.png`

TODO:

- Replace current code-drawn `코멧 미사일` with generated transparent missile/explosion sheets from `docs/additional_image_prompts.md` section 10.
- Consider adding a short missile launch sound and screen shake once audio/VFX pass starts.

## 2026-05-09 rollback diagnosis/fix

- Root cause of the apparent design rollback: stale export artifacts were left inside source folders:
  - `scripts/*.gdc`
  - `scripts/*.gd.remap`
  - `scenes/*.tscn.remap`
- Those remap files pointed the exported game at 2026-05-06 compiled scripts/scenes, so newer lobby UI, normalized sprite drawing, missile changes, and level-up styling were not reliably included in Web export.
- Removed 23 stale generated files from `scripts` and `scenes`.
- Re-exported Web and re-applied `tools/patch_web_export.ps1` separately after export.
- Verified current Web output:
  - `builds/web/verify-remap-removed-opening/shot-0.png`
  - `builds/web/verify-manual-click-lobby/page.png`
  - `builds/web/verify-remap-removed-run/page.png`
- UI button/panel rendering was also made more robust by drawing generated button/panel PNGs as bounded `TextureRect` skins behind clickable buttons/panels.

TODO:

- Do not keep `.gdc`, `.gd.remap`, or `.tscn.remap` files in source folders.
- If a future export looks rolled back, first check for generated remap files in `scripts` or `scenes`, then export and run `tools/patch_web_export.ps1` as a separate command.

## 2026-05-09 lobby button readability pass

- Fixed lobby button text readability after generated cyan button skins were applied:
  - changed skinned button text from white to dark navy,
  - added transparent button content margins so text no longer touches the decorative frame,
  - reduced font sizes for small nav/permanent upgrade buttons,
  - removed oversized ad/daily reward icons from small buttons because they pushed text off center,
  - centered core card text inside each card.
- Re-exported Web and re-applied `tools/patch_web_export.ps1`.
- Verified screenshots:
  - `builds/web/verify-lobby-button-fix-client/shot-0.png`
  - `builds/web/verify-lobby-button-fix-final/lobby.png`

## 2026-05-09 lobby skin alignment pass

- Root cause: generated `ui_button_teal.png` includes extra prompt/transparent space above the actual button art, and `ui_panel_cosmic.png` includes large transparent side/top margins around the actual panel frame.
- Added `scripts/UiTextureSkin.gd` to draw only a cropped source region from generated UI textures into the intended Control rectangle.
- Updated lobby menu buttons to use the cropped button source region, so text/click rect and decorative frame share the same bounds.
- Updated lobby panels to use the cropped panel source region, so mission/ad/permanent-upgrade panel frames line up with their backgrounds.
- Re-exported Web and re-applied `tools/patch_web_export.ps1`.
- Verified screenshots:
  - `builds/web/verify-lobby-skin-align-client-2/shot-0.png`
  - `builds/web/verify-lobby-skin-align-2/lobby.png`

## 2026-05-09 pre-release mobile control/combat pass

- Added `docs/pre_release_development_plan.md` to track the remaining release-prep development work.
- Fixed the level-up upgrade window regression:
  - reroll and upgrade choice buttons no longer use the large generated panel texture as a small 9-slice,
  - upgrade choices now use flat, accented card styles so text/icons do not overlap broken panel art.
- Removed keyboard gameplay controls:
  - deleted keyboard input map entries from `project.godot`,
  - removed keyboard movement fallback and restart shortcut from `scripts/Game.gd`.
- Changed movement to bottom mobile joystick only:
  - joystick input starts only inside the bottom-left stick zone,
  - joystick events are handled in `_input()` so full-screen HUD controls do not swallow gameplay touch events,
  - `TouchStick` is set to `MOUSE_FILTER_IGNORE` so it draws only and does not consume input.
- Inspected boss sprite cells:
  - original boss row 0 frames all touch cell edges,
  - normalized boss row 0 frames 1-5 still have cropped/adjacent-frame artifacts,
  - runtime boss animation now uses safe frames `[0, 6, 7, 6]` until a cleaner boss sheet is generated.
- Re-exported Web and re-applied `tools/patch_web_export.ps1`.
- Verified:
  - `godot --headless --path . --quit`
  - `builds/web/verify-mobile-control-client/shot-0.png`
  - `builds/web/verify-mobile-levelup-fix/03-mid-run-or-levelup.png`
  - `builds/web/verify-mobile-touch-active-2/active-diagonal-touch.png`
  - Android debug export: `builds/android/core-survivor-mobile-control-debug.apk`

TODO:

- When new boss art arrives, regenerate the boss sheet with clean centered cells and remove the temporary boss frame sequence restriction.
- Build a fresh Android AAB with these mobile-control and level-up UI fixes before the next Play Console upload.

## 2026-05-09 comet missile generated asset pass

- Confirmed 5 newly added files under `image/additional_image_prompts`.
- Converted the generated images into runtime assets:
  - `assets/images/comet_missile_sheet.png`
  - `assets/images/comet_explosion_sheet.png`
  - `assets/images/comet_fragment_sheet.png`
  - `assets/images/upgrade_missile_icon.png`
  - `assets/images/comet_levelup_card_art.png`
- Important generation mismatch: the supplied files do not match the prompt's expected frame counts. Runtime uses the actual image layout instead:
  - missile: 9 columns x 1 row
  - fragment: 7 columns x 1 row
  - explosion: 7 columns x 2 rows
- Added `scripts/SpriteSheetEffect.gd` for short sprite-sheet VFX and connected missile explosions to `comet_explosion_sheet.png`.
- Updated `scripts/Projectile.gd` so missile and fragment projectiles use generated sprite-sheet animation instead of code-drawn fallback when a texture path is supplied.
- Updated `scripts/Game.gd` so:
  - `코멧 미사일` fires `comet_missile_sheet.png`,
  - missile explosion fragments use `comet_fragment_sheet.png`,
  - level-up missile icon uses `upgrade_missile_icon.png`.
- Re-exported Web and re-applied `tools/patch_web_export.ps1`.
- Verified:
  - `godot --headless --path . --check-only`
  - `godot --headless --path . --quit`
  - develop-web-game Playwright client smoke screenshot: `builds/web/verify-comet-assets-client/shot-0.png`
  - direct browser screenshots:
    - `builds/web/verify-comet-assets-direct4/01-lobby.png`
    - `builds/web/verify-comet-assets-direct4/02-gameplay-comet.png`
    - `builds/web/verify-comet-assets-direct4/03-gameplay-comet-later.png`
  - browser console errors: none in `builds/web/verify-comet-assets-direct4/errors.json`
- Updated image report: `docs/image_application_report.md`.

TODO:

- `image/additional_image_prompts/22-5.png` was converted to `comet_levelup_card_art.png` but is not connected yet. It includes a full battle illustration, so use it only after a dedicated card layout pass.
- If the missile appears too large on real Android devices, tune `Projectile.gd` missile `sprite_size` from `Vector2(132, 68)` down to about `Vector2(116, 60)`.

## 2026-05-09 lobby core selection UI fix

- Fixed core selection feedback being hidden behind the ad reward panel.
- Root cause: `_draw_lobby_art()` drew the selected core preview on the background layer while lobby panels/buttons are Control UI above it.
- Removed the hidden selected-core preview drawing and left only subtle ambient lobby glints in the background.
- Added front-layer UI feedback:
  - top summary text: `현재 선택: ...`
  - yellow `선택됨` badge on the selected core card
  - selection notice text below the ad reward panel
- Disabled focus mode on menu buttons so mobile clicks do not leave a rectangular keyboard-focus outline around selected cards.
- Re-exported Web and re-applied `tools/patch_web_export.ps1 -IndexPath builds/web/index.html`.
- Verified:
  - `godot --headless --path . --check-only`
  - `godot --headless --path . --quit`
  - develop-web-game client screenshot: `builds/web/verify-core-select-ui-client-4/shot-0.png`
  - direct screenshots:
    - `builds/web/verify-core-select-ui-direct-4/01-lobby-default.png`
    - `builds/web/verify-core-select-ui-direct-4/02-attack-selected.png`
    - `builds/web/verify-core-select-ui-direct-4/03-absorb-selected.png`
  - browser console errors: none in `builds/web/verify-core-select-ui-direct-4/errors.json`

## 2026-05-09 game over modal readability fix

- Fixed the death/game-over banner using the generated lobby panel skin as a stretchable modal background.
- Root cause: `_create_game_over_panel()` called `_panel_style(...)` with texture skin enabled, so the large decorative panel art was stretched into a result popup and visually collided with text/buttons.
- Added a dedicated `game_over_backdrop` dim layer so gameplay, enemies, and XP gems no longer compete with the result popup.
- Switched the game-over panel and its four action buttons to flat high-contrast modal styles that do not use the lobby decorative texture.
- Shortened result text lines to avoid wrapping issues on the Android portrait canvas.
- Re-exported Web and re-applied `tools/patch_web_export.ps1 -IndexPath builds/web/index.html`.
- Verified:
  - `godot --headless --path . --check-only`
  - `godot --headless --path . --quit`
  - develop-web-game client smoke screenshot: `output/game-over-ui-fix-client2/shot-0.png`
  - direct browser death-flow screenshot: `output/game-over-ui-death-check-v2/99-final.png`
  - browser console errors: none in `output/game-over-ui-death-check-v2/errors.json`

## 2026-05-10 absorb core and comet projectile sprite fix

- Audited sprite sheets frame by frame with contact sheets under `output/frame_audit`.
- Root causes found:
  - `assets/images/normalized/core_absorb_sheet.png` had half-character frames in the row used by the player animation.
  - `assets/images/comet_missile_sheet.png` and `assets/images/comet_explosion_sheet.png` had frame content touching/bleeding across cell edges, so rotation and animation exposed cut fragments.
- Fixed runtime assets:
  - Rebuilt `assets/images/normalized/core_absorb_sheet.png` with centered full frames only.
  - Added clean runtime sheets:
    - `assets/images/normalized/comet_missile_sheet.png`
    - `assets/images/normalized/comet_fragment_sheet.png`
    - `assets/images/normalized/comet_explosion_sheet.png`
  - Updated `scripts/Game.gd` to use the normalized comet projectile/effect sheets.
- Verification:
  - `godot --headless --path . --check-only`
  - `godot --headless --path . --import`
  - Web export plus `tools/patch_web_export.ps1 -IndexPath builds/web/index.html`
  - develop-web-game client smoke run: `output/sprite-fix-client/shot-0.png`
  - Direct browser screenshots:
    - `output/sprite-fix-manual/02-absorb-selected.png`
    - `output/sprite-fix-manual/03-run-absorb-start.png`
    - `output/sprite-fix-sequence/montage.png`
  - Browser console errors: none in `output/sprite-fix-manual/errors.json`.

TODO:

- The new procedural comet explosion is stable and uncut, but it is less illustrative than a hand-generated impact sheet. Replace it later if a clean 7x2 transparent explosion sheet arrives.

## 2026-05-10 player absorb core frame and projectile overlap fix

- Audited the player core sheets frame by frame under `output/player-frame-audit`.
- Root causes found:
  - `assets/images/normalized/core_absorb_sheet.png` row 0 frames 1, 3, and 5 were half-character cells, so the idle animation flickered between full and broken absorb-core frames.
  - Early bolt/missile projectiles spawned too close to `player.position` and were drawn above the player, making a blue shard look attached to the character.
- Fixed runtime assets and code:
  - Replaced the broken absorb-core row 0 frames with full-body frames in `assets/images/normalized/core_absorb_sheet.png`.
  - Updated `tools/normalize_sprite_sheets.ps1` so future absorb-core normalization remaps idle row to stable full frames.
  - Set the player above projectiles with `player.z_index = 20` and projectiles at `z_index = 8`.
  - Moved player bolt spawn outward by 58px, missile spawn outward by 92px, and drone shots outward by 34px.
- Verified:
  - `godot --headless --path . --check-only`
  - `godot --headless --path . --import`
  - Web export with `godot --headless --path . --export-debug "Web Debug" "$root\builds\web\index.html"` and `tools/patch_web_export.ps1`
  - Frame contact sheet: `output/player-frame-audit/absorb_fixed_after_patch.png`
  - Browser gameplay screenshots:
    - `output/player-frame-fix-verify/04-run-moving-a.png`
    - `output/player-frame-fix-verify/05-run-moving-b.png`
    - `output/player-frame-fix-verify/06-run-moving-c.png`
  - Browser console errors: none in `output/player-frame-fix-verify/errors.json`.

TODO:

- When exporting Web, use `godot --headless --path . --export-debug ...`; then run `tools/patch_web_export.ps1` separately and confirm `builds/web/index.pck` is tens of MB, not a tiny placeholder file.

## 2026-05-10 arena bounds, absorb animation restore, and lobby UI polish

- Added finite arena bounds in `scripts/Game.gd`:
  - World size is 4800 x 6800 around origin (`ARENA_HALF_WIDTH = 2400`, `ARENA_HALF_HEIGHT = 3400`).
  - Player, enemies, drones, XP drops, and projectile cleanup now respect the arena.
  - Camera follows the clamped player position, and the visible edge draws a cyan boundary wall/tick treatment.
- Restored absorb-core animation instead of freezing it:
  - Root cause: several source cells in `core_absorb_sheet.png` cross cell boundaries and produce half-character frames when normalized directly.
  - Updated `tools/normalize_sprite_sheets.ps1` so `core_absorb_sheet.png` rebuilds all 4 rows from the clean source frames `0,1,5,1,0,5`.
  - Regenerated `assets/images/normalized/core_absorb_sheet.png`.
  - Frame audit sheet: `output/absorb-animation-rebuild/core_absorb_all_rows_rebuilt_contact.png`.
- Polished lobby/menu button rendering in `scripts/Game.gd`:
  - Panels clip child contents so decorative button art cannot visually escape its panel.
  - Small permanent-upgrade buttons use flat styles instead of squeezed texture skins.
  - Menu button text is explicitly center aligned.
- Verified:
  - `godot --headless --path . --check-only`
  - `godot --headless --path . --import`
  - Web export with `godot --headless --path . --export-debug "Web Debug" "$root\builds\web\index.html"` and `tools/patch_web_export.ps1`
  - Confirmed `builds/web/index.pck` is 102,863,648 bytes and `index.html` canvas is 720 x 1280.
  - Direct browser screenshots:
    - `output/player-frame-fix-verify/01-lobby.png`
    - `output/player-frame-fix-verify/02-absorb-selected.png`
    - `output/player-frame-fix-verify/04-run-moving-a.png`
    - `output/player-frame-fix-verify/05-run-moving-b.png`
    - `output/player-frame-fix-verify/06-run-moving-c.png`
  - Browser console errors: none in `output/player-frame-fix-verify/errors.json`.
  - develop-web-game client smoke screenshot: `output/absorb-ui-client/shot-0.png`.

TODO:

- If future core animation direction rows become runtime-facing, keep using the rebuilt normalized absorb sheet; the player currently draws row 0 only.

## 2026-05-11 weapon codex purchase buttons

- Fixed the weapon codex being informational only. It now shows clear states:
  - `정화 볼트`, `코멧 미사일`: `보유 중`, 기본 지급.
  - `펄스 웨이브`: purchasable for 450 core fragments.
  - `정화 드론`: purchasable for 650 core fragments, or available through the special drone pack.
  - Future weapons: `준비 중` with disabled buttons.
- Added saved weapon unlock state in `scripts/Game.gd` under `weapon_unlocks`.
- Locked weapon upgrades are filtered out of level-up choices until bought; bought weapons appear from the next purification run.
- Adjusted detail-card mouse filters so buttons inside the scrollable codex receive clicks reliably.
- Verified:
  - `godot --headless --path . --check-only`
  - Web export and `tools/patch_web_export.ps1 -IndexPath builds/web/index.html`
  - Confirmed `builds/web/index.pck` is 107,384,288 bytes and `index.html` canvas is 720 x 1280.
  - Direct browser screenshots:
    - `output/weapon-buy-verify/02-weapon-codex-before-buy.png`
    - `output/weapon-buy-verify/03-weapon-codex-after-buy.png`
    - `output/weapon-buy-verify/04-after-close-click.png`
  - Browser console errors: none in `output/weapon-buy-verify/errors.json`.
  - develop-web-game client smoke screenshot: `output/weapon-buy-client/shot-0.png`.

## 2026-05-11 drone start behavior, boss frame cleanup, and run-end ads

- Adjusted bought drone behavior in `scripts/Game.gd`:
  - Buying `정화 드론` now means the next purification run starts with a Lv.1 drone companion.
  - Drone upgrade choices continue from that Lv.1 baseline.
  - Codex copy now states that the drone appears at the start of the next run.
- Fixed the boss sprite clipping:
  - Root cause: `enemy_boss_warden_sheet.png` contains many frames whose art crosses sprite-cell boundaries, so direct normalization produced left/right clipped boss frames.
  - Updated `tools/normalize_sprite_sheets.ps1` so `enemy_boss_warden_sheet.png` remaps all rows to the clean frame pattern `6,7,6,7,6,7,6,7`.
  - Updated the boss runtime frame sequence to `[0, 1, 2, 3]` against the cleaned row.
  - Frame audit:
    - before: `output/boss-frame-audit/original_contact.png`
    - previous normalized: `output/boss-frame-audit/normalized_contact.png`
    - fixed: `output/boss-frame-audit/normalized_after_remap_contact.png`
  - Pixel margin check on runtime row 0 shows no frame touching the left edge; row 0 left margins are 30px+.
- Changed run-end interstitial ads:
  - Run-end interstitial is now requested after every run finish, not every 5th run.
  - `remove_ads` still blocks run-end interstitials through `_has_remove_ads()`.
  - Interstitials are preloaded again after close.
  - Shop description and `docs/admob_integration.md` were updated from "5회마다" to "런 종료마다".
- Verified:
  - `godot --headless --path . --check-only`
  - `godot --headless --path . --import`
  - Web export and `tools/patch_web_export.ps1 -IndexPath builds/web/index.html`
  - Confirmed `builds/web/index.pck` is 109,865,472 bytes and `index.html` canvas is 720 x 1280.
  - develop-web-game client smoke screenshot: `output/boss-ad-client/shot-0.png`
  - Direct browser run smoke screenshots:
    - `output/player-frame-fix-verify/03-run-start.png`
    - `output/player-frame-fix-verify/06-run-moving-c.png`
  - Browser console errors: none in `output/player-frame-fix-verify/errors.json`.

TODO:

- Android device test is still needed for the actual AdMob interstitial display and `remove_ads` purchase suppression because the web build has no Android AdMob/Billing plugin.

## 2026-05-11 ad, billing, and privacy closeout

- Confirmed Play Console setup from user screenshots:
  - AdMob has all 7 runtime ad units registered.
  - Google Play one-time products have all 5 runtime in-app product IDs registered.
  - Google Play subscription has `monthly_supply_pass` registered.
- Hardened billing entitlement timing in `android/build/src/com/harness/coresurvivor/billing/CoreSurvivorBillingPlugin.java`:
  - non-consumable/subscription rewards are emitted after successful acknowledgement,
  - consumable `growth_shard_pack` reward is emitted after successful consumption,
  - restore paths use the same safe grant flow.
- Updated privacy policy HTML:
  - `docs/privacy_policy.html`
  - root redirect `privacy_policy.html`
- Updated Android export settings:
  - versionCode `6`, versionName `0.1.5`,
  - output path `builds/android/core-survivor-prelaunch-v6.aab`,
  - excluded `output/*` from export so local QA screenshots are not packaged.
- Built signed Android release AAB:
  - `builds/android/core-survivor-prelaunch-v6.aab`
  - size: 99,838,997 bytes
- Verified:
  - `godot --headless --path . --check-only`
  - Android Gradle release bundle build succeeded
  - `jarsigner -verify builds/android/core-survivor-prelaunch-v6.aab`
  - AAB contains 0 entries under `output/`, `docs/`, `private/`, `builds/`, `image/`, and `tools/`.

## 2026-05-11 launcher icon rebuild

- Replaced Android launcher icon sources with the current store icon art:
  - `assets/icons/main_192.png`
  - `assets/icons/adaptive_foreground_432.png`
  - `assets/icons/adaptive_background_432.png`
- Updated Android export version:
  - versionCode `7`
  - versionName `0.1.6`
  - output `builds/android/core-survivor-prelaunch-v7.aab`
- Built signed Android release AAB:
  - `builds/android/core-survivor-prelaunch-v7.aab`
  - size: 98,728,380 bytes
- Verified:
  - Android Gradle release bundle build succeeded.
  - `jarsigner -verify builds/android/core-survivor-prelaunch-v7.aab` returned `jar verified`.
  - Extracted AAB launcher icon preview to `output/aab-icon-check/icon.png` and confirmed it uses the new core character icon.
  - AAB contains 0 entries under `output/`, `store_assets/`, `docs/`, and `private/`.

## 2026-05-12 Android 16KB page-size release rebuild

- Fixed the Play Console blocker "app does not support 16KB memory page size".
- Root cause: the v7 bundle was built from the Godot 4.3 Android template, whose native libraries used 4KB ELF segment alignment.
- Migrated the custom Android build template to Godot 4.5 and updated `android/.build_version` to `4.5.stable`.
- Preserved the custom AdMob and Google Play Billing plugins in the Android build template.
- Added Gradle manifest placeholder wiring for `godotEditorVersion`.
- Reduced Gradle JVM memory and worker count so this 8GB Windows machine can complete the Android release build without JVM OOM.
- Added `.gdignore` files for non-game folders so Godot does not import local tooling, store assets, docs, and build outputs.
- Updated Android export version:
  - versionCode `8`
  - versionName `0.1.7`
  - output `builds/android/core-survivor-prelaunch-v8.aab`
- Built signed Android release AAB:
  - `builds/android/core-survivor-prelaunch-v8.aab`
  - size: 83,459,943 bytes
- Verified:
  - Godot 4.5 export and Android Gradle release bundle build succeeded.
  - `jarsigner -verify builds/android/core-survivor-prelaunch-v8.aab` returned `jar verified`.
  - AAB merged manifest contains versionCode `8`, versionName `0.1.7`, Billing permission, AdMob app ID, and both custom Godot plugin registrations.
  - AAB has only `arm64-v8a/libgodot_android.so` and `arm64-v8a/libc++_shared.so` native libraries.
  - Both native libraries report ELF `LOAD` segment alignment `0x4000`, satisfying 16KB page-size compatibility.
  - AAB contains 0 entries under `output/`, `store_assets/`, `docs/`, `private/`, and `tools/`.

## 2026-05-13 ad and billing code review follow-up

- Reviewed the AdMob and Google Play Billing code paths after the Play upload.
- Cleaned production-facing purchase/ad fallback copy so it no longer references internal test or APK wording.
- Adjusted consumable handling so `growth_shard_pack` is not recorded as an owned product after consumption.
- Adjusted monthly subscription handling so saved one-time bonus state does not make `monthly_supply_pass` stay active forever after entitlement refresh.
- Changed daily reward, daily ad bonus, and free chest state to reset by local date instead of remaining permanently claimed.
- Removed the extra one-run ad drone flag from `special_drone_pack`; the pack already enables the permanent run-start drone.
- Remaining non-image/non-combat polish items after this pass: audio resource playback and Android haptic hooks.

## 2026-05-13 next-content image preparation

- Added standalone prompt file for next development assets:
  - `docs/next_development_image_prompts.md`
- Covered unimplemented weapon sheets/icons, evolution sheets/icons, advanced drone sheets/icons, Stage 2 background/enemy/boss assets, and shop/settings icon polish assets.
- Added image intake checklist:
  - `docs/next_image_asset_intake.md`
- Added `-IncludeNextContent` to `tools/normalize_sprite_sheets.ps1` so future generated sheets can be normalized without changing the default existing-asset workflow.

## 2026-05-14 next-content image intake

- Copied 48 generated PNGs from `image/next_development_image_prompts/` into `assets/images/` using runtime-safe filenames.
- Normalized 25 new runtime sprite sheets into `assets/images/normalized/`.
- Adjusted next-content normalization settings to match the received 1536x1024 sheet layout.
- Connected new icons to lobby detail cards:
  - weapon codex icons for plasma ring, spark chain, laser lance, and purge bomb
  - evolution codex icons
  - drone codex icons
  - remove ads/monthly pass shop icons
  - sound/haptic settings icons
- Ran Godot import for the new image resources and confirmed the project loads without resource loader errors.

## 2026-05-14 next-content gameplay hookup

- Implemented runtime weapon behavior for:
  - plasma ring
  - spark chain
  - laser lance
  - purge bomb
- Added level-up support drone upgrades and effects:
  - targeting drone
  - capacitor drone
  - shield drone
  - magnet drone
  - repair drone
- Added evolution upgrade gates and runtime effects:
  - photon storm
  - comet battery
  - solar halo
  - thunder web
  - rail prism
  - cleanser nova
- Added Stage 2 runtime transition at 165 seconds, Stage 2 enemy pool, elite spawn, background/parallax swap, and Solar Devourer boss spawn at 250 seconds.
- Updated projectile handling for purge bomb expiry explosions and photon projectile sheets.
- Exported fresh Web build to `builds/web/index.html`, patched the Web shell, and started a local preview server at `http://127.0.0.1:8788/index.html`.

## 2026-05-14 arena size adjustment

- Reduced the bounded arena from 4800x6800 to 2400x3400 by changing the arena half extents to 1200x1700.
- Re-exported the Web build and confirmed the local preview responds at `http://127.0.0.1:8788/index.html`.

## 2026-05-14 economy balance pass

- Reduced starting core shards from 620 to 0.
- Raised weapon codex unlock costs to 2800-4200 shards so a first unlock takes roughly 5 strong clear runs instead of 0-1 runs.
- Reduced free daily/ad/chest shard rewards and monthly pass bonus amounts to avoid lobby-only unlock acceleration.
- Reduced run reward scaling to `kills * 0.5 + level * 10 + clear bonus 120`.
- Re-exported the Web build and confirmed the local preview responds at `http://127.0.0.1:8788/index.html`.

## 2026-05-14 Android AAB v9 export

- Bumped Android release to versionCode 9 / versionName 0.1.8 for Play Console upload.
- Lowered the Gradle JVM heap to 1024 MB in the Android build template to avoid low-memory build crashes on this machine.
- Exported signed AAB: `builds/android/core-survivor-prelaunch-v9.aab`.
- Verified the AAB with `jarsigner`; upload-key self-signed certificate warnings are expected for local upload-key signing.

## 2026-05-15 lobby UI polish

- Reworked lobby core cards to use subdued panel backgrounds with transparent click layers instead of oversized bright button skins.
- Reduced lobby panel/button texture alpha and lowered flat border opacity/thickness so button outlines look less harsh.
- Converted lobby navigation and ad reward buttons to quieter flat controls while keeping the main run button visually primary.
- Added a compact notice panel above the run button to make lobby guidance read as part of the layout instead of floating text.
- Re-exported the Web build, patched the Web shell, and verified the lobby plus weapon-codex overlay with Playwright screenshots:
  - `output/lobby-ui-after-final/lobby.png`
  - `output/lobby-ui-after-final/weapons-overlay.png`
- Confirmed both browser checks had no console errors and the local preview responds at `http://127.0.0.1:8788/index.html`.

## 2026-05-15 lobby UI correction

- Restored generated texture skins on lobby navigation, reward, and run buttons after the flat-button pass looked unfinished.
- Kept lower skin alpha so the borders are less harsh while preserving the authored button art.
- Reworked core selection cards into icon-led cards:
  - each card now shows a core-colored orb, title, and description as separate elements
  - the actual button is only a transparent click layer
  - selected card tint/description color still updates by core type
- Adjusted core-card vertical spacing so the selected badge no longer overlaps the description.
- Allowed the same button texture treatment on the smaller permanent-upgrade buttons so they no longer look like default rectangles.
- Re-exported the Web build, patched the Web shell, and confirmed local preview responses on:
  - `http://127.0.0.1:8787/index.html`
  - `http://127.0.0.1:8788/index.html`
- Final lobby screenshot after correction: `output/lobby-ui-correction-final-3/page.png`.

## 2026-05-15 global button border cleanup

- Centralized button border/skin opacity with shared constants in `scripts/Game.gd`.
- Reduced lobby texture-button opacity for all `_make_menu_button` controls, including:
  - opening/start buttons
  - lobby permanent-upgrade buttons
  - navigation buttons
  - ad reward buttons
  - detail overlay close/action buttons
- Reduced separate flat button borders used by detail, game-over, level-up choice, and reroll buttons.
- Re-exported the Web build, patched the shell, and confirmed local preview responses on ports `8787` and `8788`.
- Verified lobby render with no browser console errors:
  - `output/lobby-button-alpha-cleanup/lobby.png`

## 2026-05-15 button source image cleanup

- Backed up prior button textures under `output/asset-backups/`.
- Rebuilt `assets/images/ui_button_teal.png` as a cleaner high-resolution capsule source with no repeated corner dots or noisy edge pixels.
- Updated `scripts/UiTextureSkin.gd` to support 9-slice drawing so button corners and borders no longer get stretched when reused at different sizes.
- Wired lobby texture buttons in `scripts/Game.gd` to use shared 9-slice margins.
- Re-exported the Web build to `builds/web/index.html` and patched the Web shell.
- Verified with Godot `--check-only`, local responses on ports `8787` and `8788`, and Playwright screenshots with no browser console errors:
  - `output/button-source-polish-final/title.png`
  - `output/button-source-polish-final/lobby.png`

## 2026-05-16 button opacity correction

- Restored lobby/menu button texture opacity to full strength by changing `LOBBY_BUTTON_SKIN_ALPHA` and `LOBBY_PRIMARY_BUTTON_SKIN_ALPHA` to `1.0`.
- Re-exported and patched the Web build so the local browser preview uses the opaque button treatment.
- Verified Godot `--check-only`, local responses on ports `8787` and `8788`, and Playwright screenshots:
  - `output/button-opaque-final/title.png`
  - `output/button-opaque-final/lobby.png`

## 2026-05-16 core card character previews

- Replaced the lobby core-selection card orb placeholders with cropped character previews from the normalized core animation sheets.
- Added runtime-loaded preview sheet textures for purify, attack, and absorb cores.
- Adjusted core-card title/description/badge spacing so the selected badge no longer covers the description.
- Re-exported and patched the Web build, then verified Godot `--check-only` and the lobby screenshot with no browser console errors:
  - `output/core-card-character-preview-final/lobby.png`

## 2026-05-16 clean lobby panel texture

- Applied the user-provided `image/ChatGPT Image 2026년 5월 16일 오후 05_42_08.png` as `assets/images/ui_panel_cosmic.png`.
- Backed up the previous panel source to `output/asset-backups/ui_panel_cosmic-before-clean-panel-20260516.png`.
- Retuned `PANEL_SKIN_SOURCE_RECT` for the new image and added `PANEL_SKIN_SLICE_MARGINS`.
- Changed `_make_panel` to draw the lobby panel texture as 9-slice so wide/short panels no longer stretch the frame art directly.
- Re-exported and patched the Web build.
- Verified with Godot `--check-only`, the web-game Playwright client, and a direct browser screenshot with no console errors:
  - `output/panel-clean-check-opening2/shot-0.png`
  - `output/panel-clean-direct2/after-click-page.png`
