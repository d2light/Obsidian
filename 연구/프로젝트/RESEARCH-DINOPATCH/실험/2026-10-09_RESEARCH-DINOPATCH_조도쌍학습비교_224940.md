# 밝은 정상 조도쌍 학습 비교 결과

## 질문·변경·설정
실제 bright FIT224/CAL85만 이용. 기존 모델 / 합성 gain-gamma 증강 / 증강+내부 특징 일관성0.1. 고정100epoch, 원본 TEST268. 상세 설정은 계획 노트 및 locked_config.json. TEST에 맞춘 임계값 변경 없음.

## 검증 측정
|방식|범위|AUROC %|FP|FN|
|---|---|---:|---:|---:|
|기존 Dinomaly|primary|91.9179|56|1|
|기존 Dinomaly|bright|99.8188|5|1|
|기존 Dinomaly|dark|100.0000|51|0|
|조도 증강|primary|91.9961|56|1|
|조도 증강|bright|99.7335|5|1|
|조도 증강|dark|100.0000|51|0|
|증강 + 특징 일관성|primary|91.8528|56|1|
|증강 + 특징 일관성|bright|99.8188|5|1|
|증강 + 특징 일관성|dark|98.9442|51|0|

## 기전 진단
```json
{
  "baseline": {
    "encoder": 0.09071877878159285,
    "bottleneck": 0.14627861138433218,
    "decoder": 0.006209455139469355,
    "original_score": 0.05273306160233915,
    "synthetic_score": 0.065938153071329,
    "score_shift": 0.013205091468989849
  },
  "augmentation": {
    "encoder": 0.09071877878159285,
    "bottleneck": 0.14713586308062077,
    "decoder": 0.03106843144632876,
    "original_score": 0.05103735812008381,
    "synthetic_score": 0.04960222402587533,
    "score_shift": -0.001435134094208479
  },
  "consistency": {
    "encoder": 0.09071877878159285,
    "bottleneck": 0.012486708525102586,
    "decoder": 0.002257058906252496,
    "original_score": 0.05185972689650953,
    "synthetic_score": 0.05042880354449153,
    "score_shift": -0.0014309233520179987
  }
}
```

## 사후 밝기 범위 진단
영상 휘도 q99.5로 평가한 이번 합성 범위는 실제 dark보다 밝았다. 범위 밖인 실제 dark를 포함했으므로 이번 실패를 모든 조도 증강의 실패로 일반화하면 안 된다. 전체 특징 분포/단일 원인을 입증하는 통계는 아님. 설정·임계값 변경 없음.
```json
{
  "fit_min_aug_q995_min_median_max": [
    0.3499999940395355,
    0.3499999940395355,
    0.3499999940395355
  ],
  "actual_dark_q995_min_median_max": [
    0.2705882489681244,
    0.29411765933036804,
    0.3137255012989044
  ],
  "dark_below_all_fit_augmentation": 64,
  "dark_count": 64,
  "posthoc": true,
  "interpretation": "Global highlight luminance only; not proof of feature-domain coverage or sole cause. No training/threshold changes."
}
```

## 완료 후 결정
최종 확인: 증강 및 특징 일관성 추가 모두 오탐·미탐 개선 없음. 실제 TEST 판정은 기준 모델과 전부 동일. 이번 구성은 채택 보류. 합성 CAL에서 특징이 안정된 것과 실제 dark 검출 개선은 별개였음. 합성 조도 범위 부족과 고정 encoder의 조도 민감성이 원인 후보이나, 각각의 인과 효과를 분리해 증명하지는 못함. 다음은 FIT만으로 더 넓은 조도·그림자 범위를 사전 정의하고, 변형된 특징을 같은 공간에서 비교하는 구성을 분리 검증. 현재 TEST를 반복 사용하는 결과는 개발 결과로만 취급하며, 일반화 확인에는 새로운 촬영 그룹이 필요.

## 실패·한계·다음
실제 어두운 NG13장, 1 seed, 과거 관찰한 개발 TEST, 픽셀GT 없음. frozen encoder 조도 민감성이 남으며 특징 일관성의 개선과 최종 검출 성능은 별개. 증강 원본 clip은 일부 포화 가능. 학습 view 수 차이는 증강만 모델로 구분. 최종 판단은 어두운 정상 오탐과 밝음/어둠 불량 미탐을 함께 보고 내린다. 실패 시 TEST에 맞춘 파라미터 반복 최적화 대신 새 촬영 그룹 확보 및 점수 산출의 조도 민감성 분석을 우선한다.

## 검증·출처·용량
동일 split SHA256 `f81058ecab9561447dbf48a97057e37314065ec9f3d700ae9466020c7d9f0010`, 원본 해시, 모델 재로드, encoder 동결, 지표 재계산, 브라우저 필터·링크·JPG 확인. 원본 복사0. 신규 모델별 실제 bytes `{'augmentation': 826816717, 'consistency': 826779795}`.
- `E:\DH\Sandbox\Dinopatch\output\comparisons\photometric_consistency_20261009_224940`
- `tools/probe_photometric_consistency.py`
- `tools/report_photometric_consistency.py`

![[2026-10-09_RESEARCH-DINOPATCH_조도쌍학습비교_224940_score_comparison.jpg]]

![[2026-10-09_RESEARCH-DINOPATCH_조도쌍학습비교_224940_fit_augmentation.jpg]]

![[2026-10-09_RESEARCH-DINOPATCH_조도쌍학습비교_224940_training_curves.jpg]]
