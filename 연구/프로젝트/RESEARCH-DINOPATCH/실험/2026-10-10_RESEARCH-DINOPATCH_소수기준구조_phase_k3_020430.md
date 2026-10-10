# 소수 정상 기준 구조 비교

## 설정
밝은 정상 기준3장+별도CAL5장만 사용. 조도마다 기준을 추가하지 않음. 중앙crop 안에서도 기준영상에서 정한 띠ROI만 검사; ROI 밖 맵0은 정상이라는 뜻이 아님. CAL q95는5장 최대값으로 표본이 적음. 정합실패는 REVIEW; FP/FN은 모든 사례의 점수 기준 참고값. TEST REVIEW 17/268 (OK0, NG17). ROI y=[151, 269], x=[28,364).

## 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 30,
    "TN": 168,
    "FP": 17,
    "FN": 53,
    "accuracy": 73.88059701492537,
    "image_auroc": 70.08791924454574,
    "recall": 36.144578313253014,
    "fpr": 9.18918918918919
  },
  "bright": {
    "n": 204,
    "TP": 30,
    "TN": 117,
    "FP": 17,
    "FN": 40,
    "accuracy": 72.05882352941177,
    "image_auroc": 76.37526652452026,
    "recall": 42.857142857142854,
    "fpr": 12.686567164179104
  },
  "dark": {
    "n": 64,
    "TP": 0,
    "TN": 51,
    "FP": 0,
    "FN": 13,
    "accuracy": 79.6875,
    "image_auroc": 53.54449472096531,
    "recall": 0.0,
    "fpr": 0.0
  }
}
```

## 한계·결정·다음
고정시야/평행이동 한정, 실제dark학습 없음, CAL5장의 작은 표본, 개발TEST268. REVIEW를 자동OK로 보지 않는다. 전체조건 비교 후 다음 단계를 결정.

E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_020800_illum_phase_k3_waterseal
## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_020430`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
