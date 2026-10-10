# 고정된 소수 밝은 정상 기준: 13조건 연구 결론

## 질문과 변경
조도마다 새 정상 이미지를 추가하지 않고 기존 밝은 정상 몇 장의 특징 비교로 양불을 판정할 수 있는가? 정상 기준 1/3/5장과 별도 밝은 CAL5장만 사용했다. 새로운 어두운 이미지를 학습/기준/임계값 설정에 사용하지 않았다. 신경망 학습 없이 특징 비교했다.

## 데이터·설정
원본 waterseal TEST268: 밝음 OK134/NG70, 어두움 OK51/NG13. 기존 FIT/CAL의 서로 다른 촬영 그룹에서 seed1/2로 각각 선택; 경로/해시 참조, 원본 복사·변경 없음. 임계값은 CAL5의 q95 higher(최댓값), score > threshold. 최초 contrast/Census/Phase 9조건 이후 Otsu 거리 3조건, 정상 CAL 폭 차이 관찰 후 경계 잔차 1조건 추가. 반복 사용한 개발 TEST이며 독립 일반화 평가가 아니다.

## 검증된 측정
최선 순위분리 profile_k5 AUROC97.648974%, 점수 이진판정 FP0/FN30. 품질검사까지 적용한 실제 자동판정: 정상185장 전부 자동OK; 불량83장 중 자동NG19, 자동OK30, 재확인34. 재확인34를 검출 성공으로 세지 않는다. 어두운 NG13장은 모두 미탐. 어두운 그룹 내부 AUROC100%만으로 해결됐다고 판단할 수 없다.

## 원인·한계
profile은 Otsu 상하 경계에서 완만한 추세(sigma12)를 제거해 국소 꺾임을 비교한다. CAL0193 점수1.871277이 임계값, CAL0377도1.598081로 높다. dark NG 점수1.010818~1.323011은 이 임계값 아래다. 정상 형태 다양성과 작은 CAL 표본이 실제 판정을 어렵게 한다. TEST를 보고 임계값을 낮추거나 CAL을 사후 제외하지 않았다. K1 조건은 CAL1장 자체가 REVIEW라 운영 후보에서 제외한다. 고정 시야의 일부 ROI만 검사하며 회전 일반화와 넓고 완만한 결함 보존은 미검증이다.

## 결정·다음
이번 구성 채택 보류. 조도마다 기준 이미지를 보충하지 않는 목표 유지. 다음은 동일한 기존 정상만으로 경계 추출의 신뢰도와 정상 폭/곡률 차이를 분리하고, 국소 결함 신호를 보존하는 비교를 검토한다. 임계값 문제를 개발 TEST 최적화로 숨기지 않는다. 최종 주장은 별도 평가가 필요하다.

## 검증·저장
13개 방법별 산출물 검증과 지표 재계산 완료. 브라우저 카드13, 사례268, 첫/중간/끝 선택, 링크27 검사 통과, JS 오류0. JPG 시각화, NPY 수치맵, 원본 경로 참조; 새 입력 복사0. pytest 미설치로 해당 명령은 실패했고 기존 unittest 러너로 확인했다. Git 커밋/push는 하지 않았다.

## 실행 경로
- output/comparisons/few_reference_structure_20261010_020430 (9조건)
- output/comparisons/few_reference_structure_20261010_021201 (Otsu 3조건)
- output/comparisons/few_reference_structure_20261010_021613 (profile 및 통합 보고서)
- output/experiments/DinoPatch_20261010_021613_illum_profile_k5_waterseal
- tools/probe_few_reference_structure.py / tools/report_few_reference_structure.py
- http://127.0.0.1:8765/output/comparisons/few_reference_structure_20261010_021613/comparison.html

## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_021613`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
