# 조도 탐색: bank_zero_dce

## 질문·설정
Bright normal FIT224/CAL85 only, exact immutable baseline split; original TEST268. CAL q95 higher before TEST, strict >. Parameters fixed before scoring; previously inspected development data; no claim of independent generalization. Pixel corrections before frozen raw-trained Dinomaly are inference-only adaptation probes, not matched retraining. bank_* fits a new normal bank with identical correction for FIT/CAL/TEST. Official restoration checkpoints are externally pretrained, not trained only on field bright images. GNL-inspired AdaIN/EFDM uses FIT-only target statistics on collected DINO features, NOT official GNL reproduction. Shape/alignment extraction failure is REVIEW, never an automatic OK; numeric score-only metrics retain every case and review counts are separate.

RGB resize448 square / center crop392 / bank_zero_dce

각 조건의 밝은 CAL 임계값. 실제 dark 학습/보정 없음. 원본 영상 중심87.5% 검사. 전처리 후 FIT 정상 특징은행을 새로 구성한 비교.

## 검증 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 82,
    "TN": 124,
    "FP": 61,
    "FN": 1,
    "accuracy": 76.86567164179104,
    "image_auroc": 96.99120807554542,
    "recall": 98.79518072289157,
    "fpr": 32.972972972972975
  },
  "bright": {
    "n": 204,
    "TP": 69,
    "TN": 124,
    "FP": 10,
    "FN": 1,
    "accuracy": 94.6078431372549,
    "image_auroc": 99.6588486140725,
    "recall": 98.57142857142857,
    "fpr": 7.462686567164179
  },
  "dark": {
    "n": 64,
    "TP": 13,
    "TN": 0,
    "FP": 51,
    "FN": 0,
    "accuracy": 20.3125,
    "image_auroc": 100.0,
    "recall": 100.0,
    "fpr": 100.0
  }
}
```

## 한계·결정·다음
이미 살펴본 개발 데이터, 픽셀 정답 없음. 기존 raw-trained Dinomaly 앞의 보정은 추론 시 적응 실험이며 보정 후 재학습 모델과 다름. 공식 복원기는 외부 저조도 데이터로 사전학습됨. 방법 전체 완료 후 FP 감소와 FN 증가를 함께 비교. 단일 방법/카테고리 결과로 모든 조건 일반화를 주장하지 않음. 원본 변경/입력 복사 없음.

## 출처
- `E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_005038_illum_bank_zero_dce_waterseal`
- `tools/screen_illumination_methods.py`
- `E:\DH\Sandbox\Dinopatch\output\comparisons\illumination_screen_20261010_003838`
- detector descriptor SHA256 `a714e7a974ec51321a15e906d05f87b674b95b6edf224d3dc46a8986a407b244`
