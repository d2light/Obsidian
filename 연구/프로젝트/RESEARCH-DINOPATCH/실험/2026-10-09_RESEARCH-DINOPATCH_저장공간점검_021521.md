# 연구 산출물 저장공간 점검

- 질문: 원본 데이터셋 및 반복 연구 PNG가 차지하는 용량은?
- 방법: E:/DH/Sandbox/Dinopatch 아래 파일 stat 크기 합계, 하위 junction 제외. 논리 파일 크기이며 실제 할당 크기/중복 제거 가능 용량과 다름. 실행 중 추가 파일은 집계 시점 이후 변할 수 있음.
- 측정: output213.42GiB/257930파일. datasets9.83GiB/35389파일. references7.45GiB. PNG는 E:output62415장/36.602GiB. data경로44224장29.069GiB, 시각화·보고서 경로3372장3.207GiB, 기타14819장4.326GiB. 경로 분류만으로 중복 여부 확정하지 않음.
- 데이터 상세: MVTec4.909GiB/6642파일, VisA1.787GiB/12023, industrial0.970GiB/9774, auxiliary1.357GiB/5675, waterseal실험복사본2종 각0.185GiB/581, waterseal증강0.435GiB/112. datasets전체를 순수 원본 크기로 해석하지 않음. D:/datasets 전체는 이번 범위 아님.
- 대용량: output/comparisons/dinopatch_vs_anomalydino_20261008_135801/model/bank.npy 15728640128bytes(14.648GiB). 해당 폴더19.872GiB. 특징은행·원해상도맵·모델복사본 등이 누적.
- 변경: 기존 파일 삭제/이동 없음. 새 Dinomaly run만 D:에 저장하고 E:report 경로junction 연결. 서버403 원인은 resolve후E:만 허용하는 경로 검사였음. D:/research_artifacts/Dinopatch만 추가허용, 경로통과/차단 테스트 통과, 실제보고서 HTTP200 확인. 디렉터리 목록 차단 유지.
- 결정/다음: 기존 실험 이동/정리는 별도 사용자 요청 시 실행. 진행 중15종 Dinomaly 학습 유지.
- 출처: output/storage_audit_20261009.json, output/png_audit_20261009.json; tools/serve_results_dashboard.py; tests/test_report_storage.py.
