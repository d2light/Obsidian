---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [CABLE_RELATIONS_EXPERIMENT.md](file:///E:/DH/Sandbox/Dinopatch/docs/CABLE_RELATIONS_EXPERIMENT.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# Cable 패치 관계 비교 실험

목적: 조도 변화 대응과 분리하여 색상, 위치, 인접 관계가 기존 패치 이상탐지의 미검출을 줄이는지 확인한다. 제품 기본 설정은 변경하지 않는다.

## 데이터와 평가

- `datasets/mvtec/cable`: 원본 수정 없이 읽기만 한다.
- 공식 정상 학습 224장: decoded RGB hash 단위 seed 42 분할, fit 179장 / calibration 45장.
- 공식 테스트 150장: 정상 58장, NG 92장. 테스트 정답은 학습, 가중치 및 임계값 선택에 사용하지 않는다.
- 임계값: 각 모델의 정상 calibration 점수 95% 분위수, `method='higher'`. 점수가 임계값보다 클 때 NG.
- 이미지 AUROC, 정확도, 정상 오탐, 유형별 NG 검출률을 함께 확인한다.
- 픽셀 AUROC와 AU-PRO@FPR<=.3은 종횡비 유지 long side 256으로 평가한다. 원본 해상도 결과도 별도 저장한다.
- 이번 테스트는 탐색 실험이다. 같은 테스트에서 후속 설정을 선택하면 독립적인 최종 성능 검증이 추가로 필요하다.

## 공통 구성

동결된 `facebook/dinov2-with-registers-base`, 입력 long side 700, 50x50 패치 격자, seed 42로 선택한 30,000개의 동일한 DINO coreset을 사용한다. 배경 마스킹과 정합은 모든 구성에서 끈다. 따라서 기준 모델은 기존 DINO 거리 계산의 통제 실험이며, 기본 `auto_bg` 전체 파이프라인과 동일한 설정이라는 뜻은 아니다.

역전파 학습 없이 정상 패치와 부가 특징을 함께 저장한다. 그래프 항목도 GNN 학습이 아니다.

| 구성 | DINO cosine | 색상 거리 계수 | 위치 거리 계수 | 관계 거리 계수 |
|---|---:|---:|---:|---:|
| dino | 1 | 0 | 0 | 0 |
| color | 1 | .25 | 0 | 0 |
| position | 1 | 0 | .5 | 0 |
| color_position | 1 | .25 | .5 | 0 |
| color_position_graph | 1 | .25 | .5 | .25 |

계수는 테스트 결과를 보기 전에 고정했다. 부가 특징 거리는 각 벡터의 평균 제곱 차이다.

- 색상: 인코더와 같은 RGB 리사이즈 후 float Lab으로 변환. L/100, a/128, b/128을 패치별 평균·표준편차 6차원으로 저장한다.
- 위치: x/y를 각각 [0,1]로 표현하여 먼 위치와의 매칭에 연속적인 페널티를 준다. 강제적인 위치 제한은 아니다.
- 관계: 각 패치의 평균 Lab과 좌/우/상/하 이웃 간 부호 있는 차이 12차원. 경계 밖 연결은 0이며 반대쪽으로 연결하지 않는다. 색상 관계를 표현하며 케이블 개수나 부품 그래프를 직접 추출하는 방법은 아니다.
- 각 쿼리 패치는 위 거리 합을 최소화하는 **하나의 정상 참조 패치**와 매칭된다. 서로 다른 정상 패치의 색상/위치를 각각 골라 조합하지 않는다.
- 이미지 점수는 기존과 같은 상위 k 패치 평균이다: k=clip(round(패치 수 x .01),5,20).

## 재현 및 시각화

```powershell
.venv/Scripts/python.exe -m unittest tests.test_cable_relations tests.test_benchmark
.venv/Scripts/python.exe -m tools.probe_cable_relations
.venv/Scripts/python.exe -m tools.visualize_cable_matches --comparison output/comparisons/<실행 폴더> --verify
```

각 모델은 공통 `ExperimentArtifacts`로 체크포인트, 정상 마스터, 원본 평가 이미지, 수치 이상 맵, 오버레이, 정답 마스크, 결과 CSV, 오류 목록과 HTML을 저장한다. 로더는 `tools.probe_cable_relations.RelationDetector.load`이며 `AnomalyDetector.load`용 체크포인트가 아니다. DINO 사전학습 가중치는 기존 Hugging Face 캐시가 필요하다.

공통 정상 뱅크 학습 시간은 `model/metadata.json`의 `shared_fit_seconds`에 기록한다. 각 run의 `fit_seconds`는 재사용 뱅크의 학습 이미지 hash 검증 시간이다.

비교 갤러리에서 초록 선은 정답 결함 윤곽이며 빨강은 각 이미지 판정 임계값의 2배에 해당하는 지도 값이다. 픽셀별 결함 확률이나 픽셀 판정 임계값을 뜻하지 않는다. `matches.html`은 각 구성의 최고 점수 패치와 실제 선택된 정상 패치의 확대 비교이며 전체 top-k 판정 중 한 패치만 보여준다.

단일 카테고리·단일 분할 결과이므로 일반화 성능을 단정하지 않는다. DINO로 선택한 동일 coreset을 사용하기 때문에 색상/관계용으로 별도 선택한 뱅크의 효과는 평가하지 않는다.

## 2026-09-29 실행 결과

보고서: `output/comparisons/cable_relations_20260929_130732/index.html`

| 구성 | 정확도 | 전체 NG 검출 | cable_swap 검출 | 정상 오탐 | 이미지 AUROC |
|---|---:|---:|---:|---:|---:|
| DINO | 92.67% | 81/92 | 1/12 | 0/58 | 99.36% |
| +색상 | 92.67% | 81/92 | 1/12 | 0/58 | 99.44% |
| +위치 | 93.33% | 82/92 | 2/12 | 0/58 | 99.59% |
| +색상+위치 | 94.00% | 83/92 | 3/12 | 0/58 | 99.68% |
| +색상+위치+관계 | 94.00% | 83/92 | 3/12 | 0/58 | 99.64% |

모든 구성의 미검출은 cable_swap에 집중되었다. 색상+위치에서 새로 검출한 `002.png`, `005.png`는 임계값 근처이므로 강한 개선으로 해석하지 않는다. 이번 국소 색상 관계 표현은 추가적인 이미지 검출 개선을 보이지 않았다. 일반적인 그래프 접근 전체를 기각하는 결과는 아니다.
