# 소수 정상 기준 구조 비교

## 설정
밝은 정상 기준1장+별도CAL5장만 사용. 조도마다 기준을 추가하지 않음. 중앙crop 안에서도 기준영상에서 정한 띠ROI만 검사; ROI 밖 맵0은 정상이라는 뜻이 아님. CAL q95는5장 최대값으로 표본이 적음. 정합실패는 REVIEW; FP/FN은 모든 사례의 점수 기준 참고값. TEST REVIEW 43/268 (OK6, NG37). ROI y=[151, 269], x=[28,364).

## 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 82,
    "TN": 92,
    "FP": 93,
    "FN": 1,
    "accuracy": 64.92537313432835,
    "image_auroc": 78.39465971996093,
    "recall": 98.79518072289157,
    "fpr": 50.270270270270274
  },
  "bright": {
    "n": 204,
    "TP": 69,
    "TN": 92,
    "FP": 42,
    "FN": 1,
    "accuracy": 78.92156862745098,
    "image_auroc": 98.4594882729211,
    "recall": 98.57142857142857,
    "fpr": 31.34328358208955
  },
  "dark": {
    "n": 64,
    "TP": 13,
    "TN": 0,
    "FP": 51,
    "FN": 0,
    "accuracy": 20.3125,
    "image_auroc": 70.36199095022624,
    "recall": 100.0,
    "fpr": 100.0
  }
}
```

## 한계·결정·다음
고정시야/평행이동 한정, 실제dark학습 없음, CAL5장의 작은 표본, 개발TEST268. REVIEW를 자동OK로 보지 않는다. 전체조건 비교 후 다음 단계를 결정.

E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_020529_illum_census_k1_waterseal
## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_020430`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
