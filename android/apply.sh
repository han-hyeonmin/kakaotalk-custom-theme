#!/usr/bin/env bash
#
# 카카오 안드로이드 샘플 테마 위에 '심플 라이트' 를 얹는다.
#
# 이 저장소는 카카오가 제공한 샘플 소스를 재배포하지 않는다(reference/ 가 .gitignore 에
# 들어 있는 것과 같은 이유). 그래서 샘플은 각자 내려받고, 이 스크립트가 그 사본 위에
# 우리 파일만 덮어쓴다.
#
# 샘플은 카카오 고객센터에서 '내가 직접 테마를 만들 수도 있나요?' 로 검색해 받는다.
# 안드로이드 샘플은 apeach-<버전>-source.zip 이므로 먼저 압축을 푼다.
#
# 사용법: ./apply.sh <카카오샘플_압축해제_경로> [출력경로]
#
# 출력 기본값은 build/simple-light 이며, 원본은 건드리지 않고 사본을 만든다.

set -euo pipefail

cd "$(dirname "$0")"

SAMPLE="${1:-}"
OUT="${2:-build/simple-light}"

if [ -z "$SAMPLE" ] || [ ! -f "$SAMPLE/src/main/theme/values/colors.xml" ]; then
  echo "사용법: ./apply.sh <카카오샘플_압축해제_경로> [출력경로]" >&2
  echo "  <경로>/src/main/theme/values/colors.xml 이 있어야 한다." >&2
  exit 1
fi

# 원본은 그대로 두고 사본에서 작업한다. 아래 삭제는 모두 이 사본에만 일어난다.
rm -rf "$OUT"
mkdir -p "$(dirname "$OUT")"
cp -R "$SAMPLE" "$OUT"

THEME="$OUT/src/main/theme"
ADV="$OUT/src/main/theme-adv"

# ── 1. 색과 테마 이름 ────────────────────────────────────────────────────────
cp theme/values/colors.xml     "$THEME/values/colors.xml"
cp theme/values/strings.xml    "$THEME/values/strings.xml"
mkdir -p "$THEME/values-ko"
cp theme/values-ko/strings.xml "$THEME/values-ko/strings.xml"
rm -f "$THEME/values-ja/strings.xml"          # 일본어 이름은 두지 않는다

# ── 2. 배경·말풍선 이미지 제거 ───────────────────────────────────────────────
# "이미지와 컬러가 동일하게 사용되는 요소는 이미지 우선" 이라는 가이드 규칙의 뒷면이다.
# 이미지를 없애면 colors.xml 의 단색이, 색조차 없으면 카카오톡 기본값이 드러난다.
DROP_IMG=(
  theme_background_image             # -> theme-adv/drawable/theme_background_image.xml 의 <solid>
  theme_chatroom_background_image    # -> theme_chatroom_background_color
  theme_passcode_background_image    # -> theme_passcode_background_color
  theme_maintab_cell_image           # -> theme_maintab_cell_color
  theme_chatroom_bubble_me_01_image  # 말풍선 4종 -> 카카오톡 기본 말풍선
  theme_chatroom_bubble_me_02_image
  theme_chatroom_bubble_you_01_image
  theme_chatroom_bubble_you_02_image
  theme_passcode_01_image            # 잠금 불릿 8종 -> 카카오톡 기본
  theme_passcode_01_checked_image
  theme_passcode_02_image
  theme_passcode_02_checked_image
  theme_passcode_03_image
  theme_passcode_03_checked_image
  theme_passcode_04_image
  theme_passcode_04_checked_image
)

# ── 3. 어피치 캐릭터 아트워크 제거 ───────────────────────────────────────────
# 탭 아이콘과 친구추가 버튼은 단색 글리프가 아니라 어피치 일러스트다. 무채색으로
# 다시 칠해도 디테일이 뭉개진 실루엣이 될 뿐이라, 아예 빼고 카카오톡 기본 아이콘에
# 맡긴다. iOS 판이 탭 아이콘을 선언하지 않는 것과 같은 선택이다.
#
# 단, PNG 만 지우면 theme-adv/ 의 셀렉터 XML 이 사라진 드로어블을 참조해 빌드가
# 깨진다. 셀렉터도 함께 지워야 한다. 이 셀렉터들을 참조하는 곳은 프로젝트 안에
# 없다 (카카오톡이 런타임에 이름으로 찾는다).
DROP_IMG+=(
  theme_maintab_ico_friends_image   theme_maintab_ico_friends_focused_image
  theme_maintab_ico_chats_image     theme_maintab_ico_chats_focused_image
  theme_maintab_ico_now_image       theme_maintab_ico_now_focused_image
  theme_maintab_ico_shopping_image  theme_maintab_ico_shopping_focused_image
  theme_maintab_ico_call_image      theme_maintab_ico_call_focused_image
  theme_maintab_ico_more_image      theme_maintab_ico_more_focused_image
  theme_maintab_ico_piccoma_image   theme_maintab_ico_piccoma_focused_image
  theme_maintab_ico_local_image     theme_maintab_ico_local_focused_image
  theme_find_add_friend_button_image
  theme_find_add_friend_button_pressed_image
)
DROP_SEL=(
  theme_tab_friend_icon   theme_tab_chats_icon    theme_tab_now_icon
  theme_tab_shopping_icon theme_tab_call_icon     theme_tab_more_icon
  theme_tab_piccoma_icon
  theme_find_add_friend_button_image_selector
)

for n in "${DROP_IMG[@]}"; do
  find "$THEME" \( -name "$n.png" -o -name "$n.9.png" \) -delete
done
for n in "${DROP_SEL[@]}"; do
  rm -f "$ADV/drawable/$n.xml"
done

# ── 4. 기본 프로필 이미지는 iOS 판과 같은 것을 쓴다 ──────────────────────────
for d in "$THEME"/drawable-xxhdpi "$THEME"/drawable-sw600dp-xxxhdpi; do
  [ -d "$d" ] && cp ../themes/custom-light/Images/profileImg01@3x.png \
                    "$d/theme_profile_01_image.png"
done

# ── 5. 스플래시는 지울 수 없어 단색으로 교체한다 ─────────────────────────────
# res/layout/main_activity.xml 이 android:src 로 직접 참조하기 때문이다.
python3 make-splash.py "$OUT"

# ── 6. 남은 참조가 깨지지 않았는지 확인 ──────────────────────────────────────
missing=0
while IFS= read -r ref; do
  name="${ref#@drawable/}"
  if ! find "$THEME" "$ADV" "$OUT/src/main/res" \
       \( -name "$name.png" -o -name "$name.9.png" -o -name "$name.xml" \) \
       2>/dev/null | grep -q .; then
    echo "  깨진 참조: @drawable/$name" >&2
    missing=1
  fi
done < <(grep -rhoE '@drawable/[a-z_0-9]+' "$ADV" "$OUT/src/main/res" --include="*.xml" | sort -u)

if [ "$missing" -ne 0 ]; then
  echo "위 드로어블이 없어 빌드가 깨진다." >&2
  exit 1
fi

echo
echo "완성: $OUT"
echo "드로어블 참조 검사 통과 — 깨진 참조 없음"
echo
echo "빌드: cd $OUT && ./gradlew assembleDebug"
echo "      (JDK 21, Android SDK Platform 35 / Build-Tools 35.0.0 필요)"
echo "결과: $OUT/build/outputs/apk/debug/*.apk"
