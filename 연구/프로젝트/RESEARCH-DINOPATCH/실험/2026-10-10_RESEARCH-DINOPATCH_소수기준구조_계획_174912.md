# 소수 정상 기준의 조도 변화 구조 비교

사용자 목표: 조도 변화마다 신규이미지를 추가하지 않고 기존 정상 몇장으로 양불 판단. 별도 밝은 정상CAL5장, 최대총10장. 실제dark 추가/학습/임계값 보정 없음. 동일 원본TEST268장. 정합실패REVIEW별도 집계. CAL5장으로 추정한 임계값의 불확실성, 고정시야/평행이동만 취급하는 범위, 개발TEST를 명시. 새 측정 전 설정 고정.

이번 실행 방법 ('profile_relative', 'profile_stable', 'profile_combined', 'mind'), 기준 수 (5,). silhouette는 선행9조건을 관찰한 후 추가한 Otsu경계거리 비교 가설이며 워터씰 형상에 맞춘 개발 탐색이다.

아직 결과 미측정.

## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_174912`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
