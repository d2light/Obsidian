# 조도 탐색: retinexformer

## 질문·설정
Bright normal FIT224/CAL85 only, exact immutable baseline split; original TEST268. CAL q95 higher before TEST, strict >. Parameters fixed before scoring; previously inspected development data; no claim of independent generalization. Pixel corrections before frozen raw-trained Dinomaly are inference-only adaptation probes, not matched retraining. bank_* fits a new normal bank with identical correction for FIT/CAL/TEST. Official restoration checkpoints are externally pretrained, not trained only on field bright images. GNL-inspired AdaIN/EFDM uses FIT-only target statistics on collected DINO features, NOT official GNL reproduction. Shape/alignment extraction failure is REVIEW, never an automatic OK; numeric score-only metrics retain every case and review counts are separate.

RGB resize448 square / center crop392 / retinexformer

각 조건의 밝은 CAL 임계값. 실제 dark 학습/보정 없음. 원본 영상 중심87.5% 검사. 기존 가중치/전통 점수에 대한 고정 설정 탐색 실험. Dinomaly 재학습 없음.

## 검증 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 29,
    "TN": 173,
    "FP": 12,
    "FN": 54,
    "accuracy": 75.3731343283582,
    "image_auroc": 66.53858677955063,
    "recall": 34.93975903614458,
    "fpr": 6.486486486486487
  },
  "bright": {
    "n": 204,
    "TP": 29,
    "TN": 122,
    "FP": 12,
    "FN": 41,
    "accuracy": 74.01960784313725,
    "image_auroc": 67.12153518123667,
    "recall": 41.42857142857143,
    "fpr": 8.955223880597014
  },
  "dark": {
    "n": 64,
    "TP": 0,
    "TN": 51,
    "FP": 0,
    "FN": 13,
    "accuracy": 79.6875,
    "image_auroc": 57.01357466063348,
    "recall": 0.0,
    "fpr": 0.0
  }
}
```

## 한계·결정·다음
이미 살펴본 개발 데이터, 픽셀 정답 없음. 기존 raw-trained Dinomaly 앞의 보정은 추론 시 적응 실험이며 보정 후 재학습 모델과 다름. 공식 복원기는 외부 저조도 데이터로 사전학습됨. 방법 전체 완료 후 FP 감소와 FN 증가를 함께 비교. 단일 방법/카테고리 결과로 모든 조건 일반화를 주장하지 않음. 원본 변경/입력 복사 없음.

## 출처
- `E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_004250_illum_retinexformer_waterseal`
- `tools/screen_illumination_methods.py`
- `E:\DH\Sandbox\Dinopatch\output\comparisons\illumination_screen_20261010_003838`
- detector descriptor SHA256 `d374ea1ac321582721b90801b4a37da68a10d32c7b571ea9a2bff95f76713827`
