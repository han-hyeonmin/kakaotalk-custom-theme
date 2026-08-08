# 심플 라이트 (카카오톡 사용자 테마)

> **📱 iOS 카카오톡 전용입니다.** Android·PC 카카오톡은 테마 형식이 달라 적용되지 않습니다.

튜닝의 끝은 순정. 카카오톡 채팅방의 익숙한 느낌은 그대로 두고, 인스타그램의 하얀 화면과
군더더기 없는 기본 프로필 인상만 옮겨 왔습니다. 메인·탭바를 거의 흰색(`#FFFFFE`)으로
맞추고 기본 프로필 이미지를 바꾼 게 전부이며, 나머지는 모두 카카오톡 기본값입니다.

|  | 값 |
|---|---|
| 메인 / 탭바 배경 | `#FFFFFE` |
| 기본 프로필 이미지 | `profileImg01@3x.png` |
| 지원 | **iOS 카카오톡 전용** (iPhone / iPad) |

---

## 📲 설치 (아이폰에서 30초)

### 가장 쉬운 방법 — 설치 페이지 열기

**👉 [han-hyeonmin.github.io/kakaotalk-custom-theme](https://han-hyeonmin.github.io/kakaotalk-custom-theme/)**

아이폰 Safari로 위 페이지를 열고 **「카카오톡으로 테마 공유하기」** 버튼을 누르면
공유 시트가 바로 뜹니다. **카카오톡 → 나에게**를 고른 다음,
채팅방에 도착한 파일을 **탭 → 「테마 적용하기」** 하면 끝입니다.

> PC에서 보고 있다면 위 링크를 카카오톡 **나에게** 보낸 뒤, 아이폰에서 여세요.

### 파일을 직접 받는 방법

1. 아이폰에서 [`custom-light.ktheme` 내려받기](https://han-hyeonmin.github.io/kakaotalk-custom-theme/download/custom-light.ktheme)
2. 받은 파일을 카카오톡 **나에게** 공유
3. 채팅방에서 파일을 **탭** → **「테마 적용하기」**
4. 카카오톡이 재시작되면 적용 완료

---

## ⚠️ 안 될 때 확인할 것

- **Android·PC 카카오톡에서는 적용되지 않습니다.** iOS 카카오톡 전용 형식입니다.
- 파일 앱이나 다운로드 매니저를 거치면 확장자가 `.zip`으로 바뀌는 경우가 있습니다.
  이때는 **채팅방에 공유해서 바로 탭**하는 경로를 쓰세요.
- 되돌리기: `더보기 ⋯` → `설정 ⚙︎` → `테마` → **기본 테마** 선택

---

## 🛠 직접 고쳐 쓰기

```
themes/
└─ custom-light/             # 폴더명이 곧 .ktheme 파일명이 된다
   ├─ KakaoTalkTheme.css     # 테마 정의
   └─ Images/
      ├─ commonIcoTheme.png  # 테마 목록에 뜨는 썸네일 (162×162)
      └─ profileImg01@3x.png # 기본 프로필 이미지

docs/                        # GitHub Pages 로 배포되는 설치 페이지
└─ download/                 # build.sh 결과물이 놓이는 곳
   └─ custom-light.ktheme
```

색만 바꾸고 싶다면 `KakaoTalkTheme.css`의 `background-color` 값만 고치면 됩니다.
`ManifestStyle`의 `-kakaotalk-theme-name`, `-kakaotalk-author-name` 도 본인 것으로 바꿔 주세요.

### 버전 규칙

`YY.M.patch` (날짜 기반). 카카오 공식 샘플 테마도 같은 형식을 씁니다 (`Apeach` = `25.8.0`).
`-kakaotalk-theme-version` 과 릴리스 태그를 같은 값으로 맞춥니다 (현재 `26.8.0` = `v26.8.0`).

같은 달에 두 번 고치면 `26.8.1`. 테마에는 "호환성이 깨지는 변경"이라는 개념이 없어
semver 의 major/minor 구분이 의미가 없으므로 날짜만 씁니다.
`v1.0.0`~`v1.0.2` 태그는 semver 를 쓰던 시절의 것으로 그대로 남겨 둡니다.

### 빌드

```bash
./build.sh              # themes/ 하위 전체를 패키징
./build.sh custom-light # 특정 테마만
```

결과물은 `docs/download/<테마명>.ktheme` 에 생성됩니다 (설치 페이지가 그대로 배포하는 경로).

### `.ktheme` 를 손으로 만들 때 주의할 점

`.ktheme` 는 **확장자만 바꾼 zip** 입니다. 다만 압축 방식이 중요합니다.

```
✅ 올바름                    ❌ 적용 안 됨
custom-light.ktheme         custom-light.ktheme
├─ KakaoTalkTheme.css       └─ custom-light/
└─ Images/                     ├─ KakaoTalkTheme.css
   └─ *.png                    └─ Images/
```

- 폴더째 압축하면 안 됩니다. **폴더 안에 들어가서 내용물을 선택해 압축**하세요.
  (Finder에서 폴더를 우클릭 → 압축 ❌ / 폴더 안의 파일들을 모두 선택 → 압축 ⭕)
- macOS가 넣는 `.DS_Store` 와 `__MACOSX/` 는 제거하는 게 안전합니다.
  `build.sh` 는 `zip -X` 와 `-x` 옵션으로 이 둘을 모두 걸러냅니다.

---

## 라이선스 및 이미지 출처

자산별 적용 범위는 [NOTICE](NOTICE) 참고. CSS와 빌드 스크립트는 [MIT](LICENSE). 카카오톡 및 KakaoTalk 은 주식회사 카카오의 상표이며,
이 저장소는 카카오와 무관한 개인 제작 테마입니다.

### ⚠️ 기본 프로필 이미지 저작권 미상

`Images/profileImg01@3x.png` (기본 프로필 실루엣)는 **출처와 저작권자가 확인되지 않은 파일**입니다.
제작 과정에서 유입된 경로를 특정하지 못했고, 저작권 상태를 확인할 수 없는 상태임을 밝힙니다.

- 이 이미지는 MIT 라이선스 적용 대상이 **아닙니다**. 재사용 시 이용자 본인 책임으로 판단해 주세요.
- 권리자이시거나 출처를 아신다면 [이슈](https://github.com/han-hyeonmin/kakaotalk-custom-theme/issues)로
  알려 주세요. **요청을 받으면 즉시 교체하거나 삭제**하겠습니다.

테마 썸네일 `Images/commonIcoTheme.png` 는 이 저장소에서 직접 제작한 이미지이며 MIT 적용 대상입니다.
