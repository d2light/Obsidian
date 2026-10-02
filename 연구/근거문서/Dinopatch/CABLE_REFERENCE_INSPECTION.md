---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [CABLE_REFERENCE_INSPECTION.md](file:///E:/DH/Sandbox/Dinopatch/docs/CABLE_REFERENCE_INSPECTION.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# 정상 기준 기반 검사: 첫 부품 후보 실험

## 결과

첫 부품 후보 모듈을 구현하고 정상 fit 179장에서 두 방법을 실행했다. 실제 불량 탐지 모델을 완성하거나 학습한 결과가 아니다. 승인된 계획의 실패 분기에 따라, 정상 영상에서도 부품을 안정적으로 구분하지 못해 색상 분류·CNN 결합·테스트 평가는 진행하지 않았다.

| 방법 | 후보가 정확히 3개인 영상 | 해석 |
|---|---:|---|
| 연결 윤곽 + 타원 피팅 | 0 / 179 | 경계가 끊기거나 연결되어 부품 윤곽으로 묶이지 않음 |
| Hough 원형 후보 | 157 / 179 | 후보 수 일치일 뿐 올바른 부품 분리라는 뜻은 아님 |
| Hough 후보 3개 + 세 후보 모두 윤곽 지지율 ≥ 0.65 | 16 / 179 | 기존 진단 기준 충족 수이며 분할 정확도가 아님 |

윤곽 방법은 후보 수 0개 151장, 1개 27장, 2개 1장이다. Hough 방법은 3개 157장, 4개 20장, 5개 1장, 6개 1장이다. 윤곽 방법은 지지율로 후보를 걸러내지만 Hough 진단은 낮은 지지율의 후보도 보존한다. 따라서 두 방법의 후보 수를 정확도처럼 직접 비교하면 안 된다.

## 확인한 실패

- 정상 003: 외피 일부를 네 번째 부품으로 검출했다.
- 정상 024: 내부 부품 외에 외피·배경·중복 후보가 나타났다.
- 정상 027: 케이블 주변 구조가 추가 원형 후보로 검출됐다.
- 정상 000: 후보 세 개가 잡혀도 원형 근사의 경계와 실제 비원형 피복 경계가 정확히 일치하지 않는다. 피복 고리에 외부 또는 금속 영역이 섞일 수 있다.

표시된 마스크는 실제 분할 결과가 아니라 원/타원 후보를 채운 기하학적 마스크다. 색상 오버레이는 인스턴스 번호 표시이며 색상 분류나 결함 표시가 아니다. 원형 경계 지지율이 낮은 것은 실제 결함의 증거가 아니다.

## 방법과 데이터

기존 split의 정상 fit만 읽었다. 000/003/007의 기존 에이전트 근사 표시로 크기 범위를 정하고, 첫 fit 12장으로 방법을 탐색했다. Hough 후보의 누적 투표값 25/35/45를 정상 fit에서 비교한 뒤 35를 고정했다. 이는 추가한 fit-only 대안이며 원래 윤곽 방식과 분리하여 기록했다. fit 전체 결과를 보고 테스트에 맞춘 재조정은 하지 않았다.

그레이스케일 → Gaussian blur → Canny → 연결 윤곽의 타원 피팅, 또는 그레이스케일 Hough 원형 후보를 사용한다. 둘 다 색상별 영역을 먼저 찾지 않으며 세 개를 강제로 출력하지 않는다. 크기·중복 조건을 적용하고 원본 크기의 후보/고리 마스크와 후보별 경계 지지율을 저장한다.

calibration 45장과 test 150장은 추론하지 않았다. 분류 임계값, NG 검출률, AUROC, 학습 손실은 없다. 첫 단계의 fit-only 탐색이므로 완성 모델용 ExperimentArtifacts 스키마 대신 계획에 명시한 comparisons 진단 형식을 사용한다. 별도 검증 명령으로 해시·분할·집계·마스크·이미지·링크를 확인한다.

## 출력 및 재현

- 통합 시각화: `output/comparisons/reference_inspection_20260929_summary/index.html`
- 윤곽 전체: `output/comparisons/reference_inspection_fit_20260929_165759_contour/index.html`
- Hough 전체: `output/comparisons/reference_inspection_fit_20260929_165759_hough/index.html`
- 코드: `tools/probe_reference_inspection.py`

```powershell
.venv/Scripts/python.exe -m unittest tests.test_reference_inspection tests.test_component_graph tests.test_benchmark
.venv/Scripts/python.exe -m tools.probe_reference_inspection --pilot --method contour
.venv/Scripts/python.exe -m tools.probe_reference_inspection --method hough
.venv/Scripts/python.exe -m tools.probe_reference_inspection --validate output/comparisons/reference_inspection_fit_20260929_165759_hough
```

각 실행은 새로운 폴더를 만든다. 소스 이미지 SHA256과 저장된 원본 픽셀, 원본 크기 마스크, CSV/JSON 일치, 기존 canonical fit split과의 완전 일치, 실행 코드 스냅샷, HTML 링크를 검증한다. 원본은 변경하지 않는다.

최종 검증: 관련 테스트 12개 통과. 두 전체 실행 각각 `valid=true, files=546, fit_images=179, test_images=0` 확인. 저장 config로 000/003/007의 후보와 마스크를 재계산하여 동일함을 확인했다. 통합 보고서의 상대 링크와 집계도 확인했다. 코드 검토에서 발견된 canonical split 대조 누락을 보완하고, 누락/역할 변경을 거부하는 회귀 검사를 추가했다.

## 다음 설계에 주는 근거

부품 구분 이후 색상을 검사한다는 구조 자체가 부정된 것은 아니다. 단순한 원/타원 후보를 신뢰 가능한 부품 분할로 사용할 수 없다는 결과다. 다음에는 소량의 정상 이미지에서 각 피복의 실제 경계를 표시하고, 이를 이용한 인스턴스 분할을 먼저 검증해야 한다. 색상별 한 영역을 강제하는 이전 방식으로 돌아가거나 후보 수를 임의로 세 개로 제한하지 않는다. 아직 그 분할 모델의 개선 효과를 검증한 것은 아니다.
