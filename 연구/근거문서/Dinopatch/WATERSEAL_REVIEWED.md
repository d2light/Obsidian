---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [WATERSEAL_REVIEWED.md](file:///E:/DH/Sandbox/Dinopatch/docs/WATERSEAL_REVIEWED.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# 재라벨링한 Waterseal 데이터 실험

사용자가 직접 정리한 `D:\datasets\waterseal\OK`, `NG`의 폴더 라벨을 사용한다.
이 경로는 읽기 전용으로 취급하며, 이전 자동 분류 결과로 라벨을 덮어쓰지 않는다.
실험용 이미지는 프로젝트의 새 `datasets/waterseal_<실행시각>_...` 폴더에 실제 복사한다.

## 고정 분할

파일명에서 촬영 일시와 카메라를 읽는다. 동일 날짜·카메라에서 인접 촬영 간격이
2초 이하인 이미지들을 하나의 연속 촬영 묶음으로 합친다. 불량이 포함된 묶음은
정상 이미지도 포함해 모두 검증에 배정한다. 나머지 정상 묶음을 날짜·카메라별로
seed 42로 섞어 약 50% 학습, 20% 임계값 보정, 나머지 검증에 사용한다.
비율은 이미지 수가 아닌 묶음 수 기준이며 반올림 차이가 있다. 묶음이 3개 미만인
촬영 조건은 모두 검증에 남긴다. 파일 또는 디코딩한 RGB가 중복되면 구축을 중단한다.

2026-09-28 실행의 분할은 다음과 같다.

| 용도 | 정상 | 불량 |
|---|---:|---:|
| 학습 | 252 | 0 |
| 임계값 보정 | 98 | 0 |
| 검증 | 144 | 83 |
| 전체 | 494 | 83 |

모든 577장을 정확히 한 용도에 사용한다. 학습·보정·검증 간 촬영 묶음과 동일 RGB
중복은 허용하지 않는다. 단, 같은 날짜가 여러 용도에 들어가므로 독립 촬영 세션에 대한
일반화 평가라고 해석하면 안 된다. 파일명 시각만으로 실제 제품 개체의 동일성을
확정할 수 없으며, 2초 이상 떨어진 유사 이미지까지 배제했다는 의미도 아니다.

## 학습과 평가

기본 DINOv2 패치 모델, `long_side=700`, `photo_aug=0`, `seed=42`를 사용한다.
정상 학습 이미지로 메모리 뱅크를 구성하고, 보정 정상 이미지의 최대 점수 × 1.2를
임계값으로 사용한다. 검증 라벨이나 검증 점수로 임계값을 조정하지 않는다.
검증 227장의 이미지 AUROC, 불량 검출률, 정상 오탐률, 혼동행렬과 개별 오류를 기록한다.
픽셀 마스크가 없어 pixel AUROC와 AUPRO는 미산출이다. 이상 지도는 검토용으로 보존한다.

원본의 상대 경로·폴더 라벨·파일 SHA256·RGB SHA256을 복사 전과 평가 후에 비교한다.
새 데이터셋에 `source_inventory.json`, `split.json`, `split.csv`, `protocol.json`을 남긴다.
실험 폴더에는 학습/평가 사본, 체크포인트, 원본 크기 이상 지도, 오버레이, 점수 CSV,
오류 목록, 검색 가능한 HTML, 검증 로그를 저장한다.

```powershell
$env:HF_HUB_OFFLINE='1'
$env:TRANSFORMERS_OFFLINE='1'
.venv/Scripts/python.exe -m tools.sample_waterseal --source D:/datasets/waterseal
.venv/Scripts/python.exe tools/validate_experiment_artifacts.py --run output/experiments/<실험폴더>
```

재실행은 항상 새 데이터셋과 실험 폴더를 생성한다. 원본을 이동하거나 수정하지 않는다.

## 2026-09-28 결과

임계값은 **0.1734326005**이며 점수가 이를 초과하면 NG로 판정한다.
검증 227장 중 TP 83, FN 0, TN 143, FP 1이다. 이미지 AUROC는 0.9999163,
불량 검출률은 100% (83/83), 정상 오탐률은 0.6944% (1/144)이다.
학습은 약 74초, 사전 로딩한 RGB 이미지의 추론 중앙값은 약 34ms였다.
이 추론 시간은 파일 읽기·원본 해상도 지도 생성·결과 저장 시간을 제외한다.
자동 회전 정합은 이번 학습에서 활성화되지 않았다.

| 촬영 날짜 | 정상 정답 | 정상 오탐 | 불량 검출 | 불량 미검출 |
|---|---:|---:|---:|---:|
| 2025-05-21 | 128 | 0 | 0 | 0 |
| 2025-08-18 | 13 | 1 | 54 | 0 |
| 2025-08-19 | 2 | 0 | 29 | 0 |

전체 정상 검증의 대부분은 5월 데이터다. 8월 정상만 보면 16장 중 1장 오탐(6.25%)이므로,
전체 오탐률만으로 8월 촬영 조건의 안정성을 주장하지 않는다. 날짜별 표본 수가 작고,
불량 점수 최솟값 0.1777339는 임계값에 가까워 새 촬영 조건에서 추가 검증이 필요하다.
이번 검증 결과를 보고 임계값을 수정하지 않았다.

오탐 파일은 `20250818_222059037_0000093353_T0000_01_CAM.jpg`이며 점수는 0.1813092다.
사용자 라벨 OK를 유지하며, 원본 및 사본의 폴더를 자동으로 변경하지 않는다.

- [검색 가능한 결과 보고서](file:///E:/DH/Sandbox/Dinopatch/output/experiments/DinoPatch_20260928_220227_waterseal_reviewed_baseline_full_ls700/index.html)
- [데이터 분할 내역](file:///E:/DH/Sandbox/Dinopatch/datasets/waterseal_20260928_220227_waterseal_reviewed_baseline_full_ls700/split.csv)
- [학습 모델](file:///E:/DH/Sandbox/Dinopatch/output/experiments/DinoPatch_20260928_220227_waterseal_reviewed_baseline_full_ls700/model/detector.pt)
- [오탐 이미지 오버레이](file:///E:/DH/Sandbox/Dinopatch/output/experiments/DinoPatch_20260928_220227_waterseal_reviewed_baseline_full_ls700/anomaly_maps/overlay/0287.jpg)
