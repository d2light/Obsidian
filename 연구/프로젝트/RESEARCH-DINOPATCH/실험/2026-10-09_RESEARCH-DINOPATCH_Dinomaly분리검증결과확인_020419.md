# Dinomaly 검증/테스트 분리 실행 존재 여부

- 질문: SAME_AS_TEST가 아닌 Dinomaly 결과가 이미 있는가?
- 확인 범위: 현 프로젝트 tools, output/comparisons run/metadata/요약, 프로젝트 연구노트, 원래 anomalib 벤치마크 코드.
- 확인 결과: 15종 과거 benchmark는 SAME_AS_TEST. 현 프로젝트 hazelnut/metal_nut/pill dinomaly_legacy는 해당 v0 checkpoint를 불러온 재추론이며 독립 FIT/CAL 재학습이 아니다. 확인한 범위에서 분리 검증으로 새로 학습한 Dinomaly 결과는 발견하지 못했다.
- 코드 증거: tools/compare_model_scores.py 129행 이후 LEGACY/output/anomalib_bench/runs/Dinomaly/MVTecAD/<category>/v0/weights/lightning/model.ckpt 재사용, scope historical reference 명시. 원 bench_anomalib.py run_one은 MVTecAD 기본 검증 설정으로 fit/test/predict 수행.
- 해석 보완: validation/test 공유가 곧 NG를 학습 gradient에 넣었다는 증거는 아니다. 임계값·후처리·모델 선택과 관련한 평가 편향 위험은 구분해야 한다. 실제 과거 실행의 체크포인트 선택/모든 hook 경로는 이번 점검으로 확정하지 않았다. 따라서 기존 AUROC가 어느 정도 부풀었는지 또는 재학습 시 낮아질지 수치로 단정하지 않는다.
- 변경/실패: 읽기 전용 점검. 신규 학습/추론/모델 수정 없음. 현재 venv에 anomalib 해당 소스 경로가 없어 hook 세부 확인은 미완료.
- 결정/다음: screw 정상 FIT256/CAL64와 원본 TEST160을 유지하여 정상만 학습, test 평가를 학습 후 1회 수행, test 성능 기반 checkpoint 선택 없이 사전 고정 마지막 epoch 사용. 독립 시험 데이터가 새로 생긴 것은 아니므로 반복 관찰된 개발 test라는 한계도 유지.
- 출처: E:/DH/Sandbox/Dinopatch/tools/compare_model_scores.py; output/comparisons/model_scores_20261007_102016/metadata.json; E:/DH/Sandbox/sandbox/01_vision/07_anomaly_dino/experiments/anomalib/bench_anomalib.py
