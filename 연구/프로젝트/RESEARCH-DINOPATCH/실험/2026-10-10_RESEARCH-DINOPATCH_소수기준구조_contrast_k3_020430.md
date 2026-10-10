# 소수 정상 기준 구조 비교

## 설정
밝은 정상 기준3장+별도CAL5장만 사용. 조도마다 기준을 추가하지 않음. 중앙crop 안에서도 기준영상에서 정한 띠ROI만 검사; ROI 밖 맵0은 정상이라는 뜻이 아님. CAL q95는5장 최대값으로 표본이 적음. 정합실패는 REVIEW; FP/FN은 모든 사례의 점수 기준 참고값. TEST REVIEW 17/268 (OK0, NG17). ROI y=[151, 269], x=[28,364).

## 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 62,
    "TN": 128,
    "FP": 57,
    "FN": 21,
    "accuracy": 70.8955223880597,
    "image_auroc": 78.78215564962552,
    "recall": 74.6987951807229,
    "fpr": 30.81081081081081
  },
  "bright": {
    "n": 204,
    "TP": 62,
    "TN": 77,
    "FP": 57,
    "FN": 8,
    "accuracy": 68.13725490196079,
    "image_auroc": 88.60341151385927,
    "recall": 88.57142857142857,
    "fpr": 42.53731343283582
  },
  "dark": {
    "n": 64,
    "TP": 0,
    "TN": 51,
    "FP": 0,
    "FN": 13,
    "accuracy": 79.6875,
    "image_auroc": 32.57918552036199,
    "recall": 0.0,
    "fpr": 0.0
  }
}
```

## 한계·결정·다음
고정시야/평행이동 한정, 실제dark학습 없음, CAL5장의 작은 표본, 개발TEST268. REVIEW를 자동OK로 보지 않는다. 전체조건 비교 후 다음 단계를 결정.

E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_020450_illum_contrast_k3_waterseal
## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_020430`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
