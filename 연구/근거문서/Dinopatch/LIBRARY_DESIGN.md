---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [LIBRARY_DESIGN.md](file:///E:/DH/Sandbox/Dinopatch/docs/LIBRARY_DESIGN.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# DinoPatch 라이브러리 구성안

상태: 2026-09-28 사용자 승인. 공개 이름은 `dinopatch`, 학습·테스트 중복 제거.

## 목적과 범위

`07_anomaly_dino`의 DINOv2 패치 기반 이상탐지를 다른 Python 프로그램에서
설치·호출할 수 있게 묶는다. 동결 백본 → 정상 패치 메모리뱅크 → cosine 최근접 거리 →
상위 패치 점수라는 기존 흐름을 재사용한다.

실제 데이터는 MVTec AD, VisA, waterseal, bolt만 복사한다.
이전 실험 수치는 재학습 결과와 구별해 보관하고, 원본 파일별 SHA-256을 남긴다.

## 권장 구조

- 설치 프로젝트명: `dinopatch`.
- Python import 이름: `dinopatch`.
- 공개 기능: `Config`, `AnomalyDetector`, `mvtec_split`, `evaluate`.
- 사용 흐름: `fit(normal_images)` → `score(images)` → `save/load`.
- 운영 임계: 별도 정상 검증 이미지로 `calibrate()`; 최종 테스트셋으로 보정하지 않는다.
- 기존 `features`, `bank`, `score`, `align`, `masks`를 재사용하며 별도 플러그인 계층은 만들지 않는다.
- DINOv2 기본 경로를 우선 지원한다. SAM, U2-Net, timm 등은 선택 의존성으로 분리한다.
- GUI, 웹 서버, 다른 산업 제품의 특수 ROI, 전체 비교 모델 재학습은 이번 구성 범위에서 제외한다.

## 데이터와 자료

```text
datasets/
  mvtec/                 # 15종
  visa/                  # 12종, 기존 MVTec 형식 변환본
  industrial/
    water_seal/          # 사용자 요청의 waterseal
    bolt/
results/
  papers/                # 비교 논문 PDF 5편과 추출 텍스트
  archive/               # 선별한 기존 측정 CSV·요약
  registry.csv           # 기존 실험 레지스트리, 원본 보존
docs/
  RESEARCH_SUMMARY.md
  research/              # 이미지 내장형 HTML 설명 자료
references/legacy/       # 변경하지 않은 기존 코드·README·상태·비교표
migration/               # 원본 경로·복사 경로·크기·SHA-256
```

VisA 원본 이미지의 중복 복사는 하지 않으며 라이선스와 원본 single-class split CSV는 보존한다.
bolt의 `head_defect` 3장은 사양 미확정 자료로 보존한다. 기존 14/14 결과 재현 시에는
이 폴더를 제외했다는 조건을 명시한다. waterseal의 기존 정량 결과는 확인되지 않았다.

## 코드 조사에서 확인해 보완한 항목

아래 항목은 기존 코드에서 발견한 문제다. 현재 `dinopatch`에는 상태 저장·복원,
최소 장수·격자 검사, 외부 경로 설정, 결함 마스크 누락 오류를 반영했다.
waterseal·bolt 중복 학습 이미지와 대응 물체 마스크는 격리했으며,
공통 데이터 로더와 임계 보정도 중복을 검사한다.

1. 기본 `auto_bg`의 `border_bank`, `bg_thr`, `self_split` 등이 기존 `save/load`에
   보존되지 않는다. 그대로 패키징하면 기본 모델 저장 후 재추론이 깨지므로
   저장 전후 점수·지도의 일치 검사를 추가하고 상태 저장을 보완해야 한다.
2. `auto_bg`의 보정 분할은 `max(5, n // 5)`여서 정상 학습 이미지가 5장 이하이면
   뱅크 생성용 목록이 비게 된다. 지원 최소 장수를 명시하고 입력 단계에서 검사해야 한다.
3. 고정 패치 격자를 가정하는 경로가 있으므로 학습·추론 간 격자 호환성을 검사해야 한다.
4. SAM의 타 프로젝트 절대경로를 라이브러리의 기본 경로로 사용하지 않는다.
5. `gt_mask()`는 결함 마스크가 없을 때 전부 0으로 반환한다. 미라벨을 정상 마스크로
   해석하지 않도록 라이브러리 경계에서 누락을 구분해야 한다.
6. 현재 데이터의 waterseal 정상 테스트 260장 전부와 bolt 정상 테스트 36장이
   학습 이미지와 동일한 SHA-256을 가진다. 원본 이관 자료는 보존하되, 새로운 평가에
   사용할 분할은 학습·보정·테스트 간 중복이 없도록 별도로 구성해야 한다.

기존 연구용 옵션을 모두 새 기능처럼 확장하지 않는다. 제공하는 경로에 필요한
입력 검사·저장 복구·경로 독립성만 보완한다.

## 검증 기준

- 이관 파일은 원본과 대상의 SHA-256이 같고, 요청한 데이터 4종만 존재한다.
- 설치 후 작업 폴더 밖에서도 import할 수 있다.
- 작은 CPU 피처 입력으로 거리·집계·저장 복원 동작을 확인한다.
- 실제 DINOv2 가중치가 로컬에 있으면 소수 이미지로 fit/score/save/load를 확인한다.
  가중치가 없어 실행하지 못한 검증을 완료했다고 기록하지 않는다.
- 과거 AUROC를 새 라이브러리의 재검증 성능으로 표시하지 않는다.
- 새로운 평가 산출물 형식은 별도로 확정한다. 이번 `results/archive`는 과거 자료이며
  새 실험의 완전한 artifact schema를 충족한다고 주장하지 않는다.

## 대안

전체 연구 폴더 복사는 다른 데이터와 GUI·임시 산출물까지 함께 가져온다.
새 프레임워크 재작성은 검증된 수치 계산을 다시 구현해야 한다.
따라서 기존 코어를 설치 가능한 패키지로 묶는 최소 변경을 권장한다.
