Original prompt: AGENTS.md 기준으로 Core Survivor: Cosmic Purge를 Google Android 전용 2D 모바일 survivor-like 게임으로 개발하고, 이후 로비/브라우저 화면/이미지 프롬프트/AdMob 광고 연결 작업을 진행.

## 2026-05-05

- AdMob 보상형 광고 6개를 Android 네이티브 플러그인과 GDScript 래퍼로 연결.
- Debug APK는 Google 테스트 보상형 광고 단위를 자동 사용하고, Release 빌드에서는 실제 AdMob 광고 단위 ID를 사용하도록 구성.
- 로비 광고 보상 3개, 레벨업 리롤, 사망 부활, 런 종료 보상 2배 진입점을 구현.
- Android Gradle 빌드 템플릿 설치 및 Google Mobile Ads SDK 의존성 추가.
- APK 빌드 및 서명 검증 완료. 다음 확인은 Web 미리보기 UI와 실제 Android 기기 광고 로드 테스트.
- Web 빌드 재생성 후 `admob-opening-check.png`, `admob-lobby-check.png`, `admob-web-fallback-check.png`로 광고 버튼 배치와 Web fallback 안내를 확인.
- 남은 일: 실제 Android 기기에 Debug APK 설치 후 테스트 광고 노출/보상 콜백이 동작하는지 확인.
