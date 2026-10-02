---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [DINO_RECONPATCH_PROBE.md](file:///E:/DH/Sandbox/Dinopatch/docs/DINO_RECONPATCH_PROBE.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# DINO + ReConPatch 방식의 특징 학습 테스트

## 실행 결과 (2026-09-29)

| 구성 | Image AUROC | 정확도 | 정상 오탐 / 58 | swap 검출 / 12 |
|---|---:|---:|---:|---:|
| 기존 DINO | 99.36% | 92.67% | 0 | 1 |
| 학습 전 변환층 | 99.36% | 92.67% | 0 | 1 |
| 학습 후 변환층 | 98.93% | 94.00% | 2 | 5 |

학습 후 swap 이외 불량 80장은 모두 검출했다. 정상 오탐은 `test/good/037.png`, `test/good/038.png`다. Pixel AUROC는 기존 96.93%에서 96.64%, AUPRO30은 92.75%에서 91.87%로 감소했다. swap 검출 증가와 정상 오탐 증가가 함께 나타났으므로 전반적인 개선으로 해석하지 않는다. 이전 장거리 색상 관계 실험은 swap 5/12, 정상 오탐 0건으로 이번보다 좋은 판정 결과였다.

3개 모델의 아티팩트 검증과 새 모델 2개의 재로딩 점수·맵 재현 8건이 통과했다. 원본 파일 해시도 유지됐다. 같은 테스트셋을 반복 관찰한 탐색 실험이며 원 논문 ReConPatch 재현 결과가 아니다.

원 논문: https://arxiv.org/html/2305.16713v2

이 실험은 ReConPatch의 특징 적응 아이디어를 현재 DINO에 적용한 테스트이다. 원 논문의 CNN 기반 ReConPatch 성능을 재현한다고 주장하지 않는다. 기존 라이브러리의 기본 모델과 원본 데이터는 변경하지 않는다.

## 공통 데이터와 모델

- 기존 cable 분할: 정상 학습 179장, 정상 calibration 45장, 테스트 정상 58장 + 불량 92장.
- 특징 추출기는 고정된 DINOv2-registers-base, long side 700, 50x50x768 L2-normalized patch features.
- 배경 마스킹, 정합, 색상/위치 점수, 이미지 증강은 사용하지 않는다.
- calibration과 test는 특징 변환층 학습 및 memory bank 구성에서 제외한다. calibration은 마지막 정상 임계값 설정에만 사용한다.
- 동일 test의 이전 결과를 보고 시작한 실험이므로 탐색용 개발 평가이다.

## 특징 학습

선형 f:768→512와 g:512→128을 학습한다. 백본은 고정한다. EMA 모델이 pairwise Gaussian similarity와 contextual similarity를 생성하고, 이를 relaxed contrastive loss의 soft pseudo-label로 사용한다. Context는 이미지상 이웃이 아니라 **특징 공간에서 공유하는 가까운 이웃**이다. 정상 패치만 사용하며 NG 특징을 끌어내는 감독학습은 아니다.

- k=5, sigma=.5, pair/context 비중 .5/.5, margin=1, EMA=.999.
- orthogonal 초기화, AdamW lr=1e-4, weight_decay=.01, cosine learning rate schedule.
- 120 epoch, 각 epoch은 무작위 정상 패치 batch 512개 x 32 step으로 정의한다. 즉 3840 업데이트이며 원 논문의 120 full-data epoch과 동일하지 않다.
- 마지막 epoch을 고정 사용한다. 테스트 성능으로 epoch이나 하이퍼파라미터를 고르지 않는다.
- reciprocal k/2 이웃으로 contextual similarity를 확장한 후 대칭화한다. self를 이웃에 포함하고, 동일 특징 tie의 경우 reciprocal에 self를 보장한다.
- loss는 pair mean을 사용한다. 논문의 anchor별 합과 상수 배율 차이가 있다.

## 비교와 추론

1. 기존 DINO cosine 점수는 이전 결과를 그대로 참조한다.
2. 학습 전 f와 학습 후 f를 각각 비교한다. 초기화는 실제 학습 시작 시점과 동일한 가중치를 사용한다.
3. 각각 변환된 전체 정상 fit patch에서 Euclidean greedy coreset 30,000개를 다시 선택한다.
4. f 출력은 정규화하지 않고 nearest Euclidean distance로 채점한다. g와 EMA 모델은 추론에 사용하지 않는다.
5. 기존과 같은 상위 k 패치 평균으로 이미지 점수를 계산한다. 논문의 최대값/재가중 점수와 다르다.
6. 각 모델의 정상 calibration 점수 95% 분위수(higher)를 임계값으로 사용한다.

따라서 주된 학습 효과 비교는 **학습 전 변환층 vs 학습 후 변환층**이다. 기존 DINO와의 차이는 차원, 거리 및 coreset 구성도 포함한다. 학습 후 coreset 재선택 효과까지 포함하므로 변환층 자체만의 순수 효과로 해석하지 않는다.

## 실행과 산출물

```powershell
.venv/Scripts/python.exe -m unittest tests.test_reconpatch_probe tests.test_cable_relations tests.test_benchmark
.venv/Scripts/python.exe -m tools.probe_reconpatch
```

결과: `output/comparisons/cable_reconpatch_20260929_135958`.

공통 ExperimentArtifacts를 사용한다. checkpoint loader는 `tools.probe_reconpatch.AdapterDetector.load`이다. 학습 손실·projection 분산 곡선, 학습 상태(f/g/EMA/optimizer), 비교 CSV, 정상/불량 분포, 전체 이상 맵, 정상 참조 패치 확대와 재로딩 검증을 저장한다.

EMA pseudo-label이 매 step 변하므로 epoch별 loss는 완전히 동일한 목표함수에 대한 값이 아니다. Loss만으로 검출 성능이나 수렴을 단정하지 않고 별도 평가 결과를 확인한다.
