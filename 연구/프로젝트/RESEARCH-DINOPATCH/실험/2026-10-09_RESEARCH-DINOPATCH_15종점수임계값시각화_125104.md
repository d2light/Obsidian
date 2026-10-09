# Dinomaly 15종 점수·임계값 시각화

- 질문: 임계값 재설정만으로 정상·불량을 모두 맞힐 수 있는가?
- 원본 실험: output/comparisons/dinomaly_isolated_20261009_021035. 정상 FIT/CAL 분리, final100, CAL q95 higher, score > threshold이면 NG.
- 저장된 CAL/TEST 점수만 읽어 시각화. 재학습·재추론·원본 이미지 복사 없음. 원본 임계값·점수 파일 해시 불변 검증.
- 카테고리별 산점도, 전체 JPG, 원시점수 JSON/요약 CSV, 개별 이미지 점수표, 임계값 슬라이더 제공.
- TEST 정상 최고점 <= threshold < TEST 불량 최저점이면 해당 테스트 FP/FN 모두0. 완전분리9종, 중첩6종.
- zipper: CAL임계값 0.059295199811, 정상최고점 0.086464568973, 불량최저점 0.087658375502, 참고중간값 0.087061472237. 기존FP13/FN0 → 참고값FP0/FN0.
- 사후 구간/중간값은 TEST정답을 사용한 설명용이며 배포 또는 공정한 독립 성능값이 아님. 운영 임계값을 이 값으로 바꾸지 않음. 범주별 점수축이 다르고 raw점수는 범주간 비교척도가 아님.
- 검증: CAL q95, AUROC, 기존FP/FN 재계산. 9종 참고중간값FP/FN0 확인. 브라우저15종 선택, 슬라이더 양극단/복원, 참고값9종/중첩버튼차단6종, 점세부정보, JPG15장 로딩 통과. JS오류0.
- 최초 브라우저 검사는 디버깅포트 준비 전 연결해 ECONNREFUSED. 브라우저 준비 후 동일검사를 재실행해 통과; 보고서 변경 없이 복구.
- 링크: http://127.0.0.1:8765/output/comparisons/dinomaly_scores_20261009_124918/index.html 또는 index.html 로컬열기.
- 소스: tools/report_dinomaly_scores.py; source_hashes는 validation.json.

- 결정: 기존CAL임계값 유지. TEST사후구간은 설명용으로만 보존. 후속은 CAL/TEST 정상분포 차이 분석 및 별도보정 검증.
- 산출물: E:\DH\Sandbox\Dinopatch\output\comparisons\dinomaly_scores_20261009_124918
- 용량: 3.63MiB. 이미지복사0, 보고서이미지JPG.

![[../첨부/20261009_125104_dinomaly_scores_zipper.jpg]]
