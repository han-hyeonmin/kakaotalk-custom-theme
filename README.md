# 커스텀 테마 라이트 모드 (카카오톡 사용자 테마)

담백한 라이트 톤 카카오톡 사용자 테마입니다. 메인·탭바는 거의 흰색(`#FFFFFE`),
채팅방 배경은 차분한 블루그레이(`#ABC1D1`)로 맞췄습니다.

|  | 값 |
|---|---|
| 메인 / 탭바 배경 | `#FFFFFE` |
| 채팅방 배경 | `#ABC1D1` |
| 안읽음 표시 글자색 | `#556274` |
| 지원 | iOS · Android 카카오톡 (모바일 전용) |

---

## 📲 설치 (휴대폰에서 30초)

### 가장 쉬운 방법 — 설치 페이지 열기

**👉 [han-hyeonmin.github.io/kakaotalk-custom-theme](https://han-hyeonmin.github.io/kakaotalk-custom-theme/)**

휴대폰 브라우저로 위 페이지를 열고 **「카카오톡으로 테마 공유하기」** 버튼을 누르면
공유 시트가 바로 뜹니다. **카카오톡 → 나와의 채팅**을 고른 다음,
채팅방에 도착한 파일을 **탭 → 「테마 적용하기」** 하면 끝입니다.

> PC에서 보고 있다면 이 QR 대신, 위 링크를 카카오톡으로 자신에게 보내서 휴대폰에서 여세요.

### 파일을 직접 받는 방법

1. 휴대폰에서 [`custom_light.ktheme` 내려받기](https://han-hyeonmin.github.io/kakaotalk-custom-theme/themes/custom_light.ktheme)
2. 받은 파일을 카카오톡 **나와의 채팅**으로 공유
3. 채팅방에서 파일을 **탭** → **「테마 적용하기」**
4. 카카오톡이 재시작되면 적용 완료

---

## ⚠️ 안 될 때 확인할 것

- **사용자 테마가 꺼져 있으면 적용 버튼이 안 나옵니다.**
  카카오톡 `더보기 ⋯` → `설정 ⚙︎` → `테마` → **사용자 테마** 를 켜 주세요.
- **PC 카카오톡에서는 적용되지 않습니다.** 반드시 모바일 앱에서 여세요.
- 파일 앱이나 다운로드 매니저를 거치면 확장자가 `.zip`으로 바뀌는 경우가 있습니다.
  이때는 **채팅방에 공유해서 바로 탭**하는 경로를 쓰세요.
- 되돌리기: `더보기 ⋯` → `설정 ⚙︎` → `테마` → **기본 테마** 선택

---

## 🛠 직접 고쳐 쓰기

```
01_Custom/
└─ custom_light/
   ├─ KakaoTalkTheme.css     # 테마 정의
   └─ Images/
      ├─ commonIcoTheme.png  # 테마 목록에 뜨는 썸네일 (162×162)
      └─ profileImg01@3x.png # 기본 프로필 이미지
```

색만 바꾸고 싶다면 `KakaoTalkTheme.css`의 `background-color` 값만 고치면 됩니다.
`ManifestStyle`의 `-kakaotalk-theme-name`, `-kakaotalk-author-name`도 본인 것으로 바꿔 주세요.

### 빌드

```bash
./build.sh              # 01_Custom 하위 전체를 패키징
./build.sh custom_light # 특정 테마만
```

결과물은 `docs/themes/<테마명>.ktheme` 에 생성됩니다 (설치 페이지가 그대로 배포하는 경로).

### `.ktheme` 를 손으로 만들 때 주의할 점

`.ktheme` 는 **확장자만 바꾼 zip** 입니다. 다만 압축 방식이 중요합니다.

```
✅ 올바름                    ❌ 적용 안 됨
custom_light.ktheme         custom_light.ktheme
├─ KakaoTalkTheme.css       └─ custom_light/
└─ Images/                     ├─ KakaoTalkTheme.css
   └─ *.png                    └─ Images/
```

- 폴더째 압축하면 안 됩니다. **폴더 안에 들어가서 내용물을 선택해 압축**하세요.
  (Finder에서 폴더를 우클릭 → 압축 ❌ / 폴더 안의 파일들을 모두 선택 → 압축 ⭕)
- macOS가 넣는 `.DS_Store` 와 `__MACOSX/` 는 제거하는 게 안전합니다.
  `build.sh` 는 `zip -X` 와 `-x` 옵션으로 이 둘을 모두 걸러냅니다.

---

## 라이선스

CSS와 빌드 스크립트는 [MIT](LICENSE). 카카오톡 및 KakaoTalk 은 주식회사 카카오의 상표이며,
이 저장소는 카카오와 무관한 개인 제작 테마입니다.
