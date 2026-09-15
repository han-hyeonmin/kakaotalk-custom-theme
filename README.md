# 심플 라이트 (카카오톡 사용자 테마)

> **📱 `.ktheme` 는 iOS 전용입니다.** 안드로이드 카카오톡 테마는 APK 형식이라 따로 빌드해야 합니다 — [`android/`](android/) 참고. PC 카카오톡은 지원하지 않습니다.

튜닝의 끝은 순정. 카카오톡 채팅방의 익숙한 느낌은 그대로 두고, 하얀 화면과
군더더기 없는 기본 프로필 인상만 옮겨 왔습니다. 채팅방·말풍선·탭 아이콘은 모두 카카오톡 기본값입니다.

|  | 값 |
|---|---|
| 메인 / 탭바 배경 | `#FFFFFF` |
| 리스트 이름 | `#666666` |
| 라스트메시지 · 상태메시지 | `#8E8E93` |
| 기본 프로필 이미지 | `profileImg01@3x.png` |
| 지원 | iOS는 `.ktheme` 즉시 적용 · Android는 [소스 빌드](android/) |

> **왜 이름이 회색인가** — `-ios-text-color` 하나가 리스트 이름과 함께
> **통화 발신 버튼의 원**, **헤더 아이콘**, **더보기탭 그리드 타일 배경**(알파 6%)까지
> 결정합니다. 하나만 따로 조정할 수 없어 `#666666`에서 절충했습니다 —
> WCAG AA(4.5:1)를 지키는 한계선입니다.
> 실측한 키 매핑은 [KEYMAP.md](KEYMAP.md) 에 있습니다 (**가이드가 여섯 군데 어긋납니다**).
> 계산과 되돌리는 법은 `themes/custom-light/KakaoTalkTheme.css` 주석에 있습니다.

---

## 📲 설치 (아이폰에서 30초)

### 카카오톡 안에서 링크 누르기 (가장 짧음)

**👉 [han-hyeonmin.github.io/kakaotalk-custom-theme](https://han-hyeonmin.github.io/kakaotalk-custom-theme/)**

위 주소를 카카오톡 **나에게** 보낸 뒤 아이폰에서 누르면, 카카오톡 인앱 브라우저가
`.ktheme` 를 직접 받아 **「테마 다운로드 완료」** 안내창을 띄웁니다.
**「테마 목록보기」** → **심플 라이트** 선택 → 카카오톡 재시작이면 끝입니다.
같은 안내창의 **「테마 파일 공유하기」** 로 받은 파일을 친구에게 바로 넘길 수도 있습니다.

사파리에서 열어도 됩니다. 이때는 **「카카오톡으로 열기」** 버튼이 대신 뜨고,
누르면 같은 안내창으로 이어집니다.

> 파일을 파일 앱에 저장하는 경로는 권하지 않습니다. 저장을 거치면 확장자가
> `.zip` 으로 바뀌어 인식되지 않는 경우가 있습니다.

---

## ⚠️ 안 될 때 확인할 것

- **이 `.ktheme` 파일은 Android·PC 카카오톡에서 적용되지 않습니다.** iOS 전용 형식입니다.
  안드로이드는 [`android/`](android/) 의 소스를 직접 빌드해야 합니다.
- 파일 앱이나 다운로드 매니저를 거치면 확장자가 `.zip`으로 바뀌는 경우가 있습니다.
  이때는 **카카오톡 안에서 링크를 바로 누르는** 경로를 쓰세요.
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

tools/
└─ make-icon.py              # commonIcoTheme.png 생성기

android/                     # 안드로이드 판 (APK 소스. 카카오 샘플 위에 얹는다)
├─ theme/values/colors.xml   # 무채색 44색
├─ apply.sh                  # 샘플에 얹고 어피치 아트워크를 걷어낸다
└─ make-splash.py            # 테마 앱 실행화면을 단색으로

docs/                        # GitHub Pages 로 배포되는 설치 페이지
└─ download/                 # build.sh 결과물이 놓이는 곳
   └─ custom-light.ktheme
```

색만 바꾸고 싶다면 `KakaoTalkTheme.css`의 `background-color` 값만 고치면 됩니다.
안드로이드 판은 [`android/README.md`](android/README.md) 를 보세요.
`ManifestStyle`의 `-kakaotalk-theme-name`, `-kakaotalk-author-name` 도 본인 것으로 바꿔 주세요.

### 목록 아이콘 (`commonIcoTheme.png`)

**모서리를 굽지 않고 162×162 를 꽉 채워서 만듭니다.** 카카오톡이 목록에 그릴 때
자기 라운드 마스크와 테두리를 씌우기 때문입니다. 이미지 쪽에서 미리 곡률을 넣으면
앱 마스크 안쪽에서 이미지가 먼저 끝나 버려, 그 틈으로 목록 배경(흰색)이 비치고
기본 테마 아이콘들 사이에서 혼자 곡률이 어긋나 보입니다.

```bash
python3 tools/make-icon.py   # Pillow 필요. themes/custom-light/Images/ 에 162×162 로 생성
```

색·마크는 `tools/make-icon.py` 위쪽 상수(`BG`, `FG`, `BUBBLE`, `TAIL`)만 고치면 됩니다.
안쪽 말풍선 모서리에는 iOS 앱 아이콘과 같은 연속 곡률(스쿼클)을 씁니다.

### 버전 규칙

`YY.M.patch` (날짜 기반). 카카오 공식 샘플 테마도 같은 형식을 씁니다 (`Apeach` = `26.7.0`).
`-kakaotalk-theme-version` 과 릴리스 태그를 같은 값으로 맞춥니다 (`26.9.4` ↔ `v26.9.4`).

버전을 올릴 때는 **태그와 GitHub 릴리스를 함께** 만들고, 릴리스에 그 버전의
`custom-light.ktheme` 를 첨부합니다. 태그만 남기면 릴리스 목록의 "Latest" 가
실제 배포본과 어긋납니다.

같은 달에 두 번 고치면 `26.8.1`. 테마에는 "호환성이 깨지는 변경"이라는 개념이 없어
semver 의 major/minor 구분이 의미가 없으므로 날짜만 씁니다.
`v1.0.0`, `v1.0.1` 태그는 semver 를 쓰던 시절의 것으로 그대로 남겨 둡니다.

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
