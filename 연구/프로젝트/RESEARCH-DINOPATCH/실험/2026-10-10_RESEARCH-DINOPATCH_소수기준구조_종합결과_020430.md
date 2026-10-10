# 소수 정상 기준 구조 비교 결과

## 설정
기존 밝은 정상 기준1/3/5장과 별도CAL5장만 사용. 원본TEST268, 실제dark 기준추가/학습/보정 없음. CAL q95(max5), 기준한장 선택 후 구조거리top1%. NCC<0.5/평행이동±12경계는REVIEW. 원본유지/JPG/수치맵NPY/특징descriptor보존.

## 검증 측정
|방법|AUROC|점수FP/FN|자동FP/FN|REVIEW OK/NG|
|---|---:|---|---|---|
|contrast_k1|78.8277|5/44|5/29|6/37|
|contrast_k3|78.7822|57/21|57/16|0/17|
|contrast_k5|75.4542|45/26|45/20|0/16|
|census_k1|78.3947|93/1|91/1|6/37|
|census_k3|76.5842|63/3|63/3|0/17|
|census_k5|78.1732|65/8|65/8|0/16|
|phase_k1|82.9306|25/51|19/42|6/37|
|phase_k3|70.0879|17/53|17/50|0/17|
|phase_k5|71.3514|1/60|1/57|0/16|

## 한계·결정·다음
밝기순서/위상 표현의 이론적 성질은 실제 어두운 카메라 노이즈·반사 변화와 동일하지 않다. 합성조도 안정성은별도json이며 실환경정확도의 대용이 아니다. 원래224FIT/85CAL 모델과는 표본예산이 다름. 낮은오탐만으로 평가하지 않고 미탐/재확인부담까지 확인. CAL5장으로 임계값 불확실, 원래 개발TEST 반복평가, 단일 기준선택seed. 정합실패는 제외하지 않았다. 후속 모델 채택에는 이 제약과 새로운촬영그룹 독립검증 필요.

![[2026-10-10_few_structure_020430.jpg]]

## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_020430`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
