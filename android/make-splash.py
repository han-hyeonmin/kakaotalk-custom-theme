#!/usr/bin/env python3
"""테마 앱 실행 화면(theme_splash_image.png)을 단색으로 다시 만든다.

이 이미지는 카카오톡 UI 가 아니라 테마 앱 자신의 화면이다. 설치 후 앱을 실행하면
「테마 적용하기」 버튼과 함께 잠깐 보이고 끝난다.

지워 버리면 될 것 같지만 res/layout/main_activity.xml 이 android:src 로 직접
참조하므로 없으면 빌드가 깨진다. 그래서 지우지 않고 단색으로 교체한다.
탭 아이콘처럼 '지워서 카카오톡 기본값에 맡기는' 경로를 쓸 수 없는 유일한 자산이다.

Pillow 을 쓰지 않는다. 단색 한 장을 만드는 데 의존성을 더할 이유가 없어서
zlib 으로 PNG 를 직접 쓴다 (tools/make-icon.py 는 곡선을 그려야 해서 Pillow 이 필요하다).

사용법: python3 make-splash.py <빌드된_테마_경로>
        python3 make-splash.py build/simple-light
"""

import struct
import sys
import zlib
from pathlib import Path

BG = (0xFF, 0xFF, 0xFF)     # #FFFFFF - 테마의 기본 배경색과 같은 순백


def solid_png(width: int, height: int, rgb: tuple[int, int, int]) -> bytes:
    """width x height 단색 PNG 바이트를 만든다."""
    # 각 행은 필터 바이트(0 = None) + 픽셀들. 같은 행이 반복되므로 압축률이 극단적으로 높다.
    row = b"\x00" + bytes(rgb) * width
    raw = row * height

    def chunk(typ: bytes, data: bytes) -> bytes:
        body = typ + data
        return struct.pack(">I", len(data)) + body + struct.pack(">I", zlib.crc32(body))

    ihdr = struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)   # 8bit, truecolor
    return (b"\x89PNG\r\n\x1a\n"
            + chunk(b"IHDR", ihdr)
            + chunk(b"IDAT", zlib.compress(raw, 9))
            + chunk(b"IEND", b""))


def png_size(path: Path) -> tuple[int, int]:
    """IHDR 만 읽어 크기를 얻는다."""
    with path.open("rb") as f:
        head = f.read(24)
    if head[:8] != b"\x89PNG\r\n\x1a\n":
        raise ValueError(f"PNG 가 아니다: {path}")
    return struct.unpack(">II", head[16:24])


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__)
        return 1

    root = Path(sys.argv[1]) / "src/main/theme"
    if not root.is_dir():
        print(f"테마 리소스 폴더가 없다: {root}", file=sys.stderr)
        return 1

    targets = sorted(root.glob("drawable*/theme_splash_image.png"))
    if not targets:
        print(f"theme_splash_image.png 을 찾지 못했다: {root}", file=sys.stderr)
        return 1

    for path in targets:
        # 원본과 같은 해상도를 유지한다. 밀도/가로세로별로 크기가 다르다.
        w, h = png_size(path)
        path.write_bytes(solid_png(w, h, BG))
        print(f"  {path.relative_to(root)}  {w}x{h}")

    print(f"스플래시 {len(targets)}장을 #{BG[0]:02X}{BG[1]:02X}{BG[2]:02X} 단색으로 교체했다.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
