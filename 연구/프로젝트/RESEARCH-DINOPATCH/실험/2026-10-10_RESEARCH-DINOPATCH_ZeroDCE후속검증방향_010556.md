# Zero-DCE 후속 검증 방향

## 질문과 확인한 결과
Zero-DCE가 상대적으로 괜찮은 상황에서 다음 실험을 어디로 좁힐지 검토했다. 신규 학습/평가는 실행하지 않았다.
밝은 FIT224/CAL85, 원본 TEST268 조건에서 기존 Dinomaly FP56/FN1, Zero-DCE→고정 Dinomaly FP12/FN18(밝음 FN8, 어둠 FN10). 보정으로 결함이 지워졌다고 단정할 수 없으며 입력 특징 분포/임계값 변화와 구분해야 한다.
지난 보정 후 재구성은 DINO 특징 저장소이며, 보정한 밝은 정상으로 Dinomaly를 재학습한 실험은 아니다.

## 제안 순서
1. Zero-DCE 미탐18장의 원본·보정 영상·동일 위치 확대·이상맵·CAL 대비 점수를 나란히 비교한다. 시각적 결함 보존 여부와 점수/임계값 문제를 분리해서 기록한다.
2. Zero-DCE 가중치를 동결하고, 밝은 정상 FIT와 CAL에도 같은 처리를 적용하여 Dinomaly를 처음부터 동일 설정으로 재학습한다. 실제 어두운 자료는 학습/임계값 설정에 사용하지 않는다. 기존 raw-trained baseline, 보정 추론만, 보정 후 재학습 3조건을 비교한다.
3. 원본 분기와 보정 분기의 결합은 별도 비교조건으로 유지한다. 현재 FP22/FN0 조합은 552개 중 TEST로 선택한 사후 후보이므로 확정 모델로 부르지 않는다. 새 조건의 가중치/임계값을 현재 TEST에 맞춰 최적화하지 않는다.
4. 최종 구성 고정 후 새 촬영 그룹에서 검증. 현재 TEST 재평가는 개발 결과로 명시한다.

## 판단·한계
우선순위는 새로운 모델 추가보다 미탐 원인 확인과 보정 후 Dinomaly 재학습 비교이다. Zero-DCE 단독 적용은 어두운 NG13장 중10장을 놓쳐 채택할 수 없다. 기존 복원기의 외부 사전학습과 현장 밝은 정상만 사용한 학습을 구분한다. 일반화 개선은 아직 가설이다.

## 출처
- E:/DH/Sandbox/Dinopatch/output/comparisons/illumination_screen_20261010_003838/comparison.csv
- E:/DH/Sandbox/Dinopatch/output/comparisons/illumination_screen_20261010_003838/fusion_exploration.json
- E:/DH/Sandbox/Dinopatch/tools/screen_illumination_methods.py
- 이전 종합 시각화: [[2026-10-10_RESEARCH-DINOPATCH_조도23조건종합비교_003838]]
