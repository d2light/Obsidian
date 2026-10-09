# Dinomaly grid · 분리 평가

FIT 211 / CAL 53 / TEST 78. 최종100epoch, seed1, batch8, FP32.
영상 AUROC 100.000%, 크롭 내부 픽셀 AUROC 99.432%, 정확도 97.436%, FP2/FN0.
임계값 0.070992835: 정상 CAL95분위 higher, 초과하면 NG. 학습 중 validation/test 없음.
Identical Resize448/CenterCrop392/ImageNet for FIT/CAL/TEST; crop exterior uninspected, no background removal.
Native anomalib: raw reconstruction map392; image score from bilinear256 + Gaussian5 sigma4 + top1%. No postprocessor or test normalization.
80% normal training versus historical full train; isolated calibration; manual loop uses native loss/optimizer with explicit per-step LR schedule. Not a controlled isolation of leakage alone.
원래 test는 반복 관찰한 개발 평가 데이터이며 완전히 새로운 독립 검증 세트는 아님.

- 질문: 테스트를 validation에 사용하지 않은 Dinomaly 성능은?
- 변경: 정상 FIT/CAL 분리, final100 고정. 과거 SAME_AS_TEST와 학습량/스케줄도 달라 단일 원인 효과로 해석하지 않음.
- 검증: 원본/복사본 해시·분리·점수/지표 재계산·맵 원해상도/coverage·체크포인트 재로딩·브라우저 필터와 전체 이미지 로딩 통과.
- 결정/다음: 15종 순차 실행 결과를 모아 비교. test 기반 재학습/튜닝 없음.
- 실행/코드: D:\research_artifacts\Dinopatch\DinoPatch_20261009_033817_Dinomaly_grid_isolated_fit80_cal20_B392_final100 ; E:/DH/Sandbox/Dinopatch/tools/train_dinomaly_isolated.py, tools/report_dinomaly_isolated.py
- 결과 SHA256: 4699c7e1ab248ed720d30971ca2655cfc862af1cd64313fb324bcef5da12808b

![[../첨부/20261009_035743_dinomaly_grid.jpg]]
