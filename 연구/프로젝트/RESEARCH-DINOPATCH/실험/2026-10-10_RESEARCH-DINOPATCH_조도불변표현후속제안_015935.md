# 조도에 덜 민감한 표현 후속 제안

## 질문·맥락
RGB 분리 이후 조도 변화에 무엇을 사용할지 검토. 새 학습/실험 미실행, 신규 측정 없음. 이전 Zero-DCE 동일 전처리 Dinomaly 재학습은 채택 보류 상태를 유지한다.

## 후보와 결정 제안
1. Phase Congruency: 여러 주파수/방향의 위상이 일치하는 구조를 표현. 단순 밝기/대비 변화에 덜 민감한 경계·선 단서 후보. 이전 Canny/Scharr 윤곽 추적 및 phaseCorrelate 정합과 다르다.
2. Census/Rank: 국소 픽셀 밝기의 순서 비교. 순서를 보존하는 밝기 변환에 강한 구조 표현 후보. 노이즈, 포화, 그림자 경계 변화에서는 보장되지 않는다.
3. 반사율·조명 분해: 원리상 후보이나 기존 MSR/Retinexformer 실험과 구분해야 하며 현재 우선순위는 낮게 둔다.
우선1/2의 구조맵을 원본·합성 조도쌍·실제 dark 사례에서 시각화하고 정상 구조 안정성과 결함 보존을 함께 확인하는 작은 탐색을 제안한다. bright FIT/CAL 유지, actual dark는 개발평가 전용. 정합 실패는 REVIEW로 집계. 입력표현을 바꾸고 기존 Dinomaly에 곧바로 넣으면 새 입력 분포 불일치가 생기므로 처음에는 해당 표현 자체의 정상 대응/국소 거리부터 확인한다. 새로운 독립 촬영 그룹 검증 전 일반화 성능으로 주장하지 않는다.

## 한계
이 방법들은 이상탐지 완성 모델이 아니라 표현 방법이다. 색상/명암 자체가 결함인 경우 단서를 잃을 수 있다. 정보 소실·반사 변화·공간적으로 다른 조도·노이즈까지 불변이라는 뜻이 아니다. 현장 검사 성능 개선은 가설이다.

## 출처
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
- 기존 실행: E:/DH/Sandbox/Dinopatch/output/comparisons/zero_dce_matched_20261010_010824
- tools/docs 범위에서 phase congruency/census 텍스트 검색 결과 없음. 전체 과거 세션 미실행을 보증하지 않음.
