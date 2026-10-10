# waterseal / patchcore 현장 비교

## 질문·변경
동일 정상 FIT/CAL/TEST에서 현장 이상탐지 성능 확인. 정상CAL q95 higher, TEST로 임계값 선택 없음. 원본 참조, 재라벨링/증강/배경제거 없음.

## 데이터·설정
FIT224 / CAL85 / TEST268. RGB resize256 square / center crop224 / ImageNet normalization; official WRN50 layer2+3 coreset10%

## 검증 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 83,
    "TN": 132,
    "FP": 53,
    "FN": 0,
    "accuracy": 80.22388059701493,
    "image_auroc": 85.79615760338652,
    "recall": 100.0,
    "fpr": 28.64864864864865
  },
  "bright": {
    "n": 204,
    "TP": 70,
    "TN": 132,
    "FP": 2,
    "FN": 0,
    "accuracy": 99.01960784313725,
    "image_auroc": 99.97867803837953,
    "recall": 100.0,
    "fpr": 1.492537313432836
  },
  "dark": {
    "n": 64,
    "TP": 13,
    "TN": 0,
    "FP": 51,
    "FN": 0,
    "accuracy": 20.3125,
    "image_auroc": 0.1508295625942688,
    "recall": 100.0,
    "fpr": 100.0
  }
}
```

![[2026-10-09_RESEARCH-DINOPATCH_현장_waterseal_patchcore_181713.jpg]]

## 한계·결정·다음
이미 살펴본 개발 데이터. 밝은 정상으로만 워터씰 학습. 볼트 camera1 주평가NG5, 다른카메라NG12는 별도단일클래스 평가. 픽셀GT 없음. 모델해상도/시야 다름. 비교모델 완료 후 동일 사전선정VLM 표본으로 재집계한다.

## 검증·출처
모델 재로드·원본해시·지표 재집계·JPG 디코딩 및 브라우저 필터 확인. 입력복사0. 최종 가중치와 native 수치맵 보존.
- `E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261009_181713_field_waterseal_patchcore`
- `tools/field_model_comparison.py`
- 최종모델SHA256 `4dd9067ed36db7beddd9d9f2d3371a462309c9998ef18a3d95bac76e28de8dbe`
