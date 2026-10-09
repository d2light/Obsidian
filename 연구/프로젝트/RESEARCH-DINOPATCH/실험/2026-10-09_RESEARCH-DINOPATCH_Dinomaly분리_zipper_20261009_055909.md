# Dinomaly zipper · 분리 평가

FIT 192 / CAL 48 / TEST 151. 최종100epoch, seed1, batch8, FP32.
영상 AUROC 100.000%, 크롭 내부 픽셀 AUROC 99.066%, 정확도 91.391%, FP13/FN0.
임계값 0.059295200: 정상 CAL95분위 higher, 초과하면 NG. 학습 중 validation/test 없음.
Identical Resize448/CenterCrop392/ImageNet for FIT/CAL/TEST; crop exterior uninspected, no background removal.
Native anomalib: raw reconstruction map392; image score from bilinear256 + Gaussian5 sigma4 + top1%. No postprocessor or test normalization.
80% normal training versus historical full train; isolated calibration; manual loop uses native loss/optimizer with explicit per-step LR schedule. Not a controlled isolation of leakage alone.
원래 test는 반복 관찰한 개발 평가 데이터이며 완전히 새로운 독립 검증 세트는 아님.

- 질문: 테스트를 validation에 사용하지 않은 Dinomaly 성능은?
- 변경: 정상 FIT/CAL 분리, final100 고정. 과거 SAME_AS_TEST와 학습량/스케줄도 달라 단일 원인 효과로 해석하지 않음.
- 검증: 원본/복사본 해시·분리·점수/지표 재계산·맵 원해상도/coverage·체크포인트 재로딩·브라우저 필터와 전체 이미지 로딩 통과.
- 결정/다음: 15종 순차 실행 결과를 모아 비교. test 기반 재학습/튜닝 없음.
- 실행/코드: D:\research_artifacts\Dinopatch\DinoPatch_20261009_054723_Dinomaly_zipper_isolated_fit80_cal20_B392_final100 ; E:/DH/Sandbox/Dinopatch/tools/train_dinomaly_isolated.py, tools/report_dinomaly_isolated.py
- 결과 SHA256: bd9ec4a7b8d7804c09d0cef77f7bed2661e84f41839c7db3d17fe8ca2138df46

![[../첨부/20261009_055909_dinomaly_zipper.jpg]]
