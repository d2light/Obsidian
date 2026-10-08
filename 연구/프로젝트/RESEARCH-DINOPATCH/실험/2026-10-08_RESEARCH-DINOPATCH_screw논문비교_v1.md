# screw 논문 성능과 현재 VLM 판정 비교

- 질문: 현재 VLM 정확도 95.625%를 논문 결과와 비교하면 어떤가?
- 변경: 신규 학습/API 추론 없이 원 논문 표와 저자 공개 결과 JSON 확인.
- PatchCore 원 논문 부록 Table S1: PatchCore-25 이미지 AUROC 98.1%, -10 97.0%, -1 96.4%. https://arxiv.org/html/2106.08265v2
- ReConPatch Table 5: WRN-50/224 이미지 AUROC 98.52%, WRN-101/480 99.84%. 현 프로젝트 DINO 변형과 다른 모델. https://arxiv.org/html/2305.16713v2
- EfficientAD 저자 공개 per_scenario_results.json의 mvtec_ad/detection/auc_roc/screw: S=0.9731502357040377, M=0.9696249231399877. 각각 97.3150%, 96.9625%. 논문은 EfficientAD 5회 평균을 보고. https://arxiv.org/html/2303.14535v3
- 저자 JSON: https://www.mydrive.ch/shares/79401/c41dcdb937972fb43d5cdd7bfa7072f8/download/449203483-1690527455/per_scenario_results.json
- 실패/복구: web 도구로 일부 PDF 및 JSON 접근 실패. 논문 HTML과 Python urllib JSON 직접 읽기로 확인.
- 현 실험: MVTec AD screw test160(OK41/NG119), 검출기 FIT256/CAL64. VLM+윤곽 정확도95.625%, FP1/FN6; 연속 VLM 이상점수 AUROC 없음. 정확도와 AUROC 수치 간 우열/차이 계산 금지.
- 참고 가능한 동일 지표: VLM 없는 평균맵 이미지 AUROC97.8069%, SAM 후보선택 영역 제한99.508%. 정상 CAL 임계값 정확도는 각각88.75%,94.375%로 지표가 다름.
- 한계: 학습량·해상도·백본·후처리·개발셋 반복 관찰이 다르므로 논문 초과 성능을 입증하지 못함. 논문 AUROC를 정확도나 미탐 건수로 환산할 수 없음.
- 결정/다음: 현재 VLM 개선은 내부 비교 결과로 유지. 공식 기준모델을 같은 분할에서 실행하고 동일 정상 CAL 임계값 규칙으로 정확도·오탐·미탐 비교가 필요. 이번에는 실행하지 않음.
- 로컬 근거: E:/DH/Sandbox/Dinopatch/output/comparisons/vlm_anomaly_contours_20261008_004614/metrics.json; pixel_fusion_no_vlm_20261007_231904/metrics.json; otsu_candidate_mobile_sam_20261008_000558/SUMMARY.md.
- 새 시각화 없음. 기존 [VLM 보고서](http://127.0.0.1:8765/output/comparisons/vlm_anomaly_contours_20261008_004614/index.html) 참조. 수동 commit/push 없음.

- SHA256 vlm_anomaly_contours_20261008_004614/metrics.json: cd0381ca3e81ac6be227c811b56f28d9fa8982fd2b6ad1b021dbc68adcea3b49
- SHA256 pixel_fusion_no_vlm_20261007_231904/metrics.json: 688eba2ab625930d8f5ea00c1d53e4f52a4a76770c1a0c14d33facfad7a3b1aa
- SHA256 otsu_candidate_mobile_sam_20261008_000558/SUMMARY.md: f51b0bdb5c094544e48344909e8f6cd08e5511dcdf0ff54aad503f3a0a04d2c1
