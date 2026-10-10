# 소수 정상 기준 구조 비교

## 설정
밝은 정상 기준1장+별도CAL5장만 사용. 조도마다 기준을 추가하지 않음. 중앙crop 안에서도 기준영상에서 정한 띠ROI만 검사; ROI 밖 맵0은 정상이라는 뜻이 아님. CAL q95는5장 최대값으로 표본이 적음. 정합실패는 REVIEW; FP/FN은 모든 사례의 점수 기준 참고값. TEST REVIEW 43/268 (OK6, NG37). ROI y=[151, 269], x=[28,364).

## 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 39,
    "TN": 180,
    "FP": 5,
    "FN": 44,
    "accuracy": 81.71641791044776,
    "image_auroc": 78.82774340605665,
    "recall": 46.98795180722892,
    "fpr": 2.7027027027027026
  },
  "bright": {
    "n": 204,
    "TP": 39,
    "TN": 129,
    "FP": 5,
    "FN": 31,
    "accuracy": 82.3529411764706,
    "image_auroc": 87.60127931769722,
    "recall": 55.714285714285715,
    "fpr": 3.7313432835820897
  },
  "dark": {
    "n": 64,
    "TP": 0,
    "TN": 51,
    "FP": 0,
    "FN": 13,
    "accuracy": 79.6875,
    "image_auroc": 47.81297134238311,
    "recall": 0.0,
    "fpr": 0.0
  }
}
```

## 한계·결정·다음
고정시야/평행이동 한정, 실제dark학습 없음, CAL5장의 작은 표본, 개발TEST268. REVIEW를 자동OK로 보지 않는다. 전체조건 비교 후 다음 단계를 결정.

E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_020430_illum_contrast_k1_waterseal
## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_020430`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
