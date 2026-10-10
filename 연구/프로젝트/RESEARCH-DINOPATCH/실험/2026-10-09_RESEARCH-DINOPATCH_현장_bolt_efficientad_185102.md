# bolt / efficientad 현장 비교

## 질문·변경
동일 정상 FIT/CAL/TEST에서 현장 이상탐지 성능 확인. 정상CAL q95 higher, TEST로 임계값 선택 없음. 원본 참조, 재라벨링/증강/배경제거 없음.

## 데이터·설정
FIT275 / CAL152 / TEST2289. RGB256 bilinear; internal normalization; fixed10000 steps with ImageNette penalty

## 검증 측정
```json
{
  "primary": {
    "n": 2277,
    "TP": 3,
    "TN": 2148,
    "FP": 124,
    "FN": 2,
    "accuracy": 94.46640316205534,
    "image_auroc": 90.61619718309859,
    "recall": 60.0,
    "fpr": 5.457746478873239
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

![[2026-10-09_RESEARCH-DINOPATCH_현장_bolt_efficientad_185102.jpg]]

## 한계·결정·다음
이미 살펴본 개발 데이터. 밝은 정상으로만 워터씰 학습. 볼트 camera1 주평가NG5, 다른카메라NG12는 별도단일클래스 평가. 픽셀GT 없음. 모델해상도/시야 다름. 비교모델 완료 후 동일 사전선정VLM 표본으로 재집계한다.

## 검증·출처
모델 재로드·원본해시·지표 재집계·JPG 디코딩 및 브라우저 필터 확인. 입력복사0. 최종 가중치와 native 수치맵 보존.
- `E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261009_185102_field_bolt_efficientad`
- `tools/field_model_comparison.py`
- 최종모델SHA256 `1703542f6aab5a7061a8a53b91e425ad7e7050c7b92dc1a3f0750666a883c996`
