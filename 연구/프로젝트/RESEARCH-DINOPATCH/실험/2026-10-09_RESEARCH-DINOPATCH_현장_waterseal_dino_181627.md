# waterseal / dino 현장 비교

## 질문·변경
동일 정상 FIT/CAL/TEST에서 현장 이상탐지 성능 확인. 정상CAL q95 higher, TEST로 임계값 선택 없음. 원본 참조, 재라벨링/증강/배경제거 없음.

## 데이터·설정
FIT224 / CAL85 / TEST268. RGB long-side700; no mask/alignment/augmentation; frozen DINOv2; coreset3000

## 검증 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 83,
    "TN": 123,
    "FP": 62,
    "FN": 0,
    "accuracy": 76.86567164179104,
    "image_auroc": 89.3650276782807,
    "recall": 100.0,
    "fpr": 33.513513513513516
  },
  "bright": {
    "n": 204,
    "TP": 70,
    "TN": 123,
    "FP": 11,
    "FN": 0,
    "accuracy": 94.6078431372549,
    "image_auroc": 99.98933901918976,
    "recall": 100.0,
    "fpr": 8.208955223880597
  },
  "dark": {
    "n": 64,
    "TP": 13,
    "TN": 0,
    "FP": 51,
    "FN": 0,
    "accuracy": 20.3125,
    "image_auroc": 72.6998491704374,
    "recall": 100.0,
    "fpr": 100.0
  }
}
```

![[2026-10-09_RESEARCH-DINOPATCH_현장_waterseal_dino_181627.jpg]]

## 한계·결정·다음
이미 살펴본 개발 데이터. 밝은 정상으로만 워터씰 학습. 볼트 camera1 주평가NG5, 다른카메라NG12는 별도단일클래스 평가. 픽셀GT 없음. 모델해상도/시야 다름. 비교모델 완료 후 동일 사전선정VLM 표본으로 재집계한다.

## 검증·출처
모델 재로드·원본해시·지표 재집계·JPG 디코딩 및 브라우저 필터 확인. 입력복사0. 최종 가중치와 native 수치맵 보존.
- `E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261009_181627_field_waterseal_dino`
- `tools/field_model_comparison.py`
- 최종모델SHA256 `02ba3fbdfbc00acf6ce7448157e75e7912e598046f3f2ca53f295bf4eb6ef844`
