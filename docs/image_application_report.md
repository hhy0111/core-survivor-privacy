# 이미지 적용 리포트

작성일: 2026-05-06

## 적용 범위

현재 플레이 가능한 빌드에 직접 연결된 이미지만 `assets/images`와 `assets/icons`로 분리 적용했습니다. 원본 `image` 폴더는 용량이 크고 미사용 이미지가 많아서 Android/Web export에서 제외했습니다.

## 적용 완료 이미지

| 구분 | 적용 파일 | 적용 위치 | 확인 상태 |
|---|---|---|---|
| 오프닝 | `assets/images/title_key_art.png` | 첫 화면 배경 | 정상 |
| 로비 | `assets/images/lobby_background.png` | 로비 배경 | 정상 |
| 런 | `assets/images/stage1_background.png` | 게임 플레이 배경 | 정상 |
| 런 패럴랙스 | `stage1_far_stars_layer.png`, `stage1_asteroid_layer.png`, `stage1_energy_ring_layer.png` | 3중 이동 배경 레이어 | 정상 |
| 결과 | `assets/images/run_result_background.png` | 결과/보상 화면용 준비 | 적용 준비 완료 |
| 코어 | `core_purify_sheet.png`, `core_attack_sheet.png`, `core_absorb_sheet.png` | 플레이어 애니메이션 | 정상 |
| 코어 아이콘 | `core_purify_icon.png`, `core_attack_icon.png`, `core_absorb_icon.png` | 로비 코어 표시 | 정상 |
| 적 | `enemy_drifter_sheet.png`, `enemy_chaser_sheet.png`, `enemy_bulwark_sheet.png`, `enemy_splitter_sheet.png`, `enemy_elite_guard_sheet.png`, `enemy_boss_warden_sheet.png` | 적 스프라이트 | 정상 |
| 드론 | `drone_purify_sheet.png` | 정화 드론 | 정상 |
| 투사체 | `projectile_purify_bolt_sheet.png` | 자동 공격 탄 | 정상 |
| 경험치 | `xp_blue_gem_sheet.png`, `xp_large_gem_sheet.png` | 경험치 젬 | 정상 |
| 조작 UI | `joystick_base.png`, `joystick_knob.png` | 모바일 터치 조이스틱 | 정상 |
| 레벨업 UI | `upgrade_bolt_icon.png`, `upgrade_pulse_icon.png`, `upgrade_drone_icon.png`, `upgrade_magnet_icon.png`, `upgrade_speed_icon.png`, `upgrade_core_icon.png`, `reroll_button_icon.png` | 레벨업 선택/리롤 버튼 | 정상 |
| 광고 UI | `ad_reward_badge.png` | 로비 광고 보상 버튼 | 정상 |
| 앱 아이콘 | `assets/icons/main_192.png`, `adaptive_foreground_432.png`, `adaptive_background_432.png` | Android 런처 아이콘 | 적용 완료 |

## 검증 결과

브라우저 세로 해상도 `720x1280`에서 아래 화면을 확인했습니다.

- 오프닝: `builds/web/image-verify-phone-clean/01-opening-phone.png`
- 로비: `builds/web/image-verify-phone-clean/02-lobby-phone.png`
- 런 기본: `builds/web/image-verify-phone-clean/03-run-phone.png`
- 런 적/젬 노출: `builds/web/image-verify-phone-clean/04-run-enemy-phone.png`

검증 결과:

- 오프닝, 로비, 런 화면 전환 정상
- 한국어 텍스트 표시 정상
- 코어, 투사체, 경험치 젬, 적 스프라이트 노출 정상
- 스프라이트 런타임 알파 크롭/중앙 정렬 정상
- 데스크톱 브라우저에서도 9:16 Android 폰 프레임 중앙 고정 정상
- 레벨업 선택 패널과 선택 후 런 복귀 정상
- 주인공 코어 애니메이션은 행 기준 고정 스케일로 보정되어 프레임별 크기 흔들림과 옆 프레임 노출이 사라짐
- 2026-05-07 기준으로 `assets/images/normalized` 보정 시트를 추가 적용함. 각 프레임의 주요 불투명 연결 영역을 셀 중앙으로 재배치해 주인공/몬스터 기준점 흔들림을 줄임
- 주인공 코어는 추가 점검 결과 원본 idle 행의 0/5번 프레임과 1번 프레임 좌측 잔상이 문제였음. 보정본은 몸통/얼굴 중심 앵커와 `1,2,3,4,3,2` 안정 프레임 루프로 교체함
- Playwright 콘솔 오류 없음
- Web export 캔버스가 세로 화면으로 고정되도록 `html/canvas_resize_policy=0` 및 `tools/patch_web_export.ps1` 적용

추가 확인 스크린샷:

- 데스크톱 폰 프레임 오프닝: `builds/web/verify-latest/desktop-page-opening.png`
- 데스크톱 폰 프레임 로비: `builds/web/verify-latest/desktop-page-lobby.png`
- 데스크톱 폰 프레임 런: `builds/web/verify-latest/desktop-page-run.png`
- 레벨업 선택 패널: `builds/web/verify-latest/phone-levelup-or-run.png`
- 선택 후 런 복귀: `builds/web/verify-latest/phone-after-upgrade-choice.png`

Android AAB도 새로 생성했습니다.

- 파일: `builds/android/core-survivor-images-v4.aab`
- versionCode: `4`
- versionName: `0.1.3`
- SHA256: `246856B18583393C1BF7494BCDC5EBB0BBDAB19B163D3A0C445DDC0FE36E64F2`
- 서명 검증: `jarsigner` 기준 `jar verified`
- 확인: `docs/`, `tools/`, `private/`, 원본 `image/` 폴더는 AAB에 포함되지 않음

## 문제가 있었던 이미지

아래 문제는 원본 `image` 폴더 기준으로 남아 있습니다.

| 문제 | 영향 | 처리 |
|---|---|---|
| 투명 배경이어야 할 스프라이트에 흰/회색 체크보드가 실제 픽셀로 들어감 | 게임 화면에서 네모 배경 노출 | `assets/images` 적용본만 `tools/clean_checker_alpha.ps1`로 셀 단위 알파 처리 |
| 일부 시트 크기가 셀 단위로 딱 나누어지지 않음 | 애니메이션 프레임 절단 여지 | 런타임 알파 크롭으로 대응, 최종 이미지는 정확한 그리드로 재생성 필요 |
| 각 셀 내부에서 캐릭터/몬스터 중심이 밀려 있음 | 프레임마다 앞뒤로 움직이는 것처럼 보임 | `tools/normalize_sprite_sheets.ps1`로 보정본 생성 후 `assets/images/normalized`를 런타임에 적용 |
| 주인공 코어 idle 원본 0/5프레임이 좌우로 튀고 1프레임 좌측에 이전 프레임 조각이 있음 | 가만히 있어도 좌우 이동/잔상처럼 보임 | 주인공 코어 보정본에서 중간 정상 프레임만 사용해 `1,2,3,4,3,2` 루프로 재구성 |
| Google Play 그래픽 크기가 파일명과 다름 | 스토어 등록 시 리사이즈/재생성 필요 | 추가 프롬프트 문서에 exact size 재생성 요청 추가 |
| 많은 이미지가 아직 대응 시스템 없음 | 무기 도감, 상점, 진화, Stage 2/3 화면에서는 미사용 | 해당 화면 구현 시 연결 예정 |

## 미사용 이미지 정리

현재 빌드에 아직 직접 연결하지 않은 그룹:

- Stage 2/3 배경 레이어 및 보스 오버레이
- 8종 무기 아이콘과 이펙트 전체
- 6종 진화 이펙트
- 6종 드론 아이콘/상점 이미지
- 아직 연결하지 않은 나머지 영구 강화 아이콘
- 아직 연결하지 않은 상품 팩 이미지
- UI 9-slice 패널 이미지

이 이미지는 게임 시스템과 화면이 아직 구현되지 않았거나 현재 MVP 화면에 노출 위치가 없어서 보류했습니다.

## 추가 프롬프트 기록

로비 버튼과 패널은 현재 코드 드로잉만으로는 상업 게임 느낌이 부족해서, `docs/additional_image_prompts.md`의 `9. 로비 전체 UI 리디자인 이미지 세트`에 별도 제작 프롬프트를 추가했습니다. 다음 이미지 제작 시 이 세트를 우선 생성한 뒤 로비 UI에 9-slice로 적용하면 됩니다.

## 2026-05-07 생성 이미지 추가 적용

새로 생성된 `image` 폴더 이미지 중 게임 화면에 바로 안전하게 적용 가능한 항목만 추출해 적용했습니다.

| 원본 파일 | 변환/적용 파일 | 적용 위치 | 확인 상태 |
|---|---|---|---|
| `image/05-item-10.png` | `assets/images/lobby_background_v2.png` | 로비 배경 | 정상 |
| `image/04-ui-9-slice.png` | `assets/images/ui_button_teal.png` | 오프닝/로비 버튼 스킨 | 정상 |
| `image/06-ui.png` | `assets/images/ui_panel_cosmic.png` | 로비 패널 스킨 | 정상 |
| `image/05-item-08.png` | `assets/images/ui_ad_reward_badge_v2.png` | 광고 보상 버튼 아이콘 | 정상 |
| `image/05-item-09.png` | `assets/images/ui_daily_reward_badge.png` | 일일 보급 버튼 아이콘 | 정상 |

적용 방식:

- `tools/extract_generated_ui_assets.ps1`로 원본 이미지의 배경을 제거하거나 필요한 이미지를 `assets/images`로 복사했습니다.
- `scripts/Game.gd`에서 로비 배경, 버튼 StyleBoxTexture, 패널 StyleBoxTexture, 광고/일일 보상 아이콘을 새 파일로 연결했습니다.
- 버튼 이미지는 `TextureRect` 방식에서 원본 크기가 삐져나오는 문제가 있어 `StyleBoxTexture` 방식으로 고쳐 지정된 버튼 영역 안에서만 렌더링되게 했습니다.

확인 스크린샷:

- 오프닝: `builds/web/verify-new-ui-assets-v2/opening-phone-patched.png`
- 로비: `builds/web/verify-new-ui-assets-v2/lobby-phone-patched.png`
- 런 화면: `builds/web/verify-new-ui-assets-v2/run-phone-patched.png`
- Playwright 기본 검증: `builds/web/verify-new-ui-assets-final-client/shot-0.png`

이번에 보류한 이미지:

| 원본 파일 | 보류 이유 |
|---|---|
| `image/01-item-01.png` | 우주비행사형 캐릭터 이미지라 현재 코어 생명체 주인공과 디자인 방향이 다르고, 배경이 투명하지 않음 |
| `image/02-exact-size.png` | 경험치 젬 이미지가 이미 안정 적용되어 있으며, 새 파일은 단일 런타임 시트 구조가 아님 |
| `image/03-google-play.png` | 스토어/런처 아이콘 후보로는 사용 가능하지만 현재 게임 화면 적용 대상은 아님 |
| `image/07-1.png` | 레이어 시트 안에 라벨/설명 텍스트가 포함되어 있어 바로 배경 레이어로 사용하면 텍스트가 노출됨 |
| `image/08-item-14.png` | 스프라이트 시트에 라벨/배경색이 포함되어 있어 런타임 캐릭터/몬스터 교체 시 잔상과 투명도 문제가 재발할 수 있음 |
| `image/09-ui.png` | UI 시트에 라벨/설명 텍스트가 포함되어 있어 직접 적용 시 화면에 텍스트가 노출됨 |

## 2026-05-09 추가 코멧 미사일 이미지 적용

새로 추가된 `image/additional_image_prompts` 이미지 5개를 확인했고, 실제 프레임 수에 맞춰 런타임용 PNG로 정리했습니다.

| 원본 파일 | 변환/적용 파일 | 적용 위치 | 확인 상태 |
|---|---|---|---|
| `image/additional_image_prompts/10-item-18.png` | `assets/images/comet_missile_sheet.png` | 코멧 미사일 발사체 | 정상 |
| `image/additional_image_prompts/19-2.png` | `assets/images/comet_explosion_sheet.png` | 코멧 미사일 폭발 이펙트 | 정상 |
| `image/additional_image_prompts/20-3.png` | `assets/images/comet_fragment_sheet.png` | 코멧 미사일 파편 발사체 | 정상 |
| `image/additional_image_prompts/21-4.png` | `assets/images/upgrade_missile_icon.png` | 레벨업 미사일 업그레이드 아이콘 | 정상 |
| `image/additional_image_prompts/22-5.png` | `assets/images/comet_levelup_card_art.png` | 보류: 카드 일러스트 후보 | 미연결 |

적용 메모:

- 원본 생성물은 프롬프트 예상과 다르게 미사일 9프레임, 파편 7프레임, 폭발 7x2프레임으로 나왔습니다. 잘리는 문제를 막기 위해 런타임 시트도 이 프레임 수 기준으로 정리했고, `Projectile.gd`와 `SpriteSheetEffect.gd`도 같은 프레임 수를 사용합니다.
- `22-5.png`는 배경과 전투 장면이 포함된 카드 일러스트라 레벨업 선택 카드에 바로 쓰면 가독성과 크롭 문제가 생길 수 있어 현재는 연결하지 않았습니다.
- 검증 스크린샷:
  - `builds/web/verify-comet-assets-direct4/01-lobby.png`
  - `builds/web/verify-comet-assets-direct4/02-gameplay-comet.png`
  - `builds/web/verify-comet-assets-direct4/03-gameplay-comet-later.png`
- 콘솔 오류: `builds/web/verify-comet-assets-direct4/errors.json` 기준 없음
