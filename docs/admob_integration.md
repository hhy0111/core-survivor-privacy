# AdMob 보상형 광고 연결

## 광고 단위

| 배치 | AdMob 광고 단위 이름 | 실제 광고 단위 ID | 게임 보상 |
|---|---|---|---|
| `daily_bonus` | `CSCP_AOS_RV_DAILY_BONUS` | `ca-app-pub-4402708884038037/4886167222` | 로비 추가 보너스 파편 180 |
| `free_chest` | `CSCP_AOS_RV_FREE_CHEST` | `ca-app-pub-4402708884038037/6772070321` | 로비 무료 상자 파편 160~260 |
| `level_reroll` | `CSCP_AOS_RV_LEVEL_REROLL` | `ca-app-pub-4402708884038037/9264395931` | 레벨업 선택지 다시 뽑기 |
| `revive` | `CSCP_AOS_RV_REVIVE` | `ca-app-pub-4402708884038037/5077738911` | 사망 후 1회 부활 |
| `run_reward_2x` | `CSCP_AOS_RV_RUN_REWARD_2X` | `ca-app-pub-4402708884038037/8352745300` | 런 종료 보상 2배 |
| `temp_drone` | `CSCP_AOS_RV_TEMP_DRONE` | `ca-app-pub-4402708884038037/5458988651` | 다음 런 드론 1기 체험 |

## 구현 위치

- `scripts/AdService.gd`: Godot 런타임 광고 래퍼. Android 플러그인이 없으면 보상을 지급하지 않고 안내 메시지만 표시한다.
- `android/build/src/com/harness/coresurvivor/ads/CoreSurvivorAdMobPlugin.java`: Google Mobile Ads Rewarded SDK 로드/표시/보상 콜백.
- `android/build/AndroidManifest.xml`: AdMob App ID와 Godot v2 Android plugin 메타데이터.
- `android/build/build.gradle`: `com.google.android.gms:play-services-ads:25.2.0` 의존성.

## 빌드 정책

- Debug APK는 `ca-app-pub-3940256099942544/5224354917` 테스트 보상형 광고 단위를 자동 사용한다.
- Release 빌드는 위 표의 실제 광고 단위 ID를 사용한다.
- 배너, 전면, 앱 오프닝, 보상형 전면 광고는 사용하지 않는다.

## 검증 방법

- `godot --headless --path . --quit`로 GDScript 로드 확인.
- Android Gradle debug export 후 `apksigner verify --verbose builds/android/core-survivor-debug.apk` 확인.
- `aapt2 dump xmltree --file AndroidManifest.xml`로 `com.google.android.gms.ads.APPLICATION_ID`와 `org.godotengine.plugin.v2.CoreSurvivorAdMob` 메타데이터 확인.
- 실제 Android 기기에서 Debug APK를 설치하고 테스트 광고 라벨이 붙은 보상형 광고가 뜨는지 확인.
