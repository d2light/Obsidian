---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [RESEARCH_SUMMARY.md](file:///E:/DH/Sandbox/Dinopatch/docs/RESEARCH_SUMMARY.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# 가져온 연구의 핵심

이 문서는 2026-09-28에 복사한 기존 로컬 연구 자료의 요약이다.
여기 적힌 성능은 **이전 실행 결과**이며 이 작업 폴더에서 재학습해 얻은 수치가 아니다.

## 방법

동결 DINOv2 ViT-B/14(register 포함)의 정규화된 패치 피처로 정상 메모리뱅크를 만든다.
각 검사 패치를 정상 뱅크와 cosine 거리로 비교하고, 높은 거리의 패치들을 평균해
이미지 이상 점수를 구한다. 점수가 높을수록 NG 방향이다.
지도는 패치 단위 정상 피처와의 차이이며, 사람이 그린 결함 마스크가 아니다.

현 소스의 기본값은 긴 변 700, coreset 30,000, 정렬 `auto`, 배경 처리 `auto_bg`이다.
오래된 README의 `bank_split` 기본값 표와 다르다.
`auto_bg`는 정상 학습 이미지의 일부를 보정용으로 남겨 테두리 거리 임계를 정하고,
배경 변화가 감지된 검사 이미지에서 자기 테두리를 배경 기준으로 추가한다.

자세한 흐름: [파이프라인 도해](file:///E:/DH/Sandbox/Dinopatch/docs/research/adcore_flow.html),
[배경 처리](file:///E:/DH/Sandbox/Dinopatch/docs/research/bg_process.html), [점수 공간](file:///E:/DH/Sandbox/Dinopatch/docs/research/score_space.html).

## 고정 구성의 기존 결과

| 데이터 | 이미지 AUROC (%) | 무오탐 검출 | 근거 |
|---|---:|---:|---|
| MVTec AD 15종 | 99.50 | 1139/1258 | `auto_bg_d1`, 고정 구성 CSV |
| VisA 12종 | 96.33 | 702/1200 | `auto_bg_d1`, 고정 구성 CSV |
| bolt | 100.00 | 14/14 | 외부 모델 비교 CSV, 머리부 잠정 결함 3장 제외 |
| waterseal | 미확인 | 미확인 | 이관 범위에서 기존 평가 결과를 찾지 못함 |

원자료: [고정 구성 54행](file:///E:/DH/Sandbox/Dinopatch/results/archive/ours_fixed/result.csv),
[bolt 비교](file:///E:/DH/Sandbox/Dinopatch/results/archive/bolt_external/result.csv),
[bolt 이미지별 점수](file:///E:/DH/Sandbox/Dinopatch/results/archive/bolt_external/per_image.csv).

**이관 시 발견한 분할 문제:** 이관 당시 원본 데이터에서 waterseal 정상 테스트 260장 전부와
bolt 정상 테스트 36장이 학습 이미지와 바이트 단위로 동일하다.
MVTec·VisA에서는 카테고리 내 동일 해시 중복이 없었다.
따라서 bolt의 기존 100% 수치를 이 데이터 구성에서의 독립 일반화 성능으로
보증할 수 없다. 당시 실행의 정확한 입력 목록과 현재 분할의 일치 여부도 별도로 확인해야 한다.
새 평가에서는 학습·보정·테스트를 분리해야 한다.
[중복 파일 쌍과 해시](file:///E:/DH/Sandbox/Dinopatch/migration/validation.json).

**현재 작업 폴더는 중복 제거를 완료했다.** 테스트셋을 유지하면서 중복 학습 이미지와
대응 물체 마스크를 격리했다. 정상 학습은 waterseal 444장, bolt 189장이고,
네 데이터 계열 전체의 학습·테스트 동일 RGB 픽셀 중복은 0건이다.
위 과거 수치를 현재 분할의 성능으로 승계하지 않는다.
[현재 분할](file:///E:/DH/Sandbox/Dinopatch/migration/dataset_split.jsonl) · [격리 이력](file:///E:/DH/Sandbox/Dinopatch/migration/quarantine_moves.jsonl).

무오탐 검출은 해당 평가셋 정상 최고점을 임계로 삼는 **사후 평가 통계**다.
운영 임계로 검증된 값이 아니며, 정상 표본 한 장에도 크게 영향을 받는다.
새 운영 임계는 별도의 정상 보정셋에서 정해야 한다.

원본 STATUS는 `bank_split`과 `auto_bg`가 27종에서 완전히 동일하다고 적었지만,
원본 CSV의 MVTec zipper는 99.95 → 99.92, 무오탐 118 → 117이다.
따라서 여기서는 '완전 동일'이라는 표현을 사용하지 않는다.
이전 99.43 결과에는 카테고리별 k를 평가 결과로 선택한 실험이 포함되므로
고정 구성 결과와 구별한다.

## bolt에서 차이가 난 부분

| 방법 | 이미지 AUROC (%) | 무오탐 | PRO@30 (%) |
|---|---:|---:|---:|
| PatchCore | 99.25 | 9/14 | 9.26 |
| PaDiM | 93.92 | 3/14 | 8.73 |
| Dinomaly | 99.61 | 12/14 | 15.53 |
| EfficientAD-S | 96.91 | 11/14 | 40.95 |
| 기존 auto_bg | 100.00 | 14/14 | 91.53 |

원본 비교는 anomalib 기본 256×256 입력, 자체 모델은 긴 변 700의 비율 유지 입력이다.
학습형 모델 예산도 기록된 조건 그대로 읽어야 한다. 같은 입력 해상도와 예산을
통제한 알고리즘 우위 실험으로 해석하면 안 된다.
국소화 비교의 물체 마스크 기준은 U2-Net이다. bolt에 픽셀 Otsu 전경을 적용한
물체 밖 비율은 퇴화하므로 원본 요약에서도 판단에 쓰지 말라고 명시한다.

`head_defect` 3장은 원래 정상에서 분리한 잠정 라벨이다. 검사 사양 확인이 필요하며
결함 정답 마스크도 없다. [원본 분류 메모](file:///E:/DH/Sandbox/Dinopatch/datasets/industrial/bolt/test/head_defect/README.txt).
기존 14/14 결과의 분모는 이 3장을 포함하지 않는다.
[bolt 지도](file:///E:/DH/Sandbox/Dinopatch/docs/research/bolt_maps.html)로 점수가 실제 결함에서 발생하는지 확인한다.

## 유지할 교훈

- 회전은 정렬로 처리하고, 조명 변화는 정상 광도 증강으로 커버하는 접근이 유효했다.
  다만 특정 제품에서 얻은 관찰을 다른 데이터의 성능 보장으로 확대하지 않는다.
- 마스크가 정밀할수록 좋은 것은 아니다. 실루엣 경계 결함을 함께 지울 수 있다.
  [SAM 경계 예시](file:///E:/DH/Sandbox/Dinopatch/docs/research/sam_cut.html).
- 조명 증강이 일부 조건의 오탐을 줄였지만 halo와 새로운 촬영 조건까지 해결한 것은 아니다.
  [조명 지도](file:///E:/DH/Sandbox/Dinopatch/docs/research/illum_maps.html), [복원 시도](file:///E:/DH/Sandbox/Dinopatch/docs/research/illum_restore_why.html),
  [후속 실험 요약](file:///E:/DH/Sandbox/Dinopatch/results/archive/illum_next/summary.txt).
- AUROC와 국소화를 함께 확인한다. 배경 변화가 불량 라벨과 겹치면
  배경을 보고 높은 AUROC를 낼 수 있다.
- EfficientAD의 단일 실행 편차가 크다. 원본의 '200 epoch는 과적합' 결론은
  후속 비교표에서 철회되었다. 오래된 README보다 근거가 정리된
  [기존 비교표](file:///E:/DH/Sandbox/Dinopatch/references/legacy/RESULTS.md)를 우선한다.

## 비교 논문 자료

원본 PDF 5편과 추출 텍스트를 [results/papers](file:///E:/DH/Sandbox/Dinopatch/results/papers)에 보존했다.
논문별 표·페이지·설정은 [출처 목록](file:///E:/DH/Sandbox/Dinopatch/results/SOURCES.md)과
[행별 비교표](file:///E:/DH/Sandbox/Dinopatch/results/paper_per_category.csv)에 있다.

| 자료 | 보존한 비교 맥락 |
|---|---|
| PatchCore, 2106.08265 | 정상 패치 메모리뱅크 계열 비교, 부록 S1/S2/S3 |
| SimpleNet, 2303.15140 | single-class 기준선, Table 1 |
| EfficientAD, 2303.14535 | 저자 공개 JSON과 MVTec/VisA 파생표; 5회 평균 조건 |
| MambaAD, 2404.06564 | single-class와 multi-class 표를 명확히 구분 |
| Dinomaly, 2405.14325 | 보존 자료의 발표값은 multi-class; 로컬 single-class 재현과 구분 |

[방법별 최고 발표값](file:///E:/DH/Sandbox/Dinopatch/results/paper_best_baselines.md)은 여러 출처 중 높은 값을
선택한 참고표다. 동일 기계·동일 분할 재현표가 아니다.
논문 발표값, anomalib 로컬 재현, 자체 모델 결과를 하나의 동일 조건 순위로 섞지 않는다.
EfficientAD 저자 JSON에는 LOCO 수치도 들어 있지만 출처 파일 무결성을 위해 그대로 보존했으며,
LOCO 데이터나 별도 LOCO 파생표는 가져오지 않았다.

## 자료 보존과 한계

- [전체 기존 레지스트리](file:///E:/DH/Sandbox/Dinopatch/results/registry.csv)는 MVTec·VisA·bolt 범주의 원본 1275행을 보존한다.
- [기존 상태 문서](file:///E:/DH/Sandbox/Dinopatch/references/legacy/STATUS.md)는 과거 기록이며 새 라이브러리 사용 설명서가 아니다.
- 대형 모델 체크포인트, 피처 캐시, 전체 히트맵 중복, GUI, 다른 제품 데이터는 이관하지 않았다.
- 과거 결과 묶음에는 모든 실행의 모델·원해상도 수치 지도·환경 정보가 완비되어 있지 않다.
  새 artifact 표준을 충족하는 재현 실행으로 간주하지 않는다.
- [이관 명세](file:///E:/DH/Sandbox/Dinopatch/migration/files.jsonl)에 복사 파일별 원본 상대경로, 대상 상대경로,
  크기, 전체 SHA-256을 기록한다. 복사 시 원본·대상 해시를 대조했다.
  이후 격리된 학습 파일의 현재 위치는 `migration/quarantine_moves.jsonl`로 추적한다.
