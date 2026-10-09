# MVTec 15종 전체 평균 비교

| 모델 | 카테고리 평균 I-AUROC |
|---|---:|
| Dinomaly 현재 FIT/CAL 분리 | 99.7156% |
| dinomaly (과거 로컬) | 99.6731% |
| DINO Patch fixed/bank_split | 99.4993% |
| DINO Patch plain700 | 99.2607% |
| patchcore (과거 로컬) | 98.2518% |
| efficient_ad (과거 로컬) | 97.0201% |
| padim (과거 로컬) | 89.7093% |

- 질문: screw가 아닌 전체 카테고리 성능에서 Dinomaly가 가장 좋은가?
- 동일한15종이 각 모델에 하나씩 존재함을 확인하고 카테고리별 단순평균 계산. 논문 수치는 제외. 과거결과는 기록된 로컬실험 CSV이며 이번에 재실행한 값이 아님.
- 결론: 이번에 확인한 전체15종 로컬결과 중 Dinomaly 평균AUROC가 가장 높음. 기존DINO Patch 고정 bank_split 대비 약0.216%p 높음.
- 한계: 모델별 FIT/CAL/전처리/학습 설정이 동일하지 않음. 과거anomalib에는validation/test 공유 조건이 있어 공정한동일조건 순위확정으로 해석하지 않음. AUROC는 판정정확도와 다르며 모든개별카테고리 우위를 뜻하지 않음.
- 방향: Dinomaly를 전체기준모델 후보로 두고 범주공통 개선을 검증하는 근거. screw에만 최적화하지 않음. 새학습·배포·임계값 변경 없음.
- 출처: E:\DH\Sandbox\Dinopatch\output\comparisons\dinomaly_overall_comparison_20261009_131631/summary.json; results/registry.csv; E:/DH/Sandbox/sandbox/01_vision/07_anomaly_dino/output/anomalib_bench/result.csv; E:\DH\Sandbox\Dinopatch\output\comparisons\dinomaly_isolated_20261009_021035/metrics.json
