# Core Survivor: Cosmic Purge 구현 계획

## 9. 개발 구조 설계

* 담당 에이전트: Dev Agent A, Dev Agent B, Dev Lead
* 목표: 개인 개발자가 유지 가능한 Godot 4.3 Android 2D 구조를 확정한다.
* 구현/기획 범위: 단일 런 씬, 코드 기반 엔티티 생성, 거리 기반 충돌, 모바일 터치 스틱, Android export preset.
* 산출물: `project.godot`, `scenes/Main.tscn`, `scripts/*.gd`, `export_presets.cfg`.
* 발견된 문제: 작업공간이 비어 있어 기존 엔진 선택 근거가 없었다.
* 수정 지시: 설치된 Godot 4.3과 Android export template을 활용해 Godot 기준으로 시작한다.
* 성공 기준: 프로젝트가 Godot에서 열리고 메인 씬이 로드된다.
* 검증 방법: Godot headless 로드, 에디터 실행, Android debug export, `apksigner verify`.
* 승인 상태: Approved

## 10. 구현 계획 수립

* 담당 에이전트: Command Agent / PM, Dev Lead
* 목표: 첫 구현을 출시 전체가 아니라 핵심 재미 검증용 5분 수직 슬라이스로 제한한다.
* 구현/기획 범위: 이동, 자동 공격, 적 스폰, XP 드랍/흡수, 레벨업 3지선다, 드론/펄스/흡수 강화, 엘리트/보스 1종씩.
* 산출물: 플레이 가능한 초기 런타임.
* 발견된 문제: MVP 전체 필수 수량을 한 번에 구현하면 개인 개발 범위를 초과한다.
* 수정 지시: 전체 수량은 GDD/밸런스 문서로 확정하고, 코드 구현은 반복 검증 가능한 세로 조각부터 진행한다.
* 성공 기준: 레벨업 선택이 즉시 자동 공격 또는 생존 수치에 반영된다.
* 검증 방법: 3레벨 이상 플레이하며 볼트, 펄스, 드론, 흡수, 속도, 체력 업그레이드를 각각 선택한다.
* 승인 상태: Approved

## 11. 내부 검수

* 담당 에이전트: Dev Lead, Game Design Lead, Visual Design Lead
* 목표: 초기 구현이 과한 구조 없이 핵심 루프를 검증하는지 확인한다.
* 구현/기획 범위: 코드 구조, 대량 적 처리 가능성, 모바일 가독성, UI 흐름.
* 산출물: 내부 검수 메모.
* 발견된 문제: 현재 충돌은 물리 엔진이 아니라 거리 기반 루프이므로 적 수가 커질수록 O(n*m) 비용이 발생한다. Android export는 ETC2/ASTC import 설정이 꺼져 있으면 설정 오류로 중단된다.
* 수정 지시: 첫 수직 슬라이스는 `MAX_ENEMIES`와 projectile 수 제한으로 관리하고, 2차 구현에서 spatial bucket 또는 Area2D 풀링 도입 여부를 측정 후 결정한다. Android용 texture import 설정은 `project.godot`에 고정한다.
* 성공 기준: 5분 런에서 입력, 공격, XP, 레벨업이 끊기지 않는다.
* 검증 방법: 데스크톱 실행, Android debug APK export, APK 서명 검증, Android 기기 수동 플레이.
* 승인 상태: Approved

## 다음 구현 순서

1. Android 기기에서 debug APK 입력/프레임 확인.
2. 무기 8종 중 3종을 실제 동작까지 확장.
3. 저장 데이터와 영구 업그레이드 10종의 단순 JSON 구조 구현.
4. AdMob 보상형 광고 인터페이스와 실패 처리 화면 구현.
5. Google Play Billing 상품 5종의 구매 상태 저장과 복구 흐름 구현.
