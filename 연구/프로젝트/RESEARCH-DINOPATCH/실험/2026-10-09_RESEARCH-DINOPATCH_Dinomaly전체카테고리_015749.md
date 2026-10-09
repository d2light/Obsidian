# Dinomaly 과거 MVTec 15종 실측 재확인

- 질문: Dinomaly 전체 카테고리 AUROC는?
- 변경: 기존 CSV의 dinomaly 15행 재확인 및 카테고리 산술평균 계산. 신규 학습/추론 없음.
- 설정: anomalib Dinomaly, 카테고리별 100epoch, 표준 전체 MVTec test. 원본 코드에 검증 SAME_AS_TEST 명시. 현재 FIT256/CAL64 조건과 다름.
- 한계: test와 validation이 분리되지 않은 과거 참고 결과. 독립 검증 기반 신규 모델과 공정한 비교로 해석하지 않음. 논문 수치가 아님. 앞서 pill99.26은 재추론 결과였고 이 표의99.35는 원래 CSV 결과로 출처를 구분함.

|카테고리|영상 AUROC %|픽셀 AUROC %|
|---|---:|---:|
|bottle|100.00|99.02|
|cable|100.00|98.41|
|capsule|98.72|98.70|
|carpet|99.96|99.33|
|grid|99.83|99.42|
|hazelnut|100.00|99.44|
|leather|100.00|99.29|
|metal_nut|100.00|97.01|
|pill|99.35|98.01|
|screw|97.83|99.61|
|tile|100.00|97.58|
|toothbrush|100.00|98.82|
|transistor|99.58|94.89|
|wood|99.82|97.63|
|zipper|100.00|99.06|
|카테고리 평균|99.67|98.41|

- 결정: 과거 참고 표로 보존. 다음은 같은 FIT/CAL 조건 재학습 시 비교. 실패 없음.
- 출처: `E:\DH\Sandbox\sandbox\01_vision\07_anomaly_dino\output\anomalib_bench\result.csv`
- SHA256: `bdd54f789922d86146052840f39e259816e3d3b6436e70e00b56eb39a2d1c1d2`
- 코드: E:/DH/Sandbox/sandbox/01_vision/07_anomaly_dino/experiments/anomalib/bench_anomalib.py
