# 조도 탐색: template_local

## 질문·설정
Bright normal FIT224/CAL85 only, exact immutable baseline split; original TEST268. CAL q95 higher before TEST, strict >. Parameters fixed before scoring; previously inspected development data; no claim of independent generalization. Pixel corrections before frozen raw-trained Dinomaly are inference-only adaptation probes, not matched retraining. bank_* fits a new normal bank with identical correction for FIT/CAL/TEST. Official restoration checkpoints are externally pretrained, not trained only on field bright images. GNL-inspired AdaIN/EFDM uses FIT-only target statistics on collected DINO features, NOT official GNL reproduction. Shape/alignment extraction failure is REVIEW, never an automatic OK; numeric score-only metrics retain every case and review counts are separate.

RGB resize448 square / center crop392 / template_local

각 조건의 밝은 CAL 임계값. 실제 dark 학습/보정 없음. 원본 영상 중심87.5% 검사. 기존 가중치/전통 점수에 대한 고정 설정 탐색 실험. Dinomaly 재학습 없음. TEST REVIEW 0/268 (정상 0, 불량 0).

## 검증 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 53,
    "TN": 170,
    "FP": 15,
    "FN": 30,
    "accuracy": 83.2089552238806,
    "image_auroc": 77.25822207749918,
    "recall": 63.855421686746986,
    "fpr": 8.108108108108109
  },
  "bright": {
    "n": 204,
    "TP": 53,
    "TN": 119,
    "FP": 15,
    "FN": 17,
    "accuracy": 84.31372549019608,
    "image_auroc": 85.01066098081023,
    "recall": 75.71428571428571,
    "fpr": 11.194029850746269
  },
  "dark": {
    "n": 64,
    "TP": 0,
    "TN": 51,
    "FP": 0,
    "FN": 13,
    "accuracy": 79.6875,
    "image_auroc": 48.114630467571644,
    "recall": 0.0,
    "fpr": 0.0
  }
}
```

## 한계·결정·다음
이미 살펴본 개발 데이터, 픽셀 정답 없음. 기존 raw-trained Dinomaly 앞의 보정은 추론 시 적응 실험이며 보정 후 재학습 모델과 다름. 공식 복원기는 외부 저조도 데이터로 사전학습됨. 방법 전체 완료 후 FP 감소와 FN 증가를 함께 비교. 단일 방법/카테고리 결과로 모든 조건 일반화를 주장하지 않음. 원본 변경/입력 복사 없음.

## 출처
- `E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_004726_illum_template_local_waterseal`
- `tools/screen_illumination_methods.py`
- `E:\DH\Sandbox\Dinopatch\output\comparisons\illumination_screen_20261010_003838`
- detector descriptor SHA256 `f53c4c5452ef1415e57d46997057b205836e20e3e2531144f9cc8c26559adb3b`
