#!/usr/bin/env python3
"""테마 목록 썸네일(Images/commonIcoTheme.png)을 생성한다.

카카오톡은 테마 목록에 썸네일을 그릴 때 자기 라운드 마스크와 테두리를 씌운다.
그래서 PNG 쪽에서 모서리를 미리 굽지 않는다. 이미지에 곡률을 구워 넣으면 앱
마스크 안쪽에서 이미지가 먼저 끝나 버려, 그 틈으로 목록 배경(흰색)이 비친다.
기본 테마 아이콘들과 곡률이 어긋나 보이는 것도 같은 이유다.

  - 바탕은 162 x 162 를 알파 없이 꽉 채운다 (모서리는 앱이 깎는다)
  - 안쪽 말풍선 마크만 둥근 사각형으로 그린다. 이때 모서리는 iOS 앱 아이콘과
    같은 연속 곡률(스쿼클)을 초타원으로 근사한다.

        ((E-x)/E)^n + ((E-y)/E)^n = 1        E = radius x (1 + smoothing)

    smoothing 은 Figma 의 corner smoothing 과 같은 값이고, 지수 n 은 곡선의
    대각선 깊이가 같은 반경의 원호와 일치하도록 계산한다. 곡선이 시작되는
    위치만 바깥으로 밀리고 모서리가 깎이는 정도는 그대로다.

사용법: python3 tools/make-icon.py [출력경로]
        (기본값: themes/custom-light/Images/commonIcoTheme.png)
"""

import math
import sys
from pathlib import Path

from PIL import Image, ImageDraw

SIZE = 162                      # 카카오톡 규격: 162 x 162
SS = 8                          # 슈퍼샘플링 배율 (안티에일리어싱용)

BG = (171, 193, 209)            # #ABC1D1 - 목록에서 보이는 타일 바탕색
FG = (255, 255, 254)            # #FFFFFE - 테마의 메인 배경색과 같은 흰색

IOS_SMOOTHING = 0.6             # 연속 곡률 정도 (Figma 의 corner smoothing 과 같은 값)

# 말풍선 마크. docs/index.html 의 파비콘 SVG(100 단위)를 162 로 스케일한 값이다.
K = SIZE / 100.0
BUBBLE = (20 * K, 24 * K, 60 * K, 42 * K)   # x, y, w, h
BUBBLE_RADIUS = 12 * K
TAIL = [(40 * K, 63 * K), (53 * K, 63 * K), (42 * K, 80 * K)]


def superellipse_n(smoothing=IOS_SMOOTHING):
    """대각선 깊이를 원호와 같게 유지하는 초타원 지수."""
    depth = 1.0 - 2.0 ** -0.5                     # 반경 1 인 원호의 대각선 깊이
    return -math.log(2.0) / math.log(1.0 - depth / (1.0 + smoothing))


def rounded_mask(w, h, radius, smoothing=IOS_SMOOTHING, ss=SS):
    """직선 변 + 초타원 모서리로 이루어진 둥근 사각형 알파 마스크."""
    n = superellipse_n(smoothing)
    ext = min(radius * (1.0 + smoothing), w / 2.0, h / 2.0)
    W, H, E = int(round(w * ss)), int(round(h * ss)), ext * ss
    mask = Image.new("L", (W, H), 0)
    px = mask.load()
    for y in range(H):
        dy = min(y + 0.5, H - (y + 0.5))
        if dy >= E:
            for x in range(W):
                px[x, y] = 255
            continue
        v = ((E - dy) / E) ** n
        # u^n + v^n = 1 을 x 에 대해 풀어 이 행의 모서리 시작점을 구한다
        cut = E * (1.0 - (1.0 - v) ** (1.0 / n)) if v < 1.0 else E
        for x in range(W):
            dx = min(x + 0.5, W - (x + 0.5))
            px[x, y] = 255 if dx >= cut else 0
    return mask.resize((int(round(w)), int(round(h))), Image.BOX)


def build(size=SIZE):
    scale = size / float(SIZE)

    # 말풍선(둥근 사각형 + 꼬리)을 하나의 마스크로 만든다
    bx, by, bw, bh = (v * scale for v in BUBBLE)
    mark = Image.new("L", (size, size), 0)
    mark.paste(rounded_mask(bw, bh, BUBBLE_RADIUS * scale), (int(round(bx)), int(round(by))))

    tail = Image.new("L", (size * SS, size * SS), 0)
    ImageDraw.Draw(tail).polygon([(x * scale * SS, y * scale * SS) for x, y in TAIL], fill=255)
    tail = tail.resize((size, size), Image.BOX)
    mark = Image.composite(Image.new("L", (size, size), 255), mark, tail)

    # 바탕은 모서리를 굽지 않고 꽉 채운다. 라운드 처리는 카카오톡이 한다.
    icon = Image.new("RGBA", (size, size), BG + (255,))
    icon.paste(FG + (255,), (0, 0), mark)
    return icon


def main():
    out = Path(sys.argv[1]) if len(sys.argv) > 1 else (
        Path(__file__).resolve().parent.parent / "themes/custom-light/Images/commonIcoTheme.png")
    icon = build()
    out.parent.mkdir(parents=True, exist_ok=True)
    icon.save(out, optimize=True)
    print(f"생성 완료: {out} ({icon.width}x{icon.height})")


if __name__ == "__main__":
    main()
