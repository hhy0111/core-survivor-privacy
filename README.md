# Core Survivor: Cosmic Purge

Google Play Android 전용 2D 탑다운 survivor-like 모바일 게임의 Godot 4.3 초기 수직 슬라이스입니다.

현재 빌드는 출시 완성본이 아니라 핵심 재미 검증용입니다. 터치/마우스 왼쪽 드래그 또는 WASD/방향키로 이동하고, 코어는 가장 가까운 적을 자동 공격합니다. 적 처치 후 XP를 흡수하면 레벨업 3지선다가 열리고 선택 즉시 런 중 성장이 반영됩니다.

## 현재 목표

- 목표: 5분 런에서 이동, 자동 공격, 적 처치, XP 흡수, 레벨업 선택, 광고 보상 진입점, 첫 엘리트/보스 출현까지 검증한다.
- 구현 범위: Godot 4.3 2D 런타임, 모바일 portrait 해상도, Android Gradle debug export preset, AdMob 보상형 광고 6종.
- 성공 기준: Godot에서 메인 씬이 오류 없이 실행되고 레벨업 선택과 광고 보상 버튼이 실제 게임 보상 흐름에 반영된다.
- 검증 방법: `godot --headless --path . --quit`로 프로젝트 로드 확인 후 에디터 또는 Android debug APK로 수동 플레이한다.
- 실패 시 수정 방향: 오류 로그 기준으로 GDScript 문법, export preset, 모바일 입력 처리 순서로 좁혀 수정한다.

## 실행

```powershell
godot --path .
```

## Android debug export

```powershell
New-Item -ItemType Directory -Force builds/android
$root = (Get-Location).Path
godot --headless --export-debug "Android Debug" "$root\builds\android\core-survivor-debug.apk" "$root\project.godot"
```

Debug APK는 AdMob 계정 보호를 위해 Google 테스트 보상형 광고 단위를 사용합니다. Release 빌드는 `android/build/src/com/harness/coresurvivor/ads/CoreSurvivorAdMobPlugin.java`에 등록된 실제 광고 단위 ID를 사용합니다.

## Web browser preview

```powershell
New-Item -ItemType Directory -Force builds/web
$root = (Get-Location).Path
godot --headless --export-debug "Web Debug" "$root\builds\web\index.html" "$root\project.godot"
powershell -ExecutionPolicy Bypass -File tools\patch_web_export.ps1 builds\web\index.html
python -m http.server 8787 --bind 127.0.0.1 --directory builds\web
```

`tools/patch_web_export.ps1` removes the Godot Web loading splash so the browser preview opens directly into the game.
It also frames the Web preview as a centered 9:16 phone screen so desktop browsers match the Android portrait layout.

AdMob 광고, Google Play Billing, 릴리스 서명은 Android Gradle 빌드에 연결되어 있습니다. Play Console에는 코드의 광고 단위와 상품 ID가 동일하게 등록되어 있어야 합니다.
