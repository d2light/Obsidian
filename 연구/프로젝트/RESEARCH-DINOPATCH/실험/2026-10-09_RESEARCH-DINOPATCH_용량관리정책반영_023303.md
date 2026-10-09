# 저장공간을 고려한 프로젝트 지침 반영

- 사용자 요청: 앞으로 보고서·시각화는 JPG, 입력/정답 마스크 유지, 학습 이미지는 복사 대신 원본 경로 참조, 용량을 계속 고려하도록 프로젝트 지침화.
- 변경: 프로젝트 AGENTS.md 및 docs/OUTPUT_STORAGE_POLICY.md 작성. vault 운영/기록 규칙.md에 해당 프로젝트 정책 위치만 연결. 공용skill 변경 없음.
- 필수 정책: 원본/상대경로/SHA256/FIT-CAL-TEST역할 기록; 원본 보존; 시각화 JPG품질95; 수치맵 유지; 재현필수/재계산캐시 분리; 중간checkpoint 최신1개+final; 자동기존삭제 금지.
- 용량 절차: 실행전 예상 최대추가저장량125%+10GiB 여유 확인, checkpoint/평가/완료 시 현재run만 점유/여유 기록. 새Dinomaly부터 logs/storage_plan.json 및 storage_usage.json 기록.
- 적용 검증: 3프로토콜테스트(분할/임계값/원본참조), 보고서경로차단/허용테스트 통과. bottle신규run input_storage=references, data아래PNG0개 실제확인. 원본해시 검사 후 입력 로딩.
- 기존PNG: 100장probe quality95/subsampling0에서100747952→27537115bytes. 보고서용3188장만 백업후변환 진행중, original/input/mask/GT표시/기존JPG충돌 등180개 제외. 완료값은 후속기록. 입력·마스크 변환 없음.
- 실패/해결: screw최종학습 후 프로세스에 로드된 구형validator가PNG진단파일을 요구해 마무리 실패. 새검증기로 학습 재실행 없이 복구, standalone검증 통과(224예측,160test,480sourcehashes). 결과 I-AUROC98.893%, 정확도93.75%, FP2/FN8. JPG지원변경이 점수에 영향을 주지 않음.
- 상태: screw완료, bottle부터 입력참조·JPG·용량로그 적용해15종계속. PID34736, output/dinomaly_isolated_20261009_023200_stdout.log/stderr.log.
- 한계: 과거screw복사본은 아직보존; 전체과거 입력복사본 삭제승인과 PNG변환승인은 다름. 다른프로젝트에는 자동적용하지 않음.
- 코드: E:/DH/Sandbox/Dinopatch/AGENTS.md; docs/OUTPUT_STORAGE_POLICY.md; tools/train_dinomaly_isolated.py; tools/report_dinomaly_isolated.py; tools/compact_visuals.py; tools/serve_results_dashboard.py; tests/test_dinomaly_isolated.py; tests/test_compact_visuals.py; tests/test_report_storage.py.
