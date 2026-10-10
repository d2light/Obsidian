# 밝은 정상 조도쌍 학습: augmentation

## 질문·변경
밝은 정상 원본과 gain/gamma 변형 쌍으로 실제 어두운 검사 영상에 일반화되는가? 실제 dark FIT/CAL 없음. 원본 재라벨링·복사 없음.

## 설정
동일 FIT224/CAL85/TEST268. 밝은 OK134/NG70, 어두운 OK51/NG13. 고정100epoch, seed1, batch 원본8+변형8. DINO 동결, bottleneck/decoder만 학습. 원본·변형 native 재구성 손실 평균. 일관성 가중치 0.0. 원본 특징 stop-gradient, 병목/마지막 decoder 패치 토큰 cosine 평균.
gain log-uniform[0.35,1.3], gamma uniform[0.7,1.5], 공간 변형 없음. CAL은 밝은 원본 q95 higher, strict >. 검사는 기존 resize448/crop392, native 점수. 최종 epoch 고정; TEST로 설정 선택 없음.

## 측정
```json
{
  "primary": {
    "n": 268,
    "TP": 82,
    "TN": 129,
    "FP": 56,
    "FN": 1,
    "accuracy": 78.73134328358209,
    "image_auroc": 91.99609247802019,
    "recall": 98.79518072289157,
    "fpr": 30.27027027027027
  },
  "bright": {
    "n": 204,
    "TP": 69,
    "TN": 129,
    "FP": 5,
    "FN": 1,
    "accuracy": 97.05882352941177,
    "image_auroc": 99.73347547974414,
    "recall": 98.57142857142857,
    "fpr": 3.7313432835820897
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
GNL 아이디어를 참고한 Dinomaly 변형이며 공식 GNL 재현 아님. 실제 TEST는 이전에 관찰한 개발 데이터. 1 seed, 어두운 NG13장, 픽셀GT 없음. 증강만/일관성 추가 비교 후 오탐·미탐 동시 확인. 동결 encoder 자체의 조도 민감성은 남는다. 인간 수준 물체 이해를 검증한 것은 아님.

## 출처
- `E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261009_224941_field_waterseal_dinomaly`
- `tools/probe_photometric_consistency.py`
- 기준 `E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261009_180251_field_waterseal_dinomaly`
- 모델 SHA256 `e7281d512152ff7ef36ba4d01c10ce50cda7b11fb47a4a2504e783d80d78a9fc`
