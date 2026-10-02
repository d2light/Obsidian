---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [DATASET_ACQUISITION_20260930.md](file:///E:/DH/Sandbox/Dinopatch/docs/DATASET_ACQUISITION_20260930.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# 추가 확보한 산업 이미지

2026-09-30 사용자 요청에 따라 원본을 수정하지 않고 전체를 복사했다. 이미지 리사이즈·재인코딩·제외 없이 보존했으며, 복사 후 SHA256 대조와 이미지 디코딩 확인을 수행했다.

| 데이터셋 | OK | NG | 합계 | 저장 위치 |
|---|---:|---:|---:|---|
| ipsAuto 볼트 | 2,701 | 17 | 2,718 | `datasets/industrial/bolt_ipsAuto` |
| IV00005 금속 링 | 991 | 990 | 1,981 | `datasets/industrial/metal_ring_IV00005` |

각 데이터셋의 `OK/`, `NG/`에 이미지가 있다. `manifest.json`은 원본 경로·정답·파일 해시·픽셀 해시·해상도를, `audit.json`은 중복과 라벨 충돌을, `file_manifest.json`은 보관 파일 전체의 해시를 기록한다. 기존 `datasets/industrial/bolt`와 분리했다.

## 볼트

출처는 `D:/datasets/ipsAuto`. 사용자 확인된 폴더 라벨을 그대로 사용했다. JPG 2,715장과 BMP 3장을 모두 보존했다. 파일명보다 소속 폴더가 라벨의 기준이다.

픽셀이 동일한 OK 이미지 2장이 한 쌍 있다. 삭제하지 않았으며 분할 시 같은 그룹으로 묶어야 한다. 라벨 충돌은 없다.

## IV00005

`ai_solution/input/labels/metal_ring_20260922_IV00005_ground_truth.json`의 사용자 전체 확인 라벨을 사용했다. 장비 판정에서 수정된 9장의 정답도 반영했으며, 파일명 안의 OK/NG는 장비 판정일 수 있으므로 정답으로 읽으면 안 된다.

현재 Downloads/IV에는 JPEG 1,274장만 있어, 전체 1,981장은 `ai_solution/input/train_img/experiments/IV00005_reviewed_all_20260923_134701`의 보관 이미지에서 확보하고 확정 라벨의 해시와 일치함을 확인했다. 중복 픽셀과 라벨 충돌은 없다.

`raw_export/`에는 현재 `C:/Users/CM/Downloads/IV`의 모든 3,255개 파일(JPEG 1,274개, IV4P 1,981개)을 원래 구조로 별도 보존했다. **raw_export는 학습 이미지 루트가 아니다.** `provenance/`에는 원래 라벨 이력과 출처 목록을 보존했다.

## 이후 학습·테스트 분할

이번 작업은 전체 확보 단계이며 `split=null`로 기록했다. 아직 학습이나 분할을 수행하지 않았다. 동일 픽셀은 반드시 같은 split에 배치하고, 연속 촬영·생산 시점에 따른 유사 이미지 누수도 별도로 점검해야 한다. 정상만 학습하는 이상탐지에서는 NG를 정상 메모리뱅크에 넣지 않는다. 볼트 NG는 17장이므로 불량 유형별 평가 수를 확인한 후 분할을 확정한다.

검증 기록: [dataset_acquisition_validation_20260930.json](file:///E:/DH/Sandbox/Dinopatch/output/dataset_acquisition_validation_20260930.json).
