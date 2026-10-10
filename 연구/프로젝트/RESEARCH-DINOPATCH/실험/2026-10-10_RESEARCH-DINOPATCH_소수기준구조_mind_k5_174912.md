# 소수 정상 기준 구조 비교

## 설정
밝은 기준5장+CAL5장 고정, 원본TEST268. 신규 조도 기준 추가 없음. B1: 2D MIND-inspired descriptor, not original3D implementation. Eight offsets radius2; squared patch differences Gaussian sigma1; variance axial4 mean floor1e-8; exp(-(distance-min)/variance). Mean absolute descriptor distance with unchanged NCC alignment. Profile 계열은 NCC 대신 경계 coverage90%로 REVIEW 처리하며 top1% 열 점수; 외부0은 미검사. MIND는 기존 띠ROI와 NCC 정합 사용. 정상CAL/TEST 성능을 보고 설정을 바꾸지 않는 개발 평가. TEST REVIEW 16/268 (OK0, NG16). ROI y=[148, 266], x=[28,364).

## 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 1,
    "TN": 183,
    "FP": 2,
    "FN": 82,
    "accuracy": 68.65671641791045,
    "image_auroc": 73.90426571149462,
    "recall": 1.2048192771084338,
    "fpr": 1.0810810810810811
  },
  "bright": {
    "n": 204,
    "TP": 1,
    "TN": 132,
    "FP": 2,
    "FN": 69,
    "accuracy": 65.19607843137256,
    "image_auroc": 88.35820895522389,
    "recall": 1.4285714285714286,
    "fpr": 1.492537313432836
  },
  "dark": {
    "n": 64,
    "TP": 0,
    "TN": 51,
    "FP": 0,
    "FN": 13,
    "accuracy": 79.6875,
    "image_auroc": 5.4298642533936645,
    "recall": 0.0,
    "fpr": 0.0
  }
}
```

## 한계·결정·다음
고정시야/평행이동 한정, 실제dark학습 없음, CAL5장의 작은 표본, 개발TEST268. REVIEW를 자동OK로 보지 않는다. 전체조건 비교 후 다음 단계를 결정.

E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_175029_illum_mind_k5_waterseal
## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_174912`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
