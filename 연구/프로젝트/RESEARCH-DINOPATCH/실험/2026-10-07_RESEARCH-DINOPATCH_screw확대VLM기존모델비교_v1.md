# screw 확대 VLM과 기존 모델 비교

## 질문·변경
확대 4장 VLM이 다른 모델 대비 어느 수준인가? 재학습·API 추가 호출 없이 원본 CSV와 이번 혼동행렬을 확인해 NG 양성 이미지 F1로 비교했다. 이전 15개 비교의 screw VLM 값은 확대 전이므로 이번 결과를 별도 행으로 추가해 해석한다.

## 데이터·측정
MVTec screw 공식 test 160장(정상41·NG119). 과거 저장 image_F1Score와 VLM의 2TP/(2TP+FP+FN)를 비교한다. F1은 정확도가 아니다.

|모델·조건|이미지 F1(%)|
|---|---:|
|PatchCore 과거 실행|95.08|
|EfficientAD 과거 실행|95.04|
|Dinomaly 과거 실행|94.87|
|Qwen3-VL 전체＋확대4장|90.91|
|PaDiM 과거 실행|88.72|
|Qwen3-VL 이전 전체 입력|85.58|
|Qwen3-VL 새 프롬프트 전체 대조군|73.40|

확대 VLM: TP100, TN40, FP1, FN19. 정확도87.50%, F1=200/220=90.9091%. 이전 전체 입력: TP89, FP0, FN30으로 F1=178/208=85.5769%. 새 대조군: TP69, FP0, FN50으로 F1=138/188=73.4043%.

## 한계·결정·다음
저장 수치상 확대 VLM은 이전 VLM보다 좋아졌지만 PatchCore·EfficientAD·Dinomaly에는 F1 약4%p 뒤진다. PaDiM보다는 높다. 그러나 과거 검출기 코드는 SAME_AS_TEST 검증 조건이며 임계값·검증 선택에 테스트 정보가 들어갈 수 있다. 해상도·학습 예산·전처리도 달라 공정한 우열의 확정값이 아니다. 과거 CSV에는 정확도·개별 판정·임계값이 없어 F1이나 det 열에서 정확도를 역산하지 않는다. det는 별도 기준의 검출 수이며 F1 혼동행렬과 섞지 않는다.

새 대조군과 이전 전체 입력 차이도 커 프롬프트·API 공급자·시점 변화 민감성이 남는다. 이번 확대 결과를 모든 카테고리에 일반화하지 않는다. 다음 공정 비교는 같은 FIT/CAL 분리, 미사용 테스트, 고정 임계값의 정확도·오탐·미탐 평가가 필요하다.

## 출처
- 기존 모델 CSV: `E:/DH/Sandbox/sandbox/01_vision/07_anomaly_dino/output/anomalib_bench/result.csv`의 screw 4행을 직접 재확인.
- 평가 코드 사본: `E:/DH/Sandbox/Dinopatch/output/comparisons/all_saved_comparison_20261007_182151/sources/bench_anomalib.py` (SAME_AS_TEST 명시).
- VLM: `E:/DH/Sandbox/Dinopatch/output/comparisons/qwen_screw_four_crops_20261007_184410/metrics.json`의 historical/control/crops 혼동행렬에서 재계산.
- [확대 실험·시각화](2026-10-07_RESEARCH-DINOPATCH_screw확대4장_20261007_184410.md)
- [기존 전체 모델 비교](2026-10-07_RESEARCH-DINOPATCH_전체저장결과비교_20261007_182151.md)

추가 원본 이미지 복사·새 실험·수동 commit/push 없음. 기존 실행 해시와 상세 시각화는 연결한 실험 기록에 유지한다.
