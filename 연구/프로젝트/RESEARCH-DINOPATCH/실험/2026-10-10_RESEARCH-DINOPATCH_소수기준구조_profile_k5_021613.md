# 소수 정상 기준 구조 비교

## 설정
밝은 기준5장+CAL5장. Otsu 띠 위/아래 경계에서 Gaussian sigma12의 완만한 추세를 빼고 기준과 국소형상 비교. 전체두께/곡률 변화는 제거되므로 넓고 완만한 결함은 놓칠 수 있음. 열 x28:364, query띠 주변만 검사. 추출coverage<90%는 REVIEW. NCC 정합은 사용하지 않음. 이전 개발결과와 CAL정상 형상 관찰 후 추가한 조건. TEST REVIEW 34/268 (OK0, NG34). ROI y=[148, 266], x=[28,364).

## 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 53,
    "TN": 185,
    "FP": 0,
    "FN": 30,
    "accuracy": 88.80597014925372,
    "image_auroc": 97.6489742754803,
    "recall": 63.855421686746986,
    "fpr": 0.0
  },
  "bright": {
    "n": 204,
    "TP": 53,
    "TN": 134,
    "FP": 0,
    "FN": 17,
    "accuracy": 91.66666666666667,
    "image_auroc": 97.99573560767591,
    "recall": 75.71428571428571,
    "fpr": 0.0
  },
  "dark": {
    "n": 64,
    "TP": 0,
    "TN": 51,
    "FP": 0,
    "FN": 13,
    "accuracy": 79.6875,
    "image_auroc": 100.0,
    "recall": 0.0,
    "fpr": 0.0
  }
}
```

## 한계·결정·다음
고정시야/평행이동 한정, 실제dark학습 없음, CAL5장의 작은 표본, 개발TEST268. REVIEW를 자동OK로 보지 않는다. 전체조건 비교 후 다음 단계를 결정.

E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_021613_illum_profile_k5_waterseal
## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_021613`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
