---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [CABLE_FEATURE_CONTROL.md](file:///E:/DH/Sandbox/Dinopatch/docs/CABLE_FEATURE_CONTROL.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# CNN / DINO 특징과 정규화 통제 실험

## 결과 (2026-09-29)

| 구성 | 전체 이미지 AUROC | swap 대 정상 AUROC | swap 검출 / 12 | 정상 오탐 / 58 | 회전 NG 수: 90 / 180 / 270도 (각 58장) |
|---|---:|---:|---:|---:|---|
| CNN 원특징 | 98.99% | 96.26% | 10 | 6 | 58 / 58 / 58 |
| CNN 외부 L2 정규화 | 86.84% | 46.26% | 0 | 4 | 57 / 58 / 55 |
| DINO 원특징 | 95.30% | 70.11% | 0 | 1 | 1 / 5 / 5 |
| DINO 외부 L2 정규화 | 93.22% | 59.48% | 0 | 5 | 2 / 5 / 6 |

같은 CNN 특징과 고정 메모리에서 외부 정규화가 swap 구분을 크게 낮췄다. 이는 raw 특징의 크기 정보를 포함한 거리가 이 조건에서 유용했음을 보여준다. 단, normalized 특징으로 coreset을 재선택한 최적 구성의 성능을 뜻하지는 않는다.

DINO는 외부 정규화를 없애도 swap 검출이 회복되지 않았다. 입력·격자·메모리 예산·점수 집계를 통일한 이 조건에서도 특징 파이프라인 차이가 남는다. swap 대 정상 AUROC에서도 차이가 있으므로 임계값 선택만으로 설명할 수 없다. 한편 DINO는 디지털 정상 회전에 훨씬 덜 민감했다. CNN이 일반적인 배치 규칙을 이해해서 정상 회전과 swap을 구분했다는 증거는 아니다.

기존 DINO 700 전체 입력 및 공식 PatchCore 224/28×28 격자와는 별도의 통제 구성이다. 본 결과를 기존 제품 기본값의 성능으로 대체하지 않는다. 선택된 정상 메모리 인덱스와 실제 백본 가중치가 raw/unit 쌍에서 동일함을 체크포인트 비교로 확인했으며 `normalization_verification.json`에 기록했다.

질문: 기존 DINO와 공식 PatchCore의 cable_swap 검출 차이가 입력·점수 집계 조건을 맞춰도 남는가? 최종 특징의 외부 단위길이 정규화가 영향을 주는가?

사용자가 승인한 비교 실험이며 제품 코드와 기본 모델은 바꾸지 않는다. 비교표의 모든 구성은 탐색용이다. 테스트셋을 앞선 실험들에서 이미 관찰했으므로 새 최종 평가셋은 아니다.

## 고정 조건

- 기존 cable 분할 그대로: 정상 fit 179, 정상 calibration 45, test 150(정상 58, 불량 92).
- 입력 텐서는 공식 `MVTecDataset.transform_img` 그대로 공통 사용: Resize256 → CenterCrop224 → ToTensor → ImageNet 정규화.
- FP32, TF32 비활성화. 배경 분리·정합·증강 없음.
- 16×16 특징 격자. CNN의 28×28 격자는 bilinear(align_corners=False)로 16×16에 맞춘다. DINO는 16×16 원래 토큰 격자다.
- 정상 메모리 크기 4,582개: 179×256의 10% 내림. 두 백본 모두 공식 approximate greedy coreset 알고리즘(seed42, projection128, starts10)을 적용한다.
- 각 백본의 **원특징에서 coreset을 한 번만 선택**하고, raw/unit 구성에서 같은 원본 패치 인덱스를 사용한다. 백본 간 선택되는 패치는 다를 수 있다.
- 최근접 제곱 L2 거리의 최댓값을 이미지 점수로 사용. 모든 구성에서 동일하다. 맵은 16×16 거리에서 bilinear 보간하며 Gaussian smoothing은 하지 않는다.
- 임계값은 각 구성의 회전하지 않은 정상 calibration 점수 q95(higher). 테스트 점수나 각도별로 임계값을 선택하지 않는다.

## 바꾸는 요소

| 구성 | 특징 파이프라인 | 외부 단위길이 정규화 |
|---|---|---|
| cnn_raw | 공식 WR50 ImageNet V1 layer2+3, patch3, embed1024 → 16×16 | 없음 |
| cnn_unit | 위와 동일, 같은 정상 패치 | 적용 |
| dino_raw | DINOv2-registers-base 마지막 패치 토큰768 | 없음 |
| dino_unit | 위와 동일, 같은 정상 패치 | 적용 |

정규화 후 제곱 L2는 코사인 거리의 정확히 두 배다. 따라서 단순히 코사인 거리 대신 L2라는 이름을 쓰는 효과와 정규화로 벡터 크기 정보를 제거하는 효과를 혼동하지 않는다. DINO raw는 마지막 토큰에 추가하는 `F.normalize`만 생략하며 사전학습 모델 내부 LayerNorm은 그대로다.

이 비교는 입력·격자 크기·메모리 예산·점수 규칙을 통일한다. 특징 파이프라인은 서로 다른 층, 수용영역, 차원과 집계 방식을 유지하므로 순수한 CNN/Transformer 아키텍처 하나만의 인과 효과라고 해석하지 않는다. 또한 정규화한 특징에 최적화하여 coreset을 다시 뽑는 실험도 아니다.

## 회전·시각화·검증

각 구성에서 정상 테스트 58장에 0/90/180/270도 반시계 픽셀 순열 회전을 적용한다. 이미지 전체와 배경이 함께 회전하며 보간이나 패딩은 없다. 합성 회전은 확정 라벨 null, 의도 라벨 0으로 기록하고, 방향이 허용된다는 가정 아래 NG 비율을 해석한다. 원본 58장의 반복 관측이며 232개의 독립 표본이 아니다.

중앙 crop의 원본 좌표는 `[64:960,64:960]`이다. 원본 크기 맵 바깥의 0은 미관찰 영역의 자리표시자다. 공통 pixel metric은 미관찰 경계까지 포함하므로 공식 cropped pixel metric과 동일하지 않다. 회전 맵은 `valid` 마스크를 저장하며 비교 카드의 경계 설명에도 미관찰 영역임을 표시한다.

체크포인트는 실제 특징 추출기 가중치, 원본 메모리와 선택 인덱스, 정규화 여부, 임계값, 학습 이미지 해시를 포함한다. 새 추출기를 생성해 저장 가중치를 복원하고 정상 58장 + 불량 2장의 점수·맵을 각 구성에서 재검증한다. 공통 artifact validator, HTML 링크, 원본 SHA256을 확인한다.

```powershell
.venv/Scripts/python.exe -m unittest tests.test_feature_control tests.test_patchcore_rotation
.venv/Scripts/python.exe -m tools.probe_feature_control
```

현재 실행: `output/comparisons/cable_feature_control_20260929_143852`.
