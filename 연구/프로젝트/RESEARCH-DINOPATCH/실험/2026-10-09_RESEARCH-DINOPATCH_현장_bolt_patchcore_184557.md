# bolt / patchcore 현장 비교

## 질문·변경
동일 정상 FIT/CAL/TEST에서 현장 이상탐지 성능 확인. 정상CAL q95 higher, TEST로 임계값 선택 없음. 원본 참조, 재라벨링/증강/배경제거 없음.

## 데이터·설정
FIT275 / CAL152 / TEST2289. RGB resize256 square / center crop224 / ImageNet normalization; official WRN50 layer2+3 coreset10%

## 검증 측정
```json
{
  "primary": {
    "n": 2277,
    "TP": 4,
    "TN": 2117,
    "FP": 155,
    "FN": 1,
    "accuracy": 93.14888010540184,
    "image_auroc": 94.97359154929578,
    "recall": 80.0,
    "fpr": 6.822183098591549
  },
  "external": {
    "n": 12,
    "TP": 12,
    "TN": 0,
    "FP": 0,
    "FN": 0,
    "accuracy": 100.0,
    "image_auroc": null,
    "recall": 100.0,
    "fpr": null
  }
}
```

![[2026-10-09_RESEARCH-DINOPATCH_현장_bolt_patchcore_184557.jpg]]

## 한계·결정·다음
이미 살펴본 개발 데이터. 밝은 정상으로만 워터씰 학습. 볼트 camera1 주평가NG5, 다른카메라NG12는 별도단일클래스 평가. 픽셀GT 없음. 모델해상도/시야 다름. 비교모델 완료 후 동일 사전선정VLM 표본으로 재집계한다.

## 검증·출처
모델 재로드·원본해시·지표 재집계·JPG 디코딩 및 브라우저 필터 확인. 입력복사0. 최종 가중치와 native 수치맵 보존.
- `E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261009_184557_field_bolt_patchcore`
- `tools/field_model_comparison.py`
- 최종모델SHA256 `4dd9067ed36db7beddd9d9f2d3371a462309c9998ef18a3d95bac76e28de8dbe`
