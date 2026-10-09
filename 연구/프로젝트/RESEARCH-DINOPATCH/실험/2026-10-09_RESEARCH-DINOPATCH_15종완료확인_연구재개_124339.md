# Dinomaly 15종 완료 확인과 연구 재개 제안

- 질문: 용량 정리·데이터 이동 이후 연구를 어디서 재개할 것인가?
- 확인: suite.status=complete. 15개 run 상태 및 저장된 validation.valid, 최종 모델 존재 확인. 카테고리별 metrics와 suite metrics 일치 확인. 현재 MVTec 경로에서15종 원본 train/test 파일 수 확인; 이번 확인에서는 전체 파일 해시를 다시 읽지는 않음.
- 결과: 카테고리 평균 I-AUROC 99.71565%, 평균 accuracy 97.42535%, crop392 P-AUROC 98.39226%. 전체1725장 FP34/FN15.
- 조건: 정상 FIT80/CAL20(해시 그룹 분리), screw FIT256/CAL64, final100 고정, 정상 CAL q95 higher 및 score>threshold. 테스트를 학습·모델선택·임계값 보정에 쓰지 않음. 이전부터 반복 관찰한 개발용 테스트로 새로운 독립 일반화 증거는 아님.
- 주요 실패: screw FP2/FN8, pill FP0/FN5, capsule FP3/FN2, zipper FP13/FN0, transistor FP6/FN0. cable은 이번실험 FP0/FN0.
- 제안(아직 새 실험 실행/방법 채택 아님): screw10개 오류를 먼저 원본/GT/동일색범위 이상맵/점수/임계값/검사crop범위로 분석. 결함 특징 미검출, 전역점수 집계 손실, 검사영역 잘림, 정상변동 과검을 구분한 후 한 요소만 변경.
- 다음 실험 후보: 결함은 맵에 있는데 이미지 점수만 낮다면 score집계 비교를 우선. 맵에 반응이 없으면 해상도/멀티스케일 가설 검증. 잘림 문제면 전체 시야전처리 검증. CAL로만 임계값 선정하고 테스트최적 임계값 선택 금지. 범주별 규칙을 추가하기보다 동일 방법을 다른 대표범주에 고정 적용.
- zipper AUROC100/FP13은 테스트 정상과NG 순위 분리에도 CAL임계값에서 과검한다는 뜻. CAL/test 정상분포 차이 등 보정 원인을 별도로 분석. AUROC100을 실제운영완벽판정으로 해석하지 않음.
- 연구방향: 검증된 기준모델 → 오류원인 규명 → 한모듈 비교 → 회전/위치/조도 및 실제waterseal/bolt의 미관찰 촬영세션 검증. VLM/graph/SAM은 원인상 필요성이 확인된 경우에 한해 비교 대상으로 추가.
- 한계: 중앙crop392 평가이며 grid1건은 crop후 정답결함픽셀이 없어짐. 기존폴더 접근가능성은 원본데이터전체 동일성 재검증과 다름. 다른 이동중 데이터셋의 경로확보는 별도 필요.
- 출처: E:\DH\Sandbox\Dinopatch\output\comparisons\dinomaly_isolated_20261009_021035/suite.json, metrics.json, macro.json, 각run/logs/validation.json 및 model/detector.pt.
- 코드/설정 변경 없음. 원본 복사/수정 및 새 학습 없음.
