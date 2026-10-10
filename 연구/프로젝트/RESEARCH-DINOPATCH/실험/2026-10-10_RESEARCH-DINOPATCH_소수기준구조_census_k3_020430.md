# 소수 정상 기준 구조 비교

## 설정
밝은 정상 기준3장+별도CAL5장만 사용. 조도마다 기준을 추가하지 않음. 중앙crop 안에서도 기준영상에서 정한 띠ROI만 검사; ROI 밖 맵0은 정상이라는 뜻이 아님. CAL q95는5장 최대값으로 표본이 적음. 정합실패는 REVIEW; FP/FN은 모든 사례의 점수 기준 참고값. TEST REVIEW 17/268 (OK0, NG17). ROI y=[151, 269], x=[28,364).

## 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 80,
    "TN": 122,
    "FP": 63,
    "FN": 3,
    "accuracy": 75.3731343283582,
    "image_auroc": 76.58417453598176,
    "recall": 96.3855421686747,
    "fpr": 34.054054054054056
  },
  "bright": {
    "n": 204,
    "TP": 67,
    "TN": 122,
    "FP": 12,
    "FN": 3,
    "accuracy": 92.6470588235294,
    "image_auroc": 99.12046908315565,
    "recall": 95.71428571428571,
    "fpr": 8.955223880597014
  },
  "dark": {
    "n": 64,
    "TP": 13,
    "TN": 0,
    "FP": 51,
    "FN": 0,
    "accuracy": 20.3125,
    "image_auroc": 37.48114630467572,
    "recall": 100.0,
    "fpr": 100.0
  }
}
```

## 한계·결정·다음
고정시야/평행이동 한정, 실제dark학습 없음, CAL5장의 작은 표본, 개발TEST268. REVIEW를 자동OK로 보지 않는다. 전체조건 비교 후 다음 단계를 결정.

E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_020553_illum_census_k3_waterseal
## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_020430`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
