---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [WATERSEAL_CONTOURS.md](file:///E:/DH/Sandbox/Dinopatch/docs/WATERSEAL_CONTOURS.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# Waterseal contour feasibility probe

Result: `output/contour_probe_20260928_235517/index.html`.
Reproduce with `.venv/Scripts/python.exe -m tools.probe_contours`.

This is a preprocessing probe, not a trained defect classifier. Existing project
snapshots were read; D:/datasets/waterseal was not accessed or modified.
224 bright normal fit images determine the fixed thresholds. All 85 calibration
and 268 validation images have comparison cards, edge images and numeric traces.
The table below uses only validation images.

| Method | Bright OK (134) | Bright NG (70) | Dark OK (51) | Dark NG (13) |
| --- | ---: | ---: | ---: | ---: |
| Scharr, fixed threshold | 65.6% | 36.9% | 0.0% | 0.0% |
| Canny, fixed thresholds | 92.1% | 64.9% | 0.0% | 0.0% |
| Canny, per-image thresholds | 92.3% | 70.8% | 83.6% | 76.1% |

Values are median selected-pair valid-column coverage, NOT contour accuracy or
defect recall. In the central 90% of image columns, the strongest positive and
negative Scharr gradients among edge pixels are selected independently. Their
ordering must be correct and separation must be 2–129 analysis pixels. No alternate
pair is searched: a stronger reflection can invalidate the selection even when
another usable pair exists. Missing columns remain missing. Coverage below 90%
is an exploratory review flag, never an OK verdict; all 64 dark images trigger it.

Analysis uses half resolution (1272×952), Gaussian 3×3 sigma 0.8, and the fixed
train-derived search band y=369:628. Scharr threshold is 53.203125 after dividing
the Scharr derivative by 32. Fixed Canny high threshold is 426.039886; low is 40%
of high. Adaptive high is max(5, per-image ROI Sobel magnitude P99), with the same
low ratio, without labels. No morphological closing or gap filling is applied.

Adaptive Canny exposes dark-image boundaries that these bright-derived fixed
thresholds miss. This does not establish that Scharr or fixed Canny generally
fail on dark images. Reflections, discontinuities, displacement outside the search
band and loss of small defects at half resolution remain limitations. There are
no contour ground-truth masks, and DINO anomaly detection was not retrained or
evaluated with this representation. A useful next experiment would compare a
normal-reference contour shape score and its combination with the existing DINO
score, retaining extraction failures as review cases in evaluation.

Representative cards: 0066 bright OK, 0229 dark OK, 0343 dark NG, 0215 the prior
bright false-positive OK. Cyan and orange are upper/lower candidates, not defect
labels. Full artifact hashes and source-copy checks passed; 18 unit tests passed.
