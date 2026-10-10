# 소수 정상 기준 구조 비교

## 설정
밝은 정상 기준5장+별도CAL5장만 사용. 조도마다 기준을 추가하지 않음. 중앙crop 안에서도 기준영상에서 정한 띠ROI만 검사; ROI 밖 맵0은 정상이라는 뜻이 아님. CAL q95는5장 최대값으로 표본이 적음. 정합실패는 REVIEW; FP/FN은 모든 사례의 점수 기준 참고값. TEST REVIEW 16/268 (OK0, NG16). ROI y=[148, 266], x=[28,364).

## 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 75,
    "TN": 120,
    "FP": 65,
    "FN": 8,
    "accuracy": 72.76119402985074,
    "image_auroc": 78.17323347443829,
    "recall": 90.36144578313252,
    "fpr": 35.13513513513514
  },
  "bright": {
    "n": 204,
    "TP": 62,
    "TN": 120,
    "FP": 14,
    "FN": 8,
    "accuracy": 89.2156862745098,
    "image_auroc": 96.19402985074626,
    "recall": 88.57142857142857,
    "fpr": 10.447761194029852
  },
  "dark": {
    "n": 64,
    "TP": 13,
    "TN": 0,
    "FP": 51,
    "FN": 0,
    "accuracy": 20.3125,
    "image_auroc": 56.10859728506787,
    "recall": 100.0,
    "fpr": 100.0
  }
}
```

## 한계·결정·다음
고정시야/평행이동 한정, 실제dark학습 없음, CAL5장의 작은 표본, 개발TEST268. REVIEW를 자동OK로 보지 않는다. 전체조건 비교 후 다음 단계를 결정.

E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_020619_illum_census_k5_waterseal
## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_020430`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
