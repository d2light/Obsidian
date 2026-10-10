# 소수 정상 기준 구조 비교

## 설정
밝은 기준5장+CAL5장 고정, 원본TEST268. 신규 조도 기준 추가 없음. A2: y-smoothed sigma1 column intensity p10/p95 within peak+/-59; thresholds35/50/65%; subpixel crossings, middle threshold traces; valid if all thresholds found and boundary spread<=2.5px; residual sigma12; missing distance8. Diagnostic correction after initial results: middle-threshold measured edge validity is distinct from multi-threshold confidence. Keep measured uncertain edges in score, use confidence only for90% REVIEW gate. Any genuinely missing middle-threshold edge inside ROI => REVIEW; no calibration exclusions. This avoids injecting fixed large distances solely for uncertainty. Profile 계열은 NCC 대신 경계 coverage90%로 REVIEW 처리하며 top1% 열 점수; 외부0은 미검사. MIND는 기존 띠ROI와 NCC 정합 사용. 정상CAL/TEST 성능을 보고 설정을 바꾸지 않는 개발 평가. TEST REVIEW 34/268 (OK0, NG34). ROI y=[148, 266], x=[28,364).

## 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 83,
    "TN": 114,
    "FP": 71,
    "FN": 0,
    "accuracy": 73.50746268656717,
    "image_auroc": 97.95506349723217,
    "recall": 100.0,
    "fpr": 38.37837837837838
  },
  "bright": {
    "n": 204,
    "TP": 70,
    "TN": 114,
    "FP": 20,
    "FN": 0,
    "accuracy": 90.19607843137256,
    "image_auroc": 99.84008528784649,
    "recall": 100.0,
    "fpr": 14.925373134328359
  },
  "dark": {
    "n": 64,
    "TP": 13,
    "TN": 0,
    "FP": 51,
    "FN": 0,
    "accuracy": 20.3125,
    "image_auroc": 100.0,
    "recall": 100.0,
    "fpr": 100.0
  }
}
```

## 한계·결정·다음
고정시야/평행이동 한정, 실제dark학습 없음, CAL5장의 작은 표본, 개발TEST268. REVIEW를 자동OK로 보지 않는다. 전체조건 비교 후 다음 단계를 결정.

E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_175153_illum_profile_stable_measured_k5_waterseal
## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_175153`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
