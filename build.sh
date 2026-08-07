#!/usr/bin/env bash
#
# themes/<테마명>/ 아래의 KakaoTalkTheme.css 와 Images/ 를 .ktheme 로 패키징한다.
#
# 주의: 카카오톡은 zip 최상위에 KakaoTalkTheme.css 와 Images/ 가 바로 있어야 인식한다.
#       테마 폴더 자체를 압축하면(= folder/KakaoTalkTheme.css) 적용되지 않는다.
#       macOS 가 끼워 넣는 .DS_Store / __MACOSX 도 함께 제거한다.
#
# 사용법: ./build.sh [테마명 ...]   (인자 없으면 themes/ 하위 전체)

set -euo pipefail

cd "$(dirname "$0")"

SRC_ROOT="themes"
OUT_DIR="docs/download"

mkdir -p "$OUT_DIR"

themes=("$@")
if [ ${#themes[@]} -eq 0 ]; then
  while IFS= read -r d; do themes+=("$(basename "$d")"); done \
    < <(find "$SRC_ROOT" -mindepth 1 -maxdepth 1 -type d | sort)
fi

for name in "${themes[@]}"; do
  src="$SRC_ROOT/$name"
  if [ ! -f "$src/KakaoTalkTheme.css" ]; then
    echo "건너뜀: $src/KakaoTalkTheme.css 없음" >&2
    continue
  fi

  out="$PWD/$OUT_DIR/$name.ktheme"
  rm "$out" 2>/dev/null || true

  # -X: 맥 확장 속성/리소스 포크 제외, -r: 재귀
  ( cd "$src" && zip -q -r -X "$out" KakaoTalkTheme.css Images \
      -x '*.DS_Store' -x '__MACOSX/*' )

  # 로컬 테스트용 사본을 테마 폴더에도 남겨 둔다
  /bin/cp "$out" "$src/$name.ktheme"

  echo "빌드 완료: $OUT_DIR/$name.ktheme"
  unzip -l "$out" | sed 's/^/    /'
done
