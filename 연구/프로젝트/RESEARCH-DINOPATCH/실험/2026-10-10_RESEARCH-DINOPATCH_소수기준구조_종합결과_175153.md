# 소수 정상 기준 구조 비교 결과

## 설정
기존 밝은 정상 기준1/3/5장과 별도CAL5장만 사용. 원본TEST268, 실제dark 기준추가/학습/보정 없음. CAL q95(max5), 기준한장 선택 후 구조거리top1%. NCC<0.5/평행이동±12경계는REVIEW. 원본유지/JPG/수치맵NPY/특징descriptor보존.

## 검증 측정
|방법|AUROC|점수FP/FN|자동FP/FN|REVIEW OK/NG|
|---|---:|---|---|---|
|profile_k5|97.6490|0/30|0/30|0/34|
|profile_relative_k5|94.1973|0/30|0/30|0/34|
|profile_stable_k5|99.5767|0/29|0/29|0/34|
|profile_combined_k5|99.9935|0/34|0/34|0/34|
|mind_k5|73.9043|2/82|2/66|0/16|
|profile_stable_measured_k5|97.9551|71/0|71/0|0/34|
|profile_combined_measured_k5|99.6288|67/0|67/0|0/34|

## 한계·결정·다음
밝기순서/위상 표현의 이론적 성질은 실제 어두운 카메라 노이즈·반사 변화와 동일하지 않다. 합성조도 안정성은별도json이며 실환경정확도의 대용이 아니다. 원래224FIT/85CAL 모델과는 표본예산이 다름. 낮은오탐만으로 평가하지 않고 미탐/재확인부담까지 확인. CAL5장으로 임계값 불확실, 원래 개발TEST 반복평가, 단일 기준선택seed. 정합실패는 제외하지 않았다. 후속 모델 채택에는 이 제약과 새로운촬영그룹 독립검증 필요.

![[2026-10-10_few_structure_175153.jpg]]

## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_175153`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
