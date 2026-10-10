# Dinomaly 15종 오탐·미탐 갤러리

기존 정상 CAL 임계값에서 발생한 전체49장(FP34/FN15)의 원본·GT·이상맵·점수/임계값을 정리했다. 재학습·재추론·임계값 변경 없음. 기존JPG/수치맵을 재사용하며 입력 복사0. crop 밖은 미검사 영역이고 색상은 카테고리 CAL 픽셀q99.5 기준이다.

원본 해시와 오류 집계 재검산을 확인했다. headless Edge에서 카테고리/오류종류48개 조합 필터,49개 이미지 표시, JS오류0을 확인하고 화면을 직접 검토했다. 과거 개발TEST 결과이며 새 독립평가가 아니다. MVTec49건 검토 이후 제조데이터 비교를 별도 진행한다.

[갤러리](http://127.0.0.1:8765/output/comparisons/dinomaly_errors_20261009_141340/index.html)
출처: tools/report_dinomaly_errors.py 및 output/comparisons/dinomaly_errors_20261009_141340/validation.json, logs/browser_validation.json.
