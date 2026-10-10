# bolt / dino 현장 비교

## 질문·변경
동일 정상 FIT/CAL/TEST에서 현장 이상탐지 성능 확인. 정상CAL q95 higher, TEST로 임계값 선택 없음. 원본 참조, 재라벨링/증강/배경제거 없음.

## 데이터·설정
FIT275 / CAL152 / TEST2289. RGB long-side700; no mask/alignment/augmentation; frozen DINOv2; coreset3000

## 검증 측정
```json
{
  "primary": {
    "n": 2277,
    "TP": 5,
    "TN": 1823,
    "FP": 449,
    "FN": 0,
    "accuracy": 80.28107158541941,
    "image_auroc": 93.60915492957747,
    "recall": 100.0,
    "fpr": 19.762323943661972
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

![[2026-10-09_RESEARCH-DINOPATCH_현장_bolt_dino_184049.jpg]]

## 한계·결정·다음
이미 살펴본 개발 데이터. 밝은 정상으로만 워터씰 학습. 볼트 camera1 주평가NG5, 다른카메라NG12는 별도단일클래스 평가. 픽셀GT 없음. 모델해상도/시야 다름. 비교모델 완료 후 동일 사전선정VLM 표본으로 재집계한다.

## 검증·출처
모델 재로드·원본해시·지표 재집계·JPG 디코딩 및 브라우저 필터 확인. 입력복사0. 최종 가중치와 native 수치맵 보존.
- `E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261009_184049_field_bolt_dino`
- `tools/field_model_comparison.py`
- 최종모델SHA256 `724dead6542e10ba0295740a7189a00b0ccbc331a00b0d1b2506618c9c26bf14`

## 평가 중단 및 복구
외부촬영3장의 가로/세로 격자가 학습격자와 달라 기존 pipeline._feat 검사에서 중단. 공간마스크/정합 없는 전역 cosine patch bank에는 격자크기 고정 가중치가 없어 실험 어댑터에서 같은 특징추출·최근접거리·top-k를 가변격자에 적용했다. 라이브러리 일반동작은 수정하지 않음. 기존최종모델/백본해시와2438개기존맵해시 유지, 정상/NG/보정3개 맵 재추론일치, 누락3장만 신규추론. 재학습 없음. 복구시간은 캐시I/O와추론 혼합이므로 추론속도 벤치마크로 쓰지 않음. logs/grid_failure.json, grid_recovery.json에 보존.
