# AdMob 광고 연결

## 광고 단위

| 배치 | 형식 | AdMob 광고 단위 이름 | 실제 광고 단위 ID | 게임 내 사용 |
|---|---|---|---|---|
| `daily_bonus` | 보상형 | `CSCP_AOS_RV_DAILY_BONUS` | `ca-app-pub-4402708884038037/4886167222` | 로비 추가 보너스 파편 180 |
| `free_chest` | 보상형 | `CSCP_AOS_RV_FREE_CHEST` | `ca-app-pub-4402708884038037/6772070321` | 로비 무료 상자 파편 160~260 |
| `level_reroll` | 보상형 | `CSCP_AOS_RV_LEVEL_REROLL` | `ca-app-pub-4402708884038037/9264395931` | 레벨업 선택지 다시 뽑기 |
| `revive` | 보상형 | `CSCP_AOS_RV_REVIVE` | `ca-app-pub-4402708884038037/5077738911` | 사망 후 1회 부활 |
| `run_reward_2x` | 보상형 | `CSCP_AOS_RV_RUN_REWARD_2X` | `ca-app-pub-4402708884038037/8352745300` | 런 종료 보상 2배 |
| `temp_drone` | 보상형 | `CSCP_AOS_RV_TEMP_DRONE` | `ca-app-pub-4402708884038037/5458988651` | 다음 런 드론 1기 체험 |
| `run_end_5th` | 전면 | `CSCP_AOS_INT_RUN_END_5TH` | `ca-app-pub-4402708884038037/4642399306` | 런 종료마다 1회 노출 |

## 광고 제거 상품

- Google Play 상품 ID: `remove_ads`
- 적용 범위: `run_end_5th` 전면 광고 노출 차단.
- 보상형 광고는 사용자가 직접 선택하는 보상 수단이므로 `remove_ads` 구매 후에도 유지한다.

## 구현 위치

- `scripts/AdService.gd`: Godot 광고 서비스. 보상형/전면 광고 로드, 표시, 실패 콜백을 래핑한다.
- `scripts/Game.gd`: 런 종료 시 `remove_ads` 구매 상태를 확인해 전면 광고를 요청한다.
- `android/build/src/com/harness/coresurvivor/ads/CoreSurvivorAdMobPlugin.java`: Google Mobile Ads 보상형/전면 SDK 로드와 콜백.
- `android/build/AndroidManifest.xml`: AdMob App ID와 Godot v2 Android plugin 메타데이터.
- `android/build/build.gradle`: `com.google.android.gms:play-services-ads:25.2.0` 의존성.

## 빌드 정책

- Debug 빌드는 Google 테스트 광고 단위를 자동 사용한다.
- Release 빌드는 위 실제 광고 단위 ID를 사용한다.
- 전면 광고는 런 종료 후 결과 화면과 함께 요청한다.

## 검증 방법

- `godot --headless --path . --quit`로 GDScript 로드 확인.
- Android release AAB 빌드 후 `jarsigner -verify` 확인.
- 실제 Android 테스트 트랙에서 런 종료 시 전면 광고 표시 확인.
- `remove_ads` 구매 또는 복원 후 런 종료 시 전면 광고가 표시되지 않는지 확인.
