# 워터씰 Dinomaly 점수 분포 확인

질문: 밝음/어두움과 정상/불량의 점수 분포는 어떻게 다른가? 기존 점수만 다시 시각화했다. 신규 학습·API·임계값 보정·원본 수정 없음.

밝은 정상 CAL85, TEST 밝은 정상134/불량70, 어두운 정상51/불량13. 현재 정상 CAL q95 임계값 0.095551424 유지. 어두운 정상 최대 0.190814391, 불량 최소 0.191624388, 관찰 간격 0.000809997. 어두운 조건 AUROC100은 이번 표본의 순서 분리를 뜻하며 여유가 크다는 뜻은 아니다. 밝음/어두움 전체가 공통 임계값으로 해결됐다는 기존 해석은 하지 않는다. 어두운 TEST 정답으로 새 임계값을 선택하지 않았다.

![[워터씰_Dinomaly_원점수_20261009_214051.jpg]]

한계: 반복 관찰한 개발 데이터, 어두운 불량13장. 간격이 좁으므로 별도 어두운 정상으로 보정한 뒤 독립 TEST에서 검증해야 한다. 다음 단계는 별도 보정/평가 분할 확보이며 이번에는 실행하지 않았다.

원본 점수 SHA256: `6458790088b3b6c24ca5da0ac082f67a49a5e0e9e7c7484a197499942e20508b`. 입력·출력 수353건, 조건별85/134/70/51/13 확인, 기존 점수 파일 해시 불변/JPG 디코딩 검증. 신규 저장량은 JPG와 메타데이터뿐이며 입력 복사0.

- 점수 출처: `E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261009_180251_field_waterseal_dinomaly\predictions\per_image.json`
- 재현 코드: `E:\DH\Sandbox\Dinopatch\output\comparisons\waterseal_dinomaly_scores_20261009_214051\logs\source.py`
- [분포 보고서](http://127.0.0.1:8765/output/comparisons/waterseal_dinomaly_scores_20261009_214051/index.html)
