# 조도 탐색: bank_clahe

## 질문·설정
Bright normal FIT224/CAL85 only, exact immutable baseline split; original TEST268. CAL q95 higher before TEST, strict >. Parameters fixed before scoring; previously inspected development data; no claim of independent generalization. Pixel corrections before frozen raw-trained Dinomaly are inference-only adaptation probes, not matched retraining. bank_* fits a new normal bank with identical correction for FIT/CAL/TEST. Official restoration checkpoints are externally pretrained, not trained only on field bright images. GNL-inspired AdaIN/EFDM uses FIT-only target statistics on collected DINO features, NOT official GNL reproduction. Shape/alignment extraction failure is REVIEW, never an automatic OK; numeric score-only metrics retain every case and review counts are separate.

RGB resize448 square / center crop392 / bank_clahe

각 조건의 밝은 CAL 임계값. 실제 dark 학습/보정 없음. 원본 영상 중심87.5% 검사. 전처리 후 FIT 정상 특징은행을 새로 구성한 비교.

## 검증 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 82,
    "TN": 121,
    "FP": 64,
    "FN": 1,
    "accuracy": 75.74626865671642,
    "image_auroc": 97.34939759036145,
    "recall": 98.79518072289157,
    "fpr": 34.5945945945946
  },
  "bright": {
    "n": 204,
    "TP": 69,
    "TN": 121,
    "FP": 13,
    "FN": 1,
    "accuracy": 93.13725490196079,
    "image_auroc": 99.80810234541579,
    "recall": 98.57142857142857,
    "fpr": 9.701492537313433
  },
  "dark": {
    "n": 64,
    "TP": 13,
    "TN": 0,
    "FP": 51,
    "FN": 0,
    "accuracy": 20.3125,
    "image_auroc": 95.92760180995474,
    "recall": 100.0,
    "fpr": 100.0
  }
}
```

## 한계·결정·다음
이미 살펴본 개발 데이터, 픽셀 정답 없음. 기존 raw-trained Dinomaly 앞의 보정은 추론 시 적응 실험이며 보정 후 재학습 모델과 다름. 공식 복원기는 외부 저조도 데이터로 사전학습됨. 방법 전체 완료 후 FP 감소와 FN 증가를 함께 비교. 단일 방법/카테고리 결과로 모든 조건 일반화를 주장하지 않음. 원본 변경/입력 복사 없음.

## 출처
- `E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_004932_illum_bank_clahe_waterseal`
- `tools/screen_illumination_methods.py`
- `E:\DH\Sandbox\Dinopatch\output\comparisons\illumination_screen_20261010_003838`
- detector descriptor SHA256 `a447ebff55aad4b12ee4b76de4b27739a5153caed2c118a030f0c320308fe893`
